-- =============================================================
-- Copyright Roaming Gamer, LLC. 2009-2015
-- =============================================================
--                              License
-- =============================================================
--[[
    > This example is free to use.
    > This example is free to edit.
    > This example is free to use as the basis for a free or commercial game.
    > This example is free to use as the basis for a free or commercial non-game app.
    > This example is free to use without crediting the author (credits are still appreciated).
    > This example is NOT free to sell as a tutorial, or example of making jig saw puzzles.
    > This example is NOT free to credit yourself with.
]]
-- =============================================================
local game = {}

local physics 		= require "physics"
physics.start()
physics.setGravity(0,0)
--physics.setDrawMode( "hybrid" )

-- Localizations
local newCircle 	= ssk.display.newCircle
local newRect 		= ssk.display.newRect
local newImageRect 	= ssk.display.newImageRect
local easyIFC   	= ssk.easyIFC
local mRand 		= math.random
local isValid 		= display.isValid
local newAngleLine 	= ssk.display.newAngleLine
local newLine 		= ssk.display.newLine
local subVec 		= ssk.math2d.sub
local lenVec 		= ssk.math2d.length

local mAbs 			= math.abs

-- Locals
--
local levelGroup	-- Level Group
local levelBack 	-- Editor background
local markers 		-- Editor grid markers
local theBall		

local pieceSize 	= 40

local ballSize 		= 15
local ballRadius 	= 0.6 * ballSize/2
local ballSpeed 	= 100

local sqrt2 		= math.sqrt(2)
local offset 		= sqrt2/2 * ballRadius
local bumperSize 	= pieceSize - 2 * offset

local goalSize 		= 20

local levelW		= 480
local levelH		= 320
local ox			= -levelW/2 + pieceSize/2
local oy			= -levelH/2 + pieceSize/2
local cols 			= levelW/pieceSize
local rows 			= levelH/pieceSize


-- Forward Declarations
--
local createBumper
local createGoal
local createBall

local function restoreLevel( levelName )
	local levelTable = table.load( levelName )
	if( not levelTable ) then return end
	for i = 1, #levelTable do
		local element = levelTable[i]
		local tx = element.x
		local ty = element.y
		local piece 

		if( element.pieceType == "bumper1") then
			piece = createBumper(tx,ty, false)
		
		elseif( element.pieceType == "bumper2") then
			piece = createBumper(tx,ty,true)
		
		elseif( element.pieceType == "goal") then
			piece = createGoal(tx,ty)
		
		elseif( element.pieceType == "ball") then
			piece = createBall(tx,ty)

		end

		-- Make additional adjustments based on the existence of helper
		-- methods (if any)
		if( piece.setAngle ) then
			piece:setAngle( element.rotation )
		
		elseif( piece.startMoving ) then
			piece:startMoving( element.rotation )
		
		else
			piece.rotation = element.rotation
		end
	end
end


-- Unified bumper drawing code w/ 'setAngle' method
--
createBumper = function ( x, y, canTurn )
	local shape = 
	{ 
		-bumperSize/2, -bumperSize/2,
		bumperSize/2, bumperSize/2,
		-bumperSize/2, bumperSize/2,
	}

	local tmp = newImageRect( levelGroup, x, y, "images/triangle2.png", 
		{ size = bumperSize, fill = (canTurn) and _P_ or _W_,
		  x0 = x, y0 = y },
		{ bodyType = "static", shape = shape, bounce = 1, friction = 0 } )


	if( canTurn ) then
		tmp.onTouch = function( self, event )
			if( autoIgnore( "onTouch", self ) ) then return false end

			self:setAngle( self.rotation + 90 )
			return false
		end; listen( "onTouch", tmp )
		
	end
	
	function tmp.setAngle( self, angle ) -- angle == 0, 90, 180, 270 (ONLY!)
		angle = ssk.misc.normRot2( angle )

		self.rotation = angle

		if(angle == 0) then

			self.x = self.x0 - offset
			self.y = self.y0 + offset
		
		elseif(angle == 90) then
			self.x = self.x0 - offset
			self.y = self.y0 - offset

		elseif(angle == 180) then
			self.x = self.x0 + offset
			self.y = self.y0 - offset
		
		else
			self.x = self.x0 + offset
			self.y = self.y0 + offset
		end
	end

	local throb
	throb = function( self )
		transition.to( self, { xScale = 1.1, yScale = 1.1, time = 350 } )
		transition.to( self, { xScale = 1, yScale = 1, delay = 350, time = 350, onComplete = throb } )
	end
	throb( tmp )

	return tmp
