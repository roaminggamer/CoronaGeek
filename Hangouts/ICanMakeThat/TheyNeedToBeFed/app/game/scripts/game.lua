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

local sound 		= require "scripts.sound"

local common 		= require "scripts.common"

local inputs 		= require "scripts.inputs"

-- Create a table of known 'builders'
local builders = {}
builders.player 	= require "scripts.builders.player"
builders.round 		= require "scripts.builders.round"
builders.charles 	= require "scripts.builders.charles"

builders.square 	= require "scripts.builders.square"
builders.timedround = require "scripts.builders.timedround"
builders.hpath 		= require "scripts.builders.hpath"
builders.vpath 		= require "scripts.builders.vpath"

builders.coins 		= require "scripts.builders.coins"
builders.monster 	= require "scripts.builders.monster"
builders.spikes 	= require "scripts.builders.spikes"

----------------------------------------------------------------------
--								DECLARATIONS						--
----------------------------------------------------------------------
-- Variables
local layers
local pieces
local currentLevel 		= 1
local coinsCollected 	= 0

-- Forward Declarations
local onReloadLevel 
local onNextLevel
local onSound

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
local lastGroup
function public.create( levelNum, group )	
	group = group or lastGroup or display.currentStage
	lastGroup = group
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

	group:insert( layers )


	--
	-- 3. Draw blue background
	--
	local back = display.newRect( layers.underlay, centerX, centerY, fullw, fullh )
	back:setFillColor( 0.2, 0.6, 1 )

	-- 
	-- 4. Build the level
	-- 
	local levels 	= require "scripts.levelLoader"
	local levelData = levels.get( levelNum )	
	pieces = {}
	for i = 1, #levelData do		
		table.dump(levelData[i])
		local data 		= levelData[i]
		local builder 	= builders[data.type]
		local tmp 		= builder.create( layers, data, pieces )
	end

	-- 
	-- 5. Create Buttons (for inputs)
	-- 
	inputs.create( layers )

	--
	-- 6. Add a 'coin' counter with some event listeners to count picked up coins and count clearing.	
	--
	coinsCollected 			= 0
	local maxCoins 			= levels.countCoins( levelNum ) or 3
	local onCoins 			= {}
	local offCoins 			= {}

	if( maxCoins > 0 ) then
		local function updateHUD()
			for i = 1, maxCoins do
				onCoins[i].isVisible  = (coinsCollected >= i)
				offCoins[i].isVisible = (i > coinsCollected)
			end
		end

		local lastImage
		for i = 1, maxCoins do
			onCoins[i] = display.newImageRect( layers.overlay, "images/kenney/coin1.png", 50, 50 )
			onCoins[i].x = left + 40 + 60 * (i - 1)
			onCoins[i].y = top + 40

			offCoins[i] = display.newImageRect(  layers.overlay, "images/kenney/coin2.png", 50, 50 )
			offCoins[i].x = left + 40 + 60 * (i - 1)
			offCoins[i].y = top + 40

			lastImage = offCoins[i]
		end

		updateHUD()
		
		lastImage.onPickup = function( self )
			if( autoIgnore( "onPickup", self ) ) then return end
			coinsCollected = coinsCollected + 1
			updateHUD()
		end
		listen( "onPickup", lastImage )
	end

	--
	-- 7. Add a 'level' indicator
	--
	local levelIndicator = display.newText( layers.overlay, "Level: " .. levelNum, right - 140, top + 30, "HarrowPrint", 40 )
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
--Runtime:addEventListener( "onReloadLevel", onReloadLevel )
--Runtime:addEventListener( "onNextLevel", onNextLevel )
listen( "onReloadLevel", onReloadLevel )
listen( "onNextLevel", onNextLevel )


return public