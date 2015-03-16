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
local cameraM 	= require "scripts.camera"
local particleM = require "scripts.particles"

----------------------------------------------------------------------
--								DECLARATIONS						--
----------------------------------------------------------------------
-- Variables
local layers
local player
local isRunning 	= false
local spd 			= 200
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

	-- Create a simple circle as our player for now
	--
	player = display.newCircle( layers.content3, centerX, centerY, playerRadius )
	player.x = centerX
	player.y = centerY
	player:setFillColor( unpack( playerFill ) )
	player.alpha = 0.5

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
		if( event.phase == "began") then			
			self:removeEventListener( "collision" )
			public.stop()
			print( "I hit a wall!")
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
			player:setLinearVelocity( spd, -spd )
		else
			self.curDirection = "left"
			player:setLinearVelocity( -spd, -spd )
		end
	end
	listen( "onOneTouch", player )

	-- Add simple 'enterFrame' listener to player
	--
	player.enterFrame = function( self )
		particleM.draw( layers.content3, self, playerRadius - 4 )
		cameraM.update( self, layers.world )
	end
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
	player:setLinearVelocity( -spd, -spd )

end

-- Clean up the module (and optionally unload it from memory)
function public.stop()	
	print("Starting player module.")

	if( not isRunning ) then return end

	-- Toggle the 'isRunning' Flag
	--
	isRunning = false

	-- Stop player motion
	--
	player:setLinearVelocity( 0, 0 )

	-- Stop listening for 'one-touch'	
	--
	--ignore( "onOneTouch", player )

	-- Stop listening for 'enterFrame'
	--
	--ignore( "enterFrame", player )

	-- Restart the game in one second, then wait one second to move
	--
	timer.performWithDelay( 3000, function() post("onRestart", { delay = 1000 } ) end )

end

-- Clean up the module (and optionally unload it from memory)
function public.cleanup( path )	
	print("Cleaning up player module.")
	display.remove( player )
	player = nil
	layers = nil
end

-- Return the current player
public.getPlayer = function()
	return player
end





return public