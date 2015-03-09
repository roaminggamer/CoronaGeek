-- =============================================================
-- Copyright Roaming Gamer, LLC. 2009-2014 
-- =============================================================
-- 
-- =============================================================
local public = {}

----------------------------------------------------------------------
--								REQUIRES							--
----------------------------------------------------------------------
-- none

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

----------------------------------------------------------------------
--								DEFINITIONS							--
----------------------------------------------------------------------
-- Initialize module
function public.init( parent, params )	
	layers = parent
	params = params or {}
	print("Initializing one-touch module.")

	-- Create a touchable object
	--
	local touchPad = display.newRect( layers.underlay, centerX, centerY, fullw, fullh )

	-- Add a simple 'touch' listener that in turn generates a 'onOneTouch' event
	--
	touchPad.touch = function( self, event )
		if(event.phase == "began") then
			print("Posting onOneTouchEvent!")
			post( "onOneTouch", {} )
		end
		return true
	end
	touchPad:addEventListener( "touch" )
end

-- Clean up the module (and optionally unload it from memory)
function public.cleanup( path )	
	print("Cleaning up oneTouch module.")
	layers = nil
end

return public