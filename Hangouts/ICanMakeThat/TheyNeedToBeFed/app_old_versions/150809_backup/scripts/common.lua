-- =============================================================
-- Copyright Roaming Gamer, LLC. 2009-2015 
-- =============================================================
-- 
-- =============================================================

-- ==
--    round(val, n) - Rounds a number to the nearest decimal places. (http://lua-users.org/wiki/FormattingNumbers)
--    val - The value to round.
--    n - Number of decimal places to round to.
-- ==
local function round(val, n)
  if (n) then
    return math.floor( (val * 10^n) + 0.5) / (10^n)
  else
    return math.floor(val+0.5)
  end
end

local common = {}

--
-- Game Variables
--
common.debugEn		= true

common.gravityMag 	= 10 -- Gravity (base) magnitude
common.playerSpeed  = 270
common.jumpMag		= 9 -- Magnitude of jump impulse

common.startOffsetY = 5

common.levelGrid	= 8 -- Grid is 8 x 8 for demo
common.buttonSize 	= 120
common.blockSize 	= 100 --* 0.5
common.playerSize 	= common.blockSize / 2
common.gapSize  	= 2.5 * common.blockSize

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
common.deviceWidth		= math.floor((fullw/display.contentScaleX) + 0.5)
common.deviceHeight 	= math.floor((fullh/display.contentScaleY) + 0.5)
common.left				= 0 - unusedWidth/2
common.top 				= 0 - unusedHeight/2
common.right 			= w + unusedWidth/2
common.bottom 			= h + unusedHeight/2

-- Clean up variables
common.w 				= round(w)
common.h 				= round(h)
common.left				= round(left)
common.top				= round(top)
common.right			= round(right)
common.bottom			= round(bottom)
common.fullw			= round(fullw)
common.fullh			= round(fullh)

-- Determine design orientation
common.orientation  	= ( w > h ) and "landscape"  or "portrait"
common.isLandscape 		= ( w > h )
common.isPortrait 		= ( h > w )

-- Further clean up variables
common.left 			= (left>=0) and math.abs(left) or left
common.top 				= (top>=0) and math.abs(top) or top


return common