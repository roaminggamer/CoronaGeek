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
local w = display.contentWidth
local h = display.contentHeight
local centerX = display.contentCenterX
local centerY = display.contentCenterY


-- Forward Declarations
local goToMainMenu


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

	-- Create a simple background
	local back = display.newRect( sceneGroup, centerX, centerY, 380, 570 )
	back:setFillColor( 0x01/255, 0x0f/255, 0x2a/255)
	
	-- Create a label showing which scene this is
	local label = display.newText( sceneGroup, "ZigZag", centerX, centerY - 40, system.nativeFontBold, 40 )
	label.x = label.x-1
	label.y = label.y-1
	local label = display.newText( sceneGroup, "ZigZag", centerX, centerY - 40, system.nativeFontBold, 40 )
	label:setFillColor( 0xff/255, 0x59/255, 0x1c/255 )
	label.x = label.x+1
	label.y = label.y+1
	local label = display.newText( sceneGroup, "ZigZag", centerX, centerY - 40, system.nativeFontBold, 40 )
	label:setFillColor( 0xfd/255, 0xe5/255, 0 )

	local label = display.newText( sceneGroup, "Boom (clone)", centerX, centerY + 40, system.nativeFontBold, 40 )
	label.x = label.x-1
	label.y = label.y-1
	local label = display.newText( sceneGroup, "Boom (clone)", centerX, centerY + 40, system.nativeFontBold, 40 )
	label:setFillColor( 0xff/255, 0x59/255, 0x1c/255 )
	label.x = label.x+1
	label.y = label.y+1
	local label = display.newText( sceneGroup, "Boom (clone)", centerX, centerY + 40, system.nativeFontBold, 40 )
	label:setFillColor( 0xfd/255, 0xe5/255, 0 )




	-- Automatically Go to main menu in 2 seconds 
	--
	local timerHandle = timer.performWithDelay( 2000, goToMainMenu )

	-- If user touches back, go to main menu early.
	--
	back.touch = function( self, event )
		if(event.phase == "ended") then
			timer.cancel(timerHandle)
			goToMainMenu()
		end
		return true
	end
	back:addEventListener( "touch" )	

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
goToMainMenu = function()
	local options =
	{
		effect = "crossFade", -- See list here: http://docs.coronalabs.com/daily/api/library/composer/gotoScene.html
		time = 500,
		params =
		{
			arg1 = "value", 
			arg2 = 0
		}
	}
	composer.gotoScene( "ifc.mainMenu", options  )	
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
