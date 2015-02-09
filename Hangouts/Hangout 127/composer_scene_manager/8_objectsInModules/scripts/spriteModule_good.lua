-- =============================================================
-- Your Copyright Statement Here, YYYY-YYYY
-- =============================================================
-- Scene 1
-- =============================================================
local composer 		= require( "composer" )
local scene    		= composer.newScene()

----------------------------------------------------------------------
--								DECLARATIONS						--
----------------------------------------------------------------------
local spriteModule  = {}

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

-- Sprite Prep
local options = { frames = require("scripts.uma").frames, }
local umaSheet = graphics.newImageSheet( "images/uma.png", options )
local spriteOptions = { name="uma", start=1, count=8, time=1000 }


----------------------------------------------------------------------
--								DEFINITIONS							--
----------------------------------------------------------------------

-- Simple sprite creator
spriteModule.create = function( group, x, y )
	local spriteInstance = display.newSprite( umaSheet, spriteOptions )
	group:insert( spriteInstance )
	spriteInstance.x = x
	spriteInstance.y = y
	spriteInstance:play()
	return spriteInstance
end

return spriteModule

