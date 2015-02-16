-- =============================================================
-- main.lua
-- =============================================================

----------------------------------------------------------------------
--	1. Requires
----------------------------------------------------------------------
require "scripts.pushButtonClass"
require "scripts.toggleButtonClass"


----------------------------------------------------------------------
--	2. Initialization
----------------------------------------------------------------------
io.output():setvbuf("no") 
display.setStatusBar(display.HiddenStatusBar)  

----------------------------------------------------------------------
-- 3. LOCALS
----------------------------------------------------------------------

-- Variables
local w = display.contentWidth
local h = display.contentHeight
local centerX = display.contentCenterX
local centerY = display.contentCenterY

-- Forward Declarations

-- Useful Localizations
local mAbs              = math.abs
local mRand             = math.random
local mDeg              = math.deg
local mRad              = math.rad
local mCos              = math.cos
local mSin              = math.sin
local mAcos             = math.acos
local mAsin             = math.asin
local mSqrt             = math.sqrt
local mCeil             = math.ceil
local mFloor            = math.floor
local mAtan2            = math.atan2
local mPi               = math.pi

local getInfo           = system.getInfo
local getTimer          = system.getTimer
local strMatch          = string.match
local strFormat         = string.format
local pairs             = pairs

----------------------------------------------------------------------
-- 4. Sampler
----------------------------------------------------------------------
local group = display.newGroup()

local tmp = display.newRect( group, centerX, centerY, w, h )
tmp:setFillColor(0.5,0.5,0.5)

local img = display.newImageRect( group,  "images/geek.png", 128, 128  )
img.x = centerX
img.y = centerY

-- Easy Shake
--
-- Derived from this: http://forums.coronalabs.com/topic/53736-simple-shake-easing-code-and-demo/
local function easyShake( obj, amplitude, time )
	local shakeEasing = function(currentTime, duration, startValue, targetDelta)
		local shakeAmplitude = amplitude -- maximum shake in pixels, at start of shake
		local timeFactor = (duration-currentTime)/duration -- goes from 1 to 0 during the transition
		local scaledShake =( timeFactor*shakeAmplitude)+1 -- adding 1 prevents scaledShake from being less then 1 which would throw an error in the random code in the next line
		local randomShake = math.random(scaledShake)
		return startValue + randomShake - scaledShake*0.5 -- the last part detracts half the possible max shake value so the shake is "symmetrical" instead of always being added at the same side
	end -- shakeEasing
	transition.to(obj , {time = time, x = obj.x, y = obj.y, transition = shakeEasing} ) -- use the displayObjects current x and y as parameter
end


local function onDoit( self, event ) 
	img.x = centerX	
	img.y = centerY
	easyShake( img, 50, 2000 )
	return true
end

local function onDoit2( self, event ) 	
	group.x = 0
	group.y = 0
	easyShake( group, 50, 2000 )
	return true
end


PushButton( group, centerX, h - 70, "Shake Img", onDoit, 
	       { width = 100, height = 40, unselFill = { 0.5, 0.5, 0.8 }, 
	         selFill = { 0.8, 0.8, 1 } } )


PushButton( group, centerX, h - 20, "Shake Screen", onDoit2, 
	       { width = 100, height = 40, unselFill = { 0.5, 0.5, 0.8 }, 
	         selFill = { 0.8, 0.8, 1 } } )

