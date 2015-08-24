-- =============================================================
-- Copyright Roaming Gamer, LLC. 2009-2014 
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
builders.round 		= require "scripts.builders.round"
builders.square 	= require "scripts.builders.square"
builders.coins 		= require "scripts.builders.coins"
builders.monster 	= require "scripts.builders.monster"
builders.spikes 	= require "scripts.builders.spikes"

----------------------------------------------------------------------
--								DECLARATIONS						--
----------------------------------------------------------------------
-- Variables
local layers
local pieces
local currentLevel = 1

-- Forward Declarations
local onReloadLevel 
local onNextLevel

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
	local levels 	= require "scripts.levelLoader"
	local levelData = levels.get( levelNum )	
	pieces = {}
	for i = 1, #levelData do		
		table.dump(levelData[i])
		local data = levelData[i]
		local builder = builders[data.type]
		local tmp = builder.create( layers, data, pieces )
	end

	-- 
	-- 5. Create Buttons (for inputs)
	-- 
	inputs.create( layers )

	--
	-- 6. Add a 'coin' counter with some event listeners to count picked up coins and count clearing.	
	--
	local curCount = 0
	local coinCounter = display.newText( layers.overlay, "Coins: 0", left + 10, top + 30, "HarrowPrint", 40 )
	coinCounter.anchorX = 0
	-- This listener handles 'incrementing' the counter on 'coin pickups'
	coinCounter.onPickup = function( self )
		if( self.removeSelf == nil ) then
			Runtime:removeEventListener( "onPickup", self )
			return
		end
		curCount = curCount + 1
		coinCounter.text = "Coins: " .. curCount
	end
	Runtime:addEventListener( "onPickup", coinCounter )

	--
	-- 7. Add a 'level' indicator
	--
	local levelIndicator = display.newText( layers.overlay, "Level: " .. levelNum, right - 10, top + 30, "HarrowPrint", 40 )
	levelIndicator.anchorX = 1


	--
	-- 8. Track 'current' level for reloads and advancing to next level
	--
	currentLevel =  levelNum
end

-- 
-- destroy() - Destroys the current level
--
function public.destroy( )	
	inputs.destroy()
	display.remove( layers )
	layers = nil
	pieces = nil
end

--
-- Level Reload and Load Next 'Listeners'
--
onReloadLevel = function()
	print("onReloadLevel", currentLevel )
	public.create( currentLevel )
	return true
end
onNextLevel = function()
	print("onNextLevel", currentLevel, onNextLevel )
	-- Increment level and load it. (If higher than maxLevels, start at 1 again )
	--
	currentLevel = currentLevel + 1
	if( currentLevel > common.maxLevels ) then
		currentLevel = 1
	end
	public.create( currentLevel )
	public.destroy()
	public.create( currentLevel )
	return true
end
Runtime:addEventListener( "onReloadLevel", onReloadLevel )
Runtime:addEventListener( "onNextLevel", onNextLevel )



return public