end

-- Function to build new goal in editor area.
--
createGoal = function( x, y )
	local onCollision = function( self, event )
		local other = event.other
		if(event.phase == "began") then
			other:setLinearVelocity( 0, 0 ) 
			transition.to( other, { x = self.x, y = self.y, time = 250  } )
			transition.to( other, { xScale = 0.05; yScale = 0.05, alpha = 0, delay = 250, time = 250  } )
			timer.performWithDelay( 500, 
				function()
					easyIFC:quickLabel( levelGroup, "You Won!", 0, 0, gameFont, 40, _G_ )	
				end )
		end
	end

	local tmp = newImageRect( levelGroup, x, y, "images/circle.png", 
		{ size = goalSize, pieceType = "goal" }, 
		{ collision = onCollision, isSensor = true } ) 
	
	return tmp
end

-- Function to build new ball in editor area.
--
createBall = function( x, y )
	local onEnterFrame = function( self )
		if( autoIgnore( "enteFrame" , self ) ) then return end
		local dx = mAbs( self.x - levelBack.x )
		local dy = mAbs( self.y - levelBack.y )
		if( dx > levelW/2 or dy > levelH/2 ) then
			ignore( "enterFrame", self )
			display.remove( self )
			easyIFC:quickLabel( levelGroup, "You Lost!", 0, 0, gameFont, 40, _R_ )	
		end
	end

	local tmp = newImageRect( levelGroup, x, y, "images/yellow_round.png", 
		{ size = ballSize, pieceType = "ball",
		  enterFrame = onEnterFrame },
		{ radius = ballSize/2, isFixedRotation = true, 
		  bounce = 1, friction = 0, isBullet = true } )
	
	tmp.startMoving = function( self, angle )
		if( angle == 0 ) then
			tmp:setLinearVelocity( 0, -ballSpeed )
		elseif( angle == 90 ) then
			tmp:setLinearVelocity( ballSpeed, 0 )
		elseif( angle == 180 ) then
			tmp:setLinearVelocity( 0, ballSpeed )
		elseif( angle == 270 ) then
			tmp:setLinearVelocity( -ballSpeed, 0 )
		end
	end
	theBall = tmp

	return tmp
end

-- Module entry point
--
-- Tip: You can load a specifically named file if you want.
-- This is the first of a few modifications you need to make 
-- to start making this into a real game.
--
function game.run( levelName )
	levelName = levelName or "myLevel.json"

	-- Destroy old level group and create new one
	display.remove(levelGroup)
	levelGroup = display.newGroup()
	levelGroup.x = centerX
	levelGroup.y = centerY

	-- Game Background and 'One-touch' catcher.
	local function onTouch( self, event )
		if( event.phase == "began" ) then
			post("onTouch")
		end
		return true
	end
	levelBack = newRect( levelGroup, 0, 0, { w = levelW, h = levelH, fill = hexcolor("#154088"), touch = onTouch } )

	markers = {}
	for col = 1, cols do
		for row = 1, rows do
			local marker = newRect( levelGroup, pieceSize * (col - 1) + ox, pieceSize * (row - 1) + oy, { size = 4, alpha = 0 } )
			marker._data = { index = #markers+1 }
			markers[#markers+1] = marker
		end
	end

	restoreLevel( levelName )

	if( isValid( theBall ) ) then theBall:toFront() end 

	return levelGroup
end

return game