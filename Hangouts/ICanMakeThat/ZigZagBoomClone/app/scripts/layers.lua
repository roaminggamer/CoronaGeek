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
	layers.world 		= display.newGroup()
	layers.parallax1	= display.newGroup()
	layers.parallax2	= display.newGroup()
	layers.parallax3	= display.newGroup()
	layers.content 		= display.newGroup()
	layers.overlay 		= display.newGroup()

	layers:insert( layers.underlay )
	layers:insert( layers.world )
	layers:insert( layers.overlay )

	layers.world:insert( layers.parallax1 )
	layers.world:insert( layers.parallax2 )
	layers.world:insert( layers.parallax3 )
	layers.world:insert( layers.content )

	return layers
end

return public