-- =============================================================
-- Copyright Roaming Gamer, LLC. 2009-2014 
-- =============================================================
-- 
-- =============================================================
local public = {}

----------------------------------------------------------------------
--								REQUIRES							--
----------------------------------------------------------------------
local collision = require "scripts.collision"

----------------------------------------------------------------------
--								DECLARATIONS						--
----------------------------------------------------------------------
-- Variables
local layers

-- Forward Declarations

-- Localizations
local mRand             = math.random
local getTimer          = system.getTimer
local pairs             = pairs

-- SSK
local angle2VectorFast 	= ssk.math2d.angle2VectorFast
local addVectorFast 	= ssk.math2d.addFast
local subVectorFast 	= ssk.math2d.subFast
local scaleVectorFast 	= ssk.math2d.scaleFast


----------------------------------------------------------------------
--								DEFINITIONS							--
----------------------------------------------------------------------
-- Initialize module
function public.init( parent, params )	
	layers = parent
	params = params or {}
	print("Initializing wall module.")
end

-- Clean up the module (and optionally unload it from memory)
function public.cleanup( path )	
	print("Cleaning up wall module.")
	layers = nil
end

-- Create a new wall segment
function public.newSegment( x, y, angle, length, width )	

	-- 1 - Calculate a single line and draw it
	local vx,vy = angle2VectorFast( angle )
	vx,vy = scaleVectorFast( vx, vy, length )
	vx,vy = addVectorFast( vx, vy, x, y )
	--local line = display.newLine( layers.content2, x, y, vx, vy ) 
	--line.strokeWidth = 1	

	----[[
	-- 2 - Place a rectangle over the line
	local mx,my = vx - x, vy - y
	mx = mx/2 + x
	my = my/2 + y
	--local leftWall = display.newRect( layers.content2, mx, my, 4, length )
	--leftWall.rotation = angle
	--]]

	-- 3 - Replace the rectangle with two lines 'centered' on line
	----[[
	local leftWall = display.newRect( layers.content2, mx - width/2, my, 4, length + 4)
	local rightWall = display.newRect( layers.content2, mx + width/2, my, 4, length + 4 )
	leftWall.rotation = angle	
	rightWall.rotation = angle
	--]]

	-- 4 - Beautify (a little)
	-- Colorize the walls
	----[[
	local fillColor1 = { 0xa8/255, 0xcb/255, 0xde/255 }
	leftWall:setFillColor( unpack( fillColor1 ) )
	rightWall:setFillColor( unpack( fillColor1 ) )
	--]]

	-- Add path background	
	----[[
	local sqrt2 = math.sqrt(2)
	local fillColor2 = { 0x09/255, 0x2f/255, 0x5c/255 }
	local pathBack = display.newRect( layers.content1, mx, my, width/sqrt2, length )
	pathBack:setFillColor( unpack( fillColor2 ) )
	pathBack.rotation = angle

	local pathBack = display.newRect( layers.content1, vx, vy, width/sqrt2, width/sqrt2 )
	pathBack:setFillColor( unpack( fillColor2 ) )
	pathBack.rotation = angle
	--]]

	-- Add a simple 'glow'
	----[[
	local leftGlow = display.newRoundedRect( layers.content3, mx - width/2 + 2, my, 9, length + 6, 3)
	local rightGlow = display.newRoundedRect( layers.content3, mx + width/2 - 2, my, 9, length + 6, 3 )
	leftGlow.rotation = angle	
	rightGlow.rotation = angle
	leftGlow:setFillColor( unpack( fillColor1) )
	rightGlow:setFillColor( unpack( fillColor1) )
	leftGlow.alpha = 0.15
	rightGlow.alpha = 0.15
	--]]

	-- 5 - Add bodies to rectangles
	----[[
	physics.addBody( leftWall, "static" )
	physics.addBody( rightWall, "static" )
	--]]

	return vx, vy
end



return public