-- =============================================================
-- Copyright Roaming Gamer, LLC. 2009-2015 
-- =============================================================
-- 
-- =============================================================
local public = {}

----------------------------------------------------------------------
--								REQUIRES							--
----------------------------------------------------------------------
local physics 		= require "physics"

local common 		= require "scripts.common"

local inputs 		= require "scripts.inputs"

-- Create a table of known 'builders'
local builders = {}
builders.player 	= require "scripts.builders.player"
builders.circle1 	= require "scripts.builders.circle1"
builders.square1 	= require "scripts.builders.square1"

----------------------------------------------------------------------
--								DECLARATIONS						--
----------------------------------------------------------------------
-- Variables
local layers
local pieces

-- Forward Declarations

-- Localizations
local mRand             = math.random
local getTimer          = system.getTimer
local pairs             = pairs

----------------------------------------------------------------------
--								DEFINITIONS							--
----------------------------------------------------------------------
-- 
-- create() - Creates a new level.
--
function public.create( levelNum )	

	local levels 	= require "data.levels"
	local levelData = levels.get( levelNum )	

	--
	-- 1. Destroy old level if it exists
	--
	public.destroy()

	--
	-- 2. Create rendering layers for our game with this
	--    final Layer Order (bottom-to-top)
	--
	--[[

		display.currentStage\
							|---\underlay
							|
							|---\content 
							|
							|---\overlay
	
	--]]
	layers 				= display.newGroup()
	layers.underlay 	= display.newGroup()
	layers.content 		= display.newGroup()
	layers.overlay 		= display.newGroup()
	layers:insert( layers.underlay )
	layers:insert( layers.content )
	layers:insert( layers.overlay )


	--
	-- 3. Draw blue background
	--
	local back = display.newRect( layers.underlay, centerX, centerY, fullw, fullh )
	back:setFillColor( 0.2, 0.6, 1)

	-- 
	-- 4. Build the level
	-- 
	pieces = {}
	for i = 1, #levelData do
		local data = levelData[i]
		local builder = builders[data.type]
		local tmp = builder.create( layers, data, pieces )
	end

	-- 
	-- 5. Create Buttons (for inputs)
	-- 
	inputs.create( layers )

end

-- 
-- destroy() - Destroys the current level
--
function public.destroy( path )	
	display.remove( layers )
	layers = nil
	pieces = nil
end


return public