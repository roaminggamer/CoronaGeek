-- =============================================================
-- Copyright Roaming Gamer, LLC. 2009-2014 
-- =============================================================
-- 
-- =============================================================
local public = {}

----------------------------------------------------------------------
--								REQUIRES							--
----------------------------------------------------------------------
local cameraM 	= require "scripts.camera"
local CBE = require("CBEffects.Library")
local pex = require "scripts.pex"

----------------------------------------------------------------------
--								DECLARATIONS						--
----------------------------------------------------------------------
-- Variables
local layers
local player
local isRunning 	= false
local spd 			= 150
local spd2			= spd
local spdIncr 		= 10
local playerRadius 	= 15
local playerFill 	= { 0xa8/255, 0xcb/255, 0xde/255, 1 }

-- Forward Declarations

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
	layers = parent
	params = params or {}
	print("Initializing player module.")

	-- Reset spd2 to starting value
	--
	spd2 = spd

	-- Create a simple circle as our player for now
	--
	player = display.newCircle( layers.content3, centerX, centerY, playerRadius )
	player.x = centerX
	player.y = centerY
	player:setFillColor( unpack( playerFill ) )
	player.alpha = 0.2 	

	-- Create a nice looking emmitter object to 'cover' our ugly circle player
	--
	player.myEmitter = pex.loadRG( layers.content3, centerX, centerY, "particles/emitter28773.rg",  { texturePath = "particles/" } )

	-- Add a basic physics body and set this object to be a 'sensor' (no physical response to collisions)
	physics.addBody( player, { radius = playerRadius, isSensor = true } )	

	-- Initialize key variables
	player.curDirection = "left" 	-- Starting movement direction ('left' or 'right')

	-- Initialize the camera
	--
	cameraM.init( player )

	-- Add a simple collision listener that stops the player on collision
	-- We'll add more logic later
	--
	player.collision = function( self, event )
	    local phase = event.phase
	    local other = event.other

		if( phase == "began" ) then			

			-- Did we hit a trigger? If so, give us another point!
			--
			if( other.isTrigger == true ) then
				post( "onScore" )
				print( "I hit a trigger!")			

			-- Nope, not a trigger.  Must be a wall. End the session.
			--
			else
				self:removeEventListener( "collision" )
				public.stop()
				print( "I hit a wall!")
			end
			-- NOTE: Moved restart code to stop() function below
		end
		return true
	end
	player:addEventListener( "collision" )

	-- Add a 'one-touch' listener to change player movement direction
	--
	player.onOneTouch = function( self, event )
		print("Received onOneTouchEvent!")
		if( not isRunning ) then return end -- Don't do anything till running
		
		-- Change direction and velocity based on current direction
		if(self.curDirection == "left" ) then			
			self.curDirection = "right"
			player:setLinearVelocity( spd2, -spd2 )
		else
			self.curDirection = "left"
			player:setLinearVelocity( -spd2, -spd2 )
		end

		-- Increment speed for each 'turn'
		--
		spd2 = spd2 + spdIncr

		-- Post an 'onSpeed' event to update the speed HUD
		--
		post( "onSpeed", { speed = spd2 } )


	end
	listen( "onOneTouch", player )


	-- Add simple 'enterFrame' listener to player
	--
	player.enterFrame = function( self )
		player.vent.x = player.x
		player.vent.y = player.y
		cameraM.update( self, layers.world )
	end

	-- Create vent and start it
	--
	player.vent = CBE.newVent({ preset = "burn2", parentGroup = layers.content3 })
	player.vent:start()


	-- Start listening for 'enterFrame'
	--
	listen( "enterFrame", player )

	return player
end


-- Clean up the module (and optionally unload it from memory)
function public.start()	
	print("Starting player module.")

	-- Toggle the 'isRunning' Flag
	--
	isRunning = true

	-- Start player moving
	--
	player:setLinearVelocity( -spd2, -spd2 )

	-- Post an 'onSpeed' event to update the speed HUD
	--
	post( "onSpeed", { speed = spd2 } )

end

-- Clean up the module (and optionally unload it from memory)
function public.stop()	
	print("Starting player module.")

	-- Abort!  The game isn't running yet
	--
	if( not isRunning ) then return end

	-- Toggle the 'isRunning' Flag
	--
	isRunning = false

	-- Stop player motion
	--
	player:setLinearVelocity( 0, 0 )

	-- Stop listening for 'one-touch'	
	--
	ignore( "onOneTouch", player )

	-- Stop listening for 'enterFrame'
	--
	ignore( "enterFrame", player )

	-- Restart the game in one second, then wait one second to move
	--
	timer.performWithDelay( 3000, function() post("onRestart", { delay = 1000 } ) end )
end

-- Clean up the module (and optionally unload it from memory)
function public.cleanup( path )	
	print("Cleaning up player module.")	

	-- Destroy the 'nicer emitter' covering our player
	--
	display.remove(player.myEmitter)

	-- Stop and destroy the CBEfects Vent
	--
	player.vent:stop()
	player.vent:destroy()

	-- Destroy the player
	--
	display.remove( player )

	-- Clear local references to objects
	--
	player = nil
	layers = nil
end

-- Return the current player
public.getPlayer = function()
	return player
end





return public