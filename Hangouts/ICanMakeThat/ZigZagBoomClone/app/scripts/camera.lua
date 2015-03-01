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
local w 		= display.contentWidth
local h 		= display.contentHeight
local centerX 	= display.contentCenterX
local centerY 	= display.contentCenterY

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
	print("Initializing camera module.")
end

-- Clean up the module (and optionally unload it from memory)
function public.cleanup( path )	
	print("Cleaning up camera module.")
	layers = nil
end

return public