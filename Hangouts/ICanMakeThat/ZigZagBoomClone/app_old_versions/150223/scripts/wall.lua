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
	print("Initializing wall module.")
end

-- Clean up the module (and optionally unload it from memory)
function public.cleanup( path )	
	print("Cleaning up wall module.")
	layers = nil
end

-- Create a new wall segment
function public.create( params )	
	layers = parent
	params = params or {}
	print("Initializing wall module.")
end



return public