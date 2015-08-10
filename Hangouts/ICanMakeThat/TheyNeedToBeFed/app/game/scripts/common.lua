-- =============================================================
-- Copyright Roaming Gamer, LLC. 2009-2014 
-- =============================================================
-- 
-- =============================================================
local mFloor = math.floor

local common = {}
--
-- Game Variables
--
common.debugEn		= true

common.gravityMag 	= 10 -- Gravity (base) magnitude
common.playerSpeed  = 270
common.jumpMag		= 10 -- Magnitude of jump impulse

common.startOffsetY = 5

common.levelGrid	= 8 -- Grid is 8 x 8 for demo
common.buttonSize 	= 120
common.blockSize 	= 100 --* 0.25
common.playerSize 	= common.blockSize / 2
common.gapSize  	= 2.5 * common.blockSize --* 0.25

--
-- Helper Variables
--
common.w 				= display.contentWidth
common.h 				= display.contentHeight
common.centerX 			= display.contentCenterX
common.centerY 			= display.contentCenterY
common.fullw			= display.actualContentWidth 
common.fullh			= display.actualContentHeight
common.unusedWidth		= common.fullw - common.w
common.unusedHeight		= common.fullh - common.h
common.left				= 0 - common.unusedWidth/2
common.top 				= 0 - common.unusedHeight/2
common.right 			= common.w + common.unusedWidth/2
common.bottom 			= common.h + common.unusedHeight/2

-- Clean up variables
common.w 				= mFloor(common.w+0.5)
common.h 				= mFloor(common.h+0.5)
common.left				= mFloor(common.left+0.5)
common.top				= mFloor(common.top+0.5)
common.right			= mFloor(common.right+0.5)
common.bottom			= mFloor(common.bottom+0.5)
common.fullw			= mFloor(common.fullw+0.5)
common.fullh			= mFloor(common.fullh+0.5)

-- Determine design orientation
common.orientation  	= ( common.w > common.h ) and "landscape"  or "portrait"
common.isLandscape 		= ( common.w > common.h )
common.isPortrait 		= ( common.h > common.w )

-- Further clean up variables
common.left 			= (common.left>=0) and math.abs(common.left) or common.left
common.top 				= (common.top>=0) and math.abs(common.top) or common.top


return common