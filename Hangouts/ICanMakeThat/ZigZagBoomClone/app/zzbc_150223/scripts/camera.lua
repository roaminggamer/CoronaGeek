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
local group
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
function public.init( inGroup, params )	
	group = inGroup
	params = params or {}
end

-- Clean up the module (and optionally unload it from memory)
function public.cleanup( path )	
	group = nil
	-- If path is supplied, completely unload the module
	if( path ) then
		package.loaded[path] = nil
    	_G[path] = nil	
    end
end

return public