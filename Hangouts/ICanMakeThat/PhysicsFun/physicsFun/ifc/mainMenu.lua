-- =============================================================
-- Your Copyright Statement Here, YYYY-YYYY
-- =============================================================
-- Splash Screen
-- =============================================================
local composer 		= require( "composer" )
local scene    		= composer.newScene()

----------------------------------------------------------------------
--								LOCALS								--
----------------------------------------------------------------------
-- Variables

-- Forward Declarations
local onPress
local onSimple
local onSampler
local onDoll
local onPosable
local onCar
local onCar2


-- Useful Localizations
-- SSK
--
local newCircle 	= ssk.display.newCircle
local newRect 		= ssk.display.newRect
local newImageRect 	= ssk.display.newImageRect
local newAngleLine 	= ssk.display.newAngleLine
local easyIFC   	= ssk.easyIFC
local oleft 		= ssk.misc.oleft
local oright 		= ssk.misc.oright
local otop 			= ssk.misc.otop
local obottom		= ssk.misc.obottom
local isInBounds    = ssk.easyIFC.isInBounds
local persist 		= ssk.persist
local isValid 		= display.isValid
local easyFlyIn 	= easyIFC.easyFlyIn

-- Corona & Lua
--
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
--	Scene Methods
----------------------------------------------------------------------

----------------------------------------------------------------------
----------------------------------------------------------------------
function scene:create( event )
	local sceneGroup = self.view

	local layers = ssk.display.quickLayers( sceneGroup, "underlay", "content", "overlay" )

	-- Create a simple background
	local back = newImageRect( layers.underlay, centerX, centerY, 
		                       "images/protoBack.png",
		                       { w = 380, h = 570, rotation = (w>h) and 90 or 0 } )


	-- Create a basic label
	local tmp = easyIFC:quickLabel( layers.overlay, "Physics Fun with Corona SDK", centerX, top + 20 , gameFont2, 22, hexcolor("#2B547E")  )


	-- Create a basic push button
	local startY = top + 60
	local dy = 40
	easyIFC:presetPush( layers.overlay, "default", left + 115, startY + 0 * dy, 220, 30, "Simple (Pivot) Joint (15 JUN 2015)", onSimple, { labelSize = 12 } )
	easyIFC:presetPush( layers.overlay, "default", left + 115, startY + 1 * dy, 220, 30, "Joints Sampler (multiple) (22 JUN 2015)", onSampler, { labelSize = 12 } )
	easyIFC:presetPush( layers.overlay, "default", left + 115, startY + 2 * dy, 220, 30, "Dragabble Doll (Pivot) (15 JUN 2015)", onDoll, { labelSize = 12 } )
	easyIFC:presetPush( layers.overlay, "default", left + 115, startY + 3 * dy, 220, 30, "Posable Doll (Pivot) (15 JUN 2015)", onPosable, { labelSize = 12 } )
	easyIFC:presetPush( layers.overlay, "default", left + 115, startY + 4 * dy, 220, 30, "Simple Car (Pivot) (15 JUN 2015)", onCar, { labelSize = 12 } )
	easyIFC:presetPush( layers.overlay, "default", left + 115, startY + 5 * dy, 220, 30, "Simple Car 2 (Wheel) (22 JUN 2015)", onCar2, { labelSize = 12 } )
end

----------------------------------------------------------------------
----------------------------------------------------------------------
function scene:willEnter( event )
	local sceneGroup = self.view
end
----------------------------------------------------------------------
----------------------------------------------------------------------
function scene:didEnter( event )
	local sceneGroup = self.view
end

----------------------------------------------------------------------
----------------------------------------------------------------------
function scene:willExit( event )
	local sceneGroup = self.view
end
----------------------------------------------------------------------
----------------------------------------------------------------------
function scene:didExit( event )
	local sceneGroup = self.view
end

----------------------------------------------------------------------
----------------------------------------------------------------------
function scene:destroy( event )
	local sceneGroup = self.view
end

----------------------------------------------------------------------
--				FUNCTION/CALLBACK DEFINITIONS						--
----------------------------------------------------------------------
onPress = function( event )
	print( "Pushed button labeled: " .. event.target:getText() )
	--[[
	local options =
	{
		effect = "slideLeft", -- See list here: http://docs.coronalabs.com/daily/api/library/composer/gotoScene.html
		time = 500,
		params =
		{
			arg1 = "value", 
			arg2 = 0
		}
	}
	composer.gotoScene( "ifc.mainMenu", options  )	
	--]]
end

onSimple = function( event )
	local options =
	{
		effect = "fromRight", -- See list here: http://docs.coronalabs.com/daily/api/library/composer/gotoScene.html
		time = 500,
	}
	composer.gotoScene( "ifc.simple", options  )	
end

onSampler = function( event )
	local options =
	{
		effect = "fromRight", -- See list here: http://docs.coronalabs.com/daily/api/library/composer/gotoScene.html
		time = 500,
	}
	composer.gotoScene( "ifc.jointSampler", options  )	
end


onDoll = function( event )
	local options =
	{
		effect = "fromRight", -- See list here: http://docs.coronalabs.com/daily/api/library/composer/gotoScene.html
		time = 500,
	}
	composer.gotoScene( "ifc.doll", options  )	
end


onPosable = function( event )
	local options =
	{
		effect = "fromRight", -- See list here: http://docs.coronalabs.com/daily/api/library/composer/gotoScene.html
		time = 500,
	}
	composer.gotoScene( "ifc.posable", options  )	
end

onCar = function( event )
	local options =
	{
		effect = "fromRight", -- See list here: http://docs.coronalabs.com/daily/api/library/composer/gotoScene.html
		time = 500,
	}
	composer.gotoScene( "ifc.car", options  )	
end


onCar2 = function( event )
	local options =
	{
		effect = "fromRight", -- See list here: http://docs.coronalabs.com/daily/api/library/composer/gotoScene.html
		time = 500,
	}
	composer.gotoScene( "ifc.car2", options  )	
end



---------------------------------------------------------------------------------
-- Scene Dispatch Events, Etc. - Generally Do Not Touch Below This Line
---------------------------------------------------------------------------------
function scene:show( event )
	local sceneGroup 	= self.view
	local willDid 	= event.phase
	if( willDid == "will" ) then
		self:willEnter( event )
	elseif( willDid == "did" ) then
		self:didEnter( event )
	end
end
function scene:hide( event )
	local sceneGroup 	= self.view
	local willDid 	= event.phase
	if( willDid == "will" ) then
		self:willExit( event )
	elseif( willDid == "did" ) then
		self:didExit( event )
	end
end
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )
---------------------------------------------------------------------------------
return scene
