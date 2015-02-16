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
-- 4. Helper Function(s)
----------------------------------------------------------------------
local function doCircle( x, y, text, fill, stroke )
	x = x or centerX
	y = y or centerY
	text = text or ""
	fill = fill or {1,1,1}
	stroke = stroke or {1,0,0}

	local circ = display.newCircle( x, y, 20 )
	circ:setFillColor( unpack( fill ) )
	circ:setStrokeColor( unpack( stroke ) )
	circ.strokeWidth = 2

	local label = display.newText( text, x - 30, y, native.systemFont, 12 )
	label.anchorX = 1 

	return circ
end


----------------------------------------------------------------------
-- 5. Prep
----------------------------------------------------------------------
-- Create a simple background
local back = display.newImageRect( "images/protoBack.png", 380, 570 )
back.x = centerX
back.y = centerY
if(w>h) then back.rotation = 90 end
local label = display.newText( "Intermediate", centerX, 20, native.systemFont, 20 )
label:setFillColor(1,1,0)

----------------------------------------------------------------------
-- 6. Examples
----------------------------------------------------------------------

----------
-- Blink
----------
local function testBlink()
	local circ = doCircle( 140, 80, "NOT READY YET", {1,1,1}, {1,0,0} )
	local buttonGroup = display.newGroup()

	local function onStart( self, event )
		-- Hide the button to prevent multiple presses
		buttonGroup.isVisible = false 

		-- Blink the circle
		transition.blink( circ, { time = 1000 } )
	end

	--button = PushButton( buttonGroup, 270, circ.y, "Start", onStart, { width = 80, height = 30 } )
end
testBlink()
