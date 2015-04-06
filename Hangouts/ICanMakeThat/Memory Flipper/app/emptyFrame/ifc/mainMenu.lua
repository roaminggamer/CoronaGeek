-- =============================================================
-- Your Copyright Statement Here, YYYY-YYYY
-- =============================================================
-- Main Menu
-- =============================================================
local composer 		= require( "composer" )
local scene    		= composer.newScene()

----------------------------------------------------------------------
--								LOCALS								--
----------------------------------------------------------------------
-- Variables
local sceneGroup
local w = display.contentWidth
local h = display.contentHeight
local centerX = display.contentCenterX
local centerY = display.contentCenterY

local menuGroup
local isFirstRun = true

-- Forward Declarations
local onPlay
local onOptions

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
	sceneGroup = self.view

	menuGroup = display.newGroup()
	sceneGroup:insert(menuGroup)


	-- Create some buttons for navigation
	local playButton = PushButton( menuGroup, centerX, centerY+150, "Play", onPlay, 
	                          { labelColor = {0xff/255, 0x59/255, 0x1c/255}, 
								selFill 	= { 0xfd/255, 0xe5/255, 0, 1 }, 
								unselFill 	= { 0xfd/255, 0xe5/255, 0, 0.8 }, 
								selStroke 	= {0xff/255, 0x59/255, 0x1c/255},
								unselStroke = {0xff/255, 0x59/255, 0x1c/255},
	                            labelSize = 18 } )

	local optionsButton = PushButton( menuGroup, centerX, centerY + 200, "Options", onOptions, 
	                          { labelColor = {0xff/255, 0x59/255, 0x1c/255}, 
								selFill 	= { 0xfd/255, 0xe5/255, 0, 1 }, 
								unselFill 	= { 0xfd/255, 0xe5/255, 0, 0.8 }, 
								selStroke 	= {0xff/255, 0x59/255, 0x1c/255},
								unselStroke = {0xff/255, 0x59/255, 0x1c/255},
	                            labelSize = 18 } )


end

----------------------------------------------------------------------
----------------------------------------------------------------------
function scene:willEnter( event )
end
----------------------------------------------------------------------
----------------------------------------------------------------------
function scene:didEnter( event )
end

----------------------------------------------------------------------
----------------------------------------------------------------------
function scene:willExit( event )
end
----------------------------------------------------------------------
----------------------------------------------------------------------
function scene:didExit( event )
end

----------------------------------------------------------------------
----------------------------------------------------------------------
function scene:destroy( event )
	sceneGroup = nil
end

----------------------------------------------------------------------
--				FUNCTION/CALLBACK DEFINITIONS						--
----------------------------------------------------------------------
onPlay = function ( self, event ) 
	return true
end

onOptions = function ( self, event ) 
	local options =
	{
		isModal = true, -- Don't let touches leak through
		effect = "fromTop", -- See list here: http://docs.coronalabs.com/daily/api/library/composer/gotoScene.html
		time = 500,
		params =
		{
			arg1 = "value", 
			arg2 = 0
		}
	}
	composer.showOverlay( "ifc.optionsOverlay", options  )	
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
