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
end

-- Clean up the module (and optionally unload it from memory)
function public.cleanup( path )	
	print("Cleaning up player module.")
	layers = nil
end

return public