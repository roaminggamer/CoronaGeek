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
function public.create( parent, params )	
	parent = parent or display.currentStage
	params = params or {}
	print("Creating render layers.")

	layers 				= display.newGroup()
	layers.underlay 	= display.newGroup()
	layers.content 		= display.newGroup()
	layers.overlay 		= display.newGroup()

	layers:insert( layers.underlay )
	layers:insert( layers.content )
	layers:insert( layers.overlay )

	--[[ Final Layer Order (bottom-to-top)
	\
	|---\underlay
	|
	|---\content
	|
	|---\overlay
	]]

	return layers
end

-- Initialize module
function public.cleanup( )	
	print("Cleaning up wall module.")

	-- Destroy the layers parent group, all child groups, and all child objects in 
	-- one fell swoop!  Booya!
	--
	display.remove(layers)

	-- Clear local references to objects
	--	
	layers = nil
end

return public