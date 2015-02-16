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

local subEasingLabel
local easingLabel
local timeLabel

local img
local dir = 1
local dir2 = 1

local subEasings = {"", "in", "inOut", "out", "outIn"}

local easings = {
	"linear",
	"Back", 
	"Bounce", 
	"Circ", 
	"Cubic", 
	"Elastic", 
	"Expo", 
	"Quad", 
	"Quart", 
	"Quint", 
	"Sine", 
}

local curSub = 1
local curEasing = 1
local curTime = 1

local times = {}
for i = 1, 100 do
	times[i] = i * 100
end


-- Forward Declarations
local onTest
local onTest2

local onEasing
local onSubEasing
local onTime


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
local tmp = display.newRect( centerX, centerY, w, h )
tmp:setFillColor(0.5,0.5,0.5)
local tmp = display.newRect( centerX, 120, w - 24, 132 )
tmp:setFillColor(0.3,0.3,0.3)
local img = display.newImageRect( "images/geek.png", 128, 128  )
img.x = 80
img.y = 120


onTest = function ( self, event ) 	
	local time = tonumber(timeLabel.text)
	local sub = tostring(subEasingLabel.text)
	local curEasing = tostring(easingLabel.text)

	if(curEasing ~= "linear") then
		curEasing = sub .. curEasing
	end

	print(dir, time, curEasing)

	if(dir == 1) then
		dir = 2
		transition.to( img, { xScale = 0.05, yScale = 0.05, time = time, transition = easing[curEasing]  } )
	else 
		dir = 1
		transition.to( img, { xScale = 1, yScale = 1, time = time, transition = easing[curEasing]  } )
	end

	event.target.alpha = 0

	transition.to( event.target, { delay = time, alpha = 1, time = 0 } )

	return true
end

onTest2 = function ( self, event ) 
	local time = tonumber(timeLabel.text)
	local sub = tostring(subEasingLabel.text)
	local curEasing = tostring(easingLabel.text)

	if(curEasing ~= "linear") then
		curEasing = sub .. curEasing
	end

	print(dir2, time, curEasing)

	if(dir2 == 1) then
		dir2 = 2
		transition.to( img, { x = centerX + 70, time = time, transition = easing[curEasing]  } )
	else 
		dir2 = 1
		transition.to( img, { x = centerX - 70, time = time, transition = easing[curEasing]  } )
	end

	event.target.alpha = 0

	transition.to( event.target, { delay = time, alpha = 1, time = 0 } )

	return true
end

onEasing = function( self, event ) 
	local incr = self.incr
	curEasing = curEasing+incr
	if(curEasing>#easings) then curEasing = 1 end
	if(curEasing<1) then curEasing = #easings end
	easingLabel.text = easings[curEasing]
end

onSubEasing = function( self, event ) 
	local incr = self.incr
	curSub = curSub+incr
	if(curSub>#subEasings) then curSub = 1 end
	if(curSub<1) then curSub = #subEasings end
	subEasingLabel.text = subEasings[curSub]
end

onTime = function( self, event ) 
	local incr = self.incr
	curTime = curTime+incr
	if(curTime>#times) then curTime = 1 end
	if(curTime<1) then curTime = #times end
	timeLabel.text = times[curTime]
end

PushButton( nil, 50, h - 20, "Test 1", onTest, 
	       { width = 100, height = 40, unselFill = { 0.5, 0.5, 0.8 }, 
	         selFill = { 0.8, 0.8, 1 } } )


PushButton( nil, w-50, h - 20, "Test 2", onTest2, 
	       { width = 100, height = 40, unselFill = { 0.5, 0.5, 0.8 }, 
	        selFill = { 0.8, 0.8, 1 } } )


subEasingLabel = display.newText( subEasings[curSub], centerX, centerY + 90, native.systemFont, 22 )
local tmp = PushButton( nil, centerX - 120, subEasingLabel.y, "-", onSubEasing, 
	       { width = 30, height = 30, unselFill = { 0.2, 0.2, 0.2 }, 
	        selFill = { 0.3, 0.3, 0.3 } } )
tmp.incr = -1
local tmp = PushButton( nil, centerX + 120, subEasingLabel.y, "+", onSubEasing, 
	       { width = 30, height = 30, unselFill = { 0.2, 0.2, 0.2 }, 
	        selFill = { 0.3, 0.3, 0.3 } } )
tmp.incr = 1

easingLabel = display.newText( easings[curEasing], centerX, centerY + 125, native.systemFont, 22 )
local tmp = PushButton( nil, centerX - 120, easingLabel.y, "-", onEasing, 
	       { width = 30, height = 30, unselFill = { 0.2, 0.2, 0.2 }, 
	        selFill = { 0.3, 0.3, 0.3 } } )
tmp.incr = -1
local tmp = PushButton( nil, centerX + 120, easingLabel.y, "+", onEasing, 
	       { width = 30, height = 30, unselFill = { 0.2, 0.2, 0.2 }, 
	        selFill = { 0.3, 0.3, 0.3 } } )
tmp.incr = 1

timeLabel = display.newText( times[curTime], centerX, centerY + 160, native.systemFont, 22 )
local tmp = PushButton( nil, centerX - 120, timeLabel.y, "-", onTime, 
	       { width = 30, height = 30, unselFill = { 0.2, 0.2, 0.2 }, 
	        selFill = { 0.3, 0.3, 0.3 } } )
tmp.incr = -1
local tmp = PushButton( nil, centerX + 120, timeLabel.y, "+", onTime, 
	       { width = 30, height = 30, unselFill = { 0.2, 0.2, 0.2 }, 
	        selFill = { 0.3, 0.3, 0.3 } } )
tmp.incr = 1
