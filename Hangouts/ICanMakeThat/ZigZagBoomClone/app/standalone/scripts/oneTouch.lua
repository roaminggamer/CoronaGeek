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
	--local touchPad = display.newImageRect( layers.underlay, "images/fillT.png", fullw, fullh )
	local touchPad = display.newImageRect( layers.overlay, "images/fillW.png", fullw, fullh )
	touchPad.x = centerX
	touchPad.y = centerY
	touchPad.alpha = 0.2

	-- Add a simple 'touch' listener that in turn generates a 'onOneTouch' event
	--
	touchPad.touch = function( self, event )
		if(event.phase == "began") then
			print("Posting onOneTouchEvent!")
			post( "onOneTouch", {} )
			self:setFillColor(0,1,0) -- debug visual feedback
		elseif(event.phase == "ended" ) then
			self:setFillColor(1,1,1) -- debug visual feedback 
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