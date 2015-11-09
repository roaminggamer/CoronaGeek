-- =============================================================
-- Copyright Roaming Gamer, LLC. 2009-2015 
-- =============================================================
-- This content produced for Corona Geek Hangouts audience.
-- You may use any and all contents in this example to make a game or app.
-- =============================================================
local public = {}

local common 			   = require "scripts.common"
local layersMaker		   = require "scripts.layersMaker"
local lostGarden		   = require "scripts.lostGarden"

-- Localizations
local mRand             = math.random
local getTimer          = system.getTimer
local pairs             = pairs

-- 
--	 destroy()
-- 
function public.destroy()
end

-- 
--	 create()
-- 
function public.create()
   
   public.destroy()
   
   local layers = layersMaker.get()
   
	local gridSize 	= common.gridSize / 2 
	local worldSize 	= common.worldSize
	local startX 		= common.centerX - (worldSize * gridSize)/2 - gridSize/2
	local startY 		= common.centerY - (worldSize * gridSize)/2 - gridSize/2
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