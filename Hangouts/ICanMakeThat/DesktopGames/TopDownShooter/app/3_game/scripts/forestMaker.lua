-- =============================================================
-- Copyright Roaming Gamer, LLC. 2009-2015 
-- =============================================================
-- This content produced for Corona Geek Hangouts audience.
-- You may use any and all contents in this example to make a game or app.
-- =============================================================
local public = {}

local common 			   = require "scripts.common"
local layersMaker		   = require "scripts.layersMaker"

-- Localizations
local mRand             = math.random
local getTimer          = system.getTimer
local pairs             = pairs

local options =
{
   width = 128,
   height = 128,
   numFrames = 32,
   sheetContentWidth = 512,
   sheetContentHeight = 1024     
}
local shadowSheet = graphics.newImageSheet( "images/reiners/trees_shadows.png", options )
local treeSheet = graphics.newImageSheet( "images/reiners/trees_noshadow.png", options )

-- 
--	 destroy()
-- 
function public.destroy()
end

-- 
--	 create()
-- 
function public.create( )
   
   public.destroy()
   
   local layers = layersMaker.get()
   
	local gridSize 	= common.gridSize 
	local worldWidth 	= common.worldWidth
   local worldHeight = common.worldHeight
	local startX 		= common.centerX - (worldWidth * gridSize)/2 + gridSize/2
	local startY 		= common.centerY - (worldHeight * gridSize)/2 + gridSize/2
	local gridColors 	= common.gridColors
	local curX			= startX 
	local curY			= startY 
	local gridNum 		= 0

	for col = 1, worldWidth do
		curY = startY
		for row = 1, worldHeight do
         if( curX < common.leftLimit or curX > common.rightLimit or
             curY < common.upLimit or curY > common.downLimit ) then
            local treeNum = mRand(1,32)
            local x = curX + mRand( -10, 10 )
            local y = curY + mRand( -10, 10 )
            local treeSize = mRand( 2, 2.5 ) * gridSize
            local tmp = display.newImageRect( layers.underlay, shadowSheet, treeNum , treeSize, treeSize )
            tmp.x = x
            tmp.y = y
            
            local tmp = display.newImageRect( layers.overlay, treeSheet, treeNum , treeSize, treeSize )
            tmp.x = x
            tmp.y = y
         end
			--tmp:setFillColor( unpack( gridColors[gridNum%2+1] ) )
			gridNum = gridNum + 1
			curY = curY + gridSize
         
		end
		gridNum = gridNum + 1 -- Force checker pattern
		curX = curX + gridSize
      
      
	end
end

return public