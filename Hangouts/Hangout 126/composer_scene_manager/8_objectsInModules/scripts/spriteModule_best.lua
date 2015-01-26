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

local options 
local umaSheet
local spriteOptions


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
--								DEFINITIONS							--
----------------------------------------------------------------------

-- Initialize the module
spriteModule.init = function()
	options = { frames = require("scripts.uma").frames, }
	umaSheet = graphics.newImageSheet( "images/uma.png", options )
	spriteOptions = { name="uma", start=1, count=8, time=1000 }
end

-- Destroy (clean up) the module, with optional unrequire action
spriteModule.destroy = function( path )
	options = nil
	umaSheet = nil
	spriteOptions = nil

	-- If path is supplied, completely unload the module
	if( path ) then
		package.loaded[path] = nil
    	_G[path] = nil	
    end

end

-- Simple sprite creator
spriteModule.create = function( group, x, y )
	local spriteInstance = display.newSprite( umaSheet, spriteOptions )
	group:insert( spriteInstance )
	spriteInstance.x = x
	spriteInstance.y = y
	spriteInstance:play()
	return spriteInstance
end

print("------------\nRequired BEST MODULE\n------------")

return spriteModule

