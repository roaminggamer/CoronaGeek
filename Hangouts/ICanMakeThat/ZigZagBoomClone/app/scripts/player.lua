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
local collision = require "scripts.collision"

----------------------------------------------------------------------
--								DECLARATIONS						--
----------------------------------------------------------------------
-- Variables
local layers
local player
local isRunning = false
local spd = 60

-- Forward Declarations

-- Localizations
local mRand             = math.random
local getTimer          = system.getTimer
local pairs             = pairs

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
	player = display.newCircle( centerX, centerY, 15)
	physics.addBody( player, { radius = 15, isSensor = true } )	
	player.curDirection = "left"

	-- Add a simple collision listener that stops the player on collision
	-- We'll add more logic later
	--
	player.collision = function( self, event )
		if( event.phase == "began") then
			public.stop()			
			self:removeEventListener( "collision" )
			print( "I Died!")
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

	-- Toggle the 'isRunning' Flag
	--
	isRunning = false

	-- Stop player motion
	--
	player:setLinearVelocity( 0, 0 )

	-- Stop listening for 'one-touch'	
	--
	listen( "onOneTouch", player )

end



-- Clean up the module (and optionally unload it from memory)
function public.cleanup( path )	
	print("Cleaning up player module.")
	display.remove( player )
	player = nil
	layers = nil
end

return public