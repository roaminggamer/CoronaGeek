-- =============================================================
-- Copyright Roaming Gamer, LLC. 2009-2015
-- =============================================================
-- RGEasy Inputs - One Stick Example
-- =============================================================
-- 								License
-- =============================================================
--[[
	> RGEasyInputs is free to use.
	> RGEasyInputs is free to edit.
	> RGEasyInputs is free to use in a free or commercial game.
	> RGEasyInputs is free to use in a free or commercial non-game app.
	> RGEasyInputs is free to use without crediting the author (credits are still appreciated).
	> RGEasyInputs is free to use without crediting the project (credits are still appreciated).
	> RGEasyInputs is NOT free to sell for anything.
	> RGEasyInputs is NOT free to credit yourself with.
]]
-- =============================================================
display.setStatusBar(display.HiddenStatusBar)  -- Hide that pesky bar
io.output():setvbuf("no") -- Don't use buffer for console messages
-- =============================================================


-- =============================================================
-- Step 1. - Load SSK 
-- =============================================================
require "ssk.loadSSK"

-- =============================================================
-- Step 2. - Load RGEasyInputs
-- =============================================================
local easyInputs = require "RGEasyInputs.loadEasyInputs"

-- =============================================================
-- Step 3. - The example
-- =============================================================
local physics = require("physics")
physics.start()
physics.setGravity(0,9.8)
--physics.setDrawMode( "hybrid" )

local group = display.newGroup()

-- Initialize 'input'
--
easyInputs.oneStick.create( group, { debugEn = true, joyParams = { doNorm = true } } )


-- Create a room and a 'ball' in the room
--
ssk.display.rect( group, left, centerY, { w = 20, h = fullh-40, fill = _W_, anchorX = 0  }, { bodyType = "static" } )
ssk.display.rect( group, right, centerY, { w = 20, h = fullh-40, fill = _W_, anchorX = 1  }, { bodyType = "static" } )
ssk.display.rect( group, centerX, top, { w = fullw, h = 20, fill = _R_, anchorY = 0  }, { bodyType = "static" } )
ssk.display.rect( group, centerX, bottom, { w = fullw, h = 20, fill = _B_, anchorY = 1 }, { bodyType = "static" } )
local ball = ssk.display.imageRect( group, centerX, centerY - 50, "smiley.png", { size = 40 }, { radius = 20 } )

-- Start listenering for the two touch event
--
physics.setGravity(0,0)
ball.isFixedRotation = true
ball.linearDamping = 0.5
ball.forceX = 0
ball.forceY = 0
ball.x = centerX
ball.y = centerY

ball.enterFrame = function( self )
	if( self.removeSelf == nil ) then
		ignore( "enterFrame", self )
		return 
	end
	self:applyForce( self.forceX, self.forceY, self.x, self.y )
end; listen( "enterFrame", ball )

ball.onJoystick = function( self, event )
	if( self.removeSelf == nil) then
		ignore( "onJoystick", self )
		return 
	end
	if( event.state == "on" ) then
		self.forceX = 15 * event.nx
		self.forceY = 15 * event.ny
		self.rotation = event.angle
	elseif( event.state == "off" ) then
		self.forceX = 0
		self.forceY = 0

	end
	return false
end; listen( "onJoystick", ball )
