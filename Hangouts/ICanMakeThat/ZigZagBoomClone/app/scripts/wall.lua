-- =============================================================
-- Copyright Roaming Gamer, LLC. 2009-2014 
-- =============================================================
-- 
-- =============================================================
local public = {}

----------------------------------------------------------------------
--								REQUIRES							--
----------------------------------------------------------------------
local collision 	= require "scripts.collision"
local playerM 		= require "scripts.player"

----------------------------------------------------------------------
--								DECLARATIONS						--
----------------------------------------------------------------------
-- Variables
local layers
local pathWidth 		= 200
local lastX				= centerX
local lastY 			= centerY
local lastAngle 		= 45
local printSegmentCount = true
local wallSegments 		= {} 

local sqrt2 			= math.sqrt(2)
local trackLengths 		= { 100, 140, 180, 320, 360  }
local minOffset 		= fullh * 2 -- Reasonable offset distance for 'adding' and 'removing' segments.


-- Forward Declarations
local onEnterFrame

-- LUA/Corona Localizations
local mRand             = math.random
local getTimer          = system.getTimer
local pairs             = pairs

-- SSK Localizations
local angle2VectorFast 	= ssk.math2d.angle2VectorFast
local addVectorFast 	= ssk.math2d.addFast
local subVectorFast 	= ssk.math2d.subFast
local scaleVectorFast 	= ssk.math2d.scaleFast


----------------------------------------------------------------------
--								DEFINITIONS							--
----------------------------------------------------------------------
-- Initialize module
function public.init( parent, params )	
	print("Initializing wall module.")
	layers = parent
	params = params or {}
	wallSegments = {}
	lastX = centerX
	lastY = centerY
	lastAngle = 45
end

-- Clean up the module (and optionally unload it from memory)
function public.cleanup( path )	
	print("Cleaning up wall module.")
	wallSegments = nil	
	layers = nil
	lastX = centerX
	lastY = centerY
	lastAngle = 45
end

-- Create a new wall segment
function public.newSegment( length )	
	local x 
	local y
	
	-- If length is specified, this is first segment.
	-- Calculate x,y based on length	
	--	
	if( length ) then
		x = centerX + (length/2) / sqrt2
		y = centerY + (length/2) / sqrt2

	-- Otherwise, grab last stored x and y and select random length
	--
	else
		x = lastX
		y = lastY
		length = trackLengths[mRand(1,#trackLengths)]
	end

	-- Select an angle
	--
	local angle = (lastAngle == 45) and -45 or 45

	-- Calculate a single line and draw it
	--
	local vx,vy = angle2VectorFast( angle )
	vx,vy = scaleVectorFast( vx, vy, length )
	vx,vy = addVectorFast( vx, vy, x, y )
	--local line = display.newLine( layers.content2, x, y, vx, vy ) 
	--line.strokeWidth = 1	

	-- Place a rectangle over the line
	--
	local mx,my = vx - x, vy - y
	mx = mx/2 + x
	my = my/2 + y

	-- Replace the rectangle with two lines 'centered' on line
	--
	local leftWall = display.newRect( layers.content2, mx - pathWidth/2, my, 4, length + 4)
	local rightWall = display.newRect( layers.content2, mx + pathWidth/2, my, 4, length + 4 )
	leftWall.rotation = angle	
	rightWall.rotation = angle

	-- Beautify (a little)
	-- Colorize the walls
	local fillColor1 = { 0xa8/255, 0xcb/255, 0xde/255 }
	leftWall:setFillColor( unpack( fillColor1 ) )
	rightWall:setFillColor( unpack( fillColor1 ) )

	-- Add path background	
	local sqrt2 = math.sqrt(2)
	local fillColor2 = { 0x09/255, 0x2f/255, 0x5c/255 }
	local pathBack = display.newRect( layers.content1, mx, my, pathWidth/sqrt2, length )
	pathBack:setFillColor( unpack( fillColor2 ) )
	pathBack.rotation = angle

	local pathBack2 = display.newRect( layers.content1, vx, vy, pathWidth/sqrt2, pathWidth/sqrt2 )
	pathBack2:setFillColor( unpack( fillColor2 ) )
	pathBack2.rotation = angle

	-- Add a simple 'glow'
	local leftGlow = display.newRoundedRect( layers.content3, mx - pathWidth/2 + 2, my, 9, length + 6, 3)
	local rightGlow = display.newRoundedRect( layers.content3, mx + pathWidth/2 - 2, my, 9, length + 6, 3 )
	leftGlow.rotation = angle	
	rightGlow.rotation = angle
	leftGlow:setFillColor( unpack( fillColor1) )
	rightGlow:setFillColor( unpack( fillColor1) )
	leftGlow.alpha = 0.15
	rightGlow.alpha = 0.15

	-- Add bodies to rectangles
	physics.addBody( leftWall, "static" )
	physics.addBody( rightWall, "static" )

	-- Debug code for printing total segments in world
	--
	if( wallSegments and printSegmentCount ) then		
		wallSegments[leftWall] = leftWall
		wallSegments[rightWall] = rightWall
		wallSegments[pathBack] = pathBack
		wallSegments[pathBack2] = pathBack2
		wallSegments[leftGlow] = leftGlow
		wallSegments[rightGlow] = rightGlow
		print( "Created new segment at ", x, y, table.count(wallSegments), getTimer() )
	end

	-- Store last x, y, and angle
	--
	lastX = vx
	lastY = vy
	lastAngle = angle

	-- Return last track end positions
	--
	return vx, vy
end

-- Draw new segments if needed
--
public.drawSegmentIfNeeded = function( player )
	local player = playerM.getPlayer()

	-- Abort if missing segments list or player reference
	--
	if( not wallSegments or not player ) then return end

	-- Test to see if we need to generate a new segment.
	--
	local dy = player.y - lastY
	if(dy < minOffset) then
		public.newSegment()
	end
end

-- Remove segments if needed
--
public.removeSegmentsIfNeeded = function()
	local player = playerM.getPlayer()

	-- Abort if missing segments list or player reference
	--
	if( not wallSegments or not player ) then return end


	-- Remove all segments that are far enough off screen to no longer be visible
	--
	local deleteY = player.y + minOffset
	for k, v in pairs( wallSegments ) do
		if( v.y > deleteY ) then
			timer.performWithDelay( 1,
				function()
					display.remove(v)
					wallSegments[k] = nil
					--v:setFillColor(1,0,0)
				end )			
		end
	end
end


-- Return the current wall segments list
public.getSegments = function()
	return wallSegments
end

return public