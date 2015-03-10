-- =============================================================
-- Your Copyright Statement Here, YYYY-YYYY
-- =============================================================
-- Scene 1
-- =============================================================
local composer 		= require( "composer" )
local scene    		= composer.newScene()
require "scripts.customTransitions"

----------------------------------------------------------------------
--								LOCALS								--
----------------------------------------------------------------------
-- Variables
local w = display.contentWidth
local h = display.contentHeight
local centerX = display.contentCenterX
local centerY = display.contentCenterY


-- Forward Declarations
local onScene2

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
--	Scene Methods
----------------------------------------------------------------------

----------------------------------------------------------------------
----------------------------------------------------------------------
function scene:create( event )
	local sceneGroup = self.view
	local back = display.newImageRect( sceneGroup, "images/protoBack.png", 380, 570 )
	back.x = centerX
	back.y = centerY
	if(w>h) then back.rotation = 90 end

	local label = display.newText( sceneGroup, "Scene 2", centerX, 40, native.systemFont, 30 )
	PushButton( sceneGroup, centerX, centerY, "Scene 1", onScene2, { labelColor = {1,0,0}, labelSize = 18 } )
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
onScene2 = function ( self, event ) 
	print("--------------------------")
	local options =
	{
		effect = "myEffect",
		
		--effect = "iosSlideLeft",
		--effect = "iosSlideRight",
		--effect = "displaySceneFromLeft",
		--effect = "dismissSceneToLeft",
		--effect = "panelDown",

		time = 2000,
		--time = 500,
	}
	composer.gotoScene( "ifc.scene1", options  )	
	return true
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
