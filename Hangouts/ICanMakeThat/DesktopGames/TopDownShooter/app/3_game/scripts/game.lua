-- =============================================================
-- Copyright Roaming Gamer, LLC. 2009-2015 
-- =============================================================
-- This content produced for Corona Geek Hangouts audience.
-- You may use any and all contents in this example to make a game or app.
-- =============================================================
local curFrame = 0
listen( "enterFrame", function() curFrame = curFrame + 1 end )

local public = {}

----------------------------------------------------------------------
--								REQUIRES							--
----------------------------------------------------------------------
local physics 			   = require "physics"
local common 			   = require "scripts.common"

-- Makers (builder)
local layersMaker		   = require "scripts.layersMaker"
local debugMaker 		   = require "scripts.debugMaker"

local groundMaker 		= require "scripts.groundMaker"
local reticleMaker 		= require "scripts.reticleMaker"
local playerMaker 		= require "scripts.playerMaker"

-- Managers
local cameraMgr 			= require "scripts.cameraMgr"

----------------------------------------------------------------------
--								DECLARATIONS						--
----------------------------------------------------------------------
-- Variables

-- Forward Declarations

-- Localizations
local mRand             = math.random
local getTimer          = system.getTimer
local pairs             = pairs

----------------------------------------------------------------------
--								DEFINITIONS							--
----------------------------------------------------------------------

-- 
-- destroy() - Destroys the current level
--
function public.destroy( )	
	if( common.isRunning ) then
		physics.pause() -- safer than stopping which might cause errors in future calls that 
	   		            -- come in enterFrame, collisio, or timer listeners
	end

	common.isRunning = false	   
end


-- 
-- create() - Creates a new level.
--
function public.create( group )	
	--
	-- Destroy old level if it exists
	--
	public.destroy()
   
   --
   -- Set up rendering layers for this 'game'
   --
   local layers = layersMaker.create( group )
   
	--
	-- Draw Background
	--
	groundMaker.create()

   --
	-- Draw World Content
	-- 
	local reticle 	= reticleMaker.create()
	local player 	= playerMaker.create( reticle )

   debugMaker.showPlayerMovementLimit()

	-- 
	-- Start The Camera
	-- 
	cameraMgr.attach( player )
   --cameraMgr.detach()
	 

	common.isRunning = true
end


-- ==
--		Create Background (so we can see we are moving)
-- ==
function public.createBack()
	--
	-- Draw background grid
	--
	local gridSize 		= common.gridSize / 2 
	local worldSize 	= common.worldSize
	local startX 		= centerX - (worldSize * gridSize)/2 - gridSize/2
	local startY 		= centerY - (worldSize * gridSize)/2 - gridSize/2
	local gridColors 	= common.gridColors
	local curX			= startX
	local curY			= startY
	local gridNum 		= 0

	for col = 1, worldSize do
		curY = startY
		for row = 1, worldSize do
			local tmp = lostGarden.create( layers.underlay, curX, curY, gridSize )
			tmp:setFillColor( unpack( gridColors[gridNum%2+1] ) )
			gridNum = gridNum + 1
			curY = curY + gridSize
		end
		gridNum = gridNum + 1 -- Force checker pattern
		curX = curX + gridSize
	end
end



return public