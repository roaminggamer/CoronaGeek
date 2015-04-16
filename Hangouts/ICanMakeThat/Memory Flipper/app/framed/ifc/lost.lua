-- =============================================================
-- Your Copyright Statement Here, YYYY-YYYY
-- =============================================================
-- Options Overlay
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

local back 

-- Forward Declarations
local onMenu

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
	back = display.newRect( sceneGroup, centerX, centerY, 10000, 10000 )
	back:setFillColor( 0x01/255, 0x0f/255, 0x2a/255)
	back.alpha = 0.3

	-- Create a label showing which scene this is
	local label = display.newEmbossedText( sceneGroup, "You Lost!", centerX, centerY, native.systemFont, 50 )
	label:setFillColor( 1, 0.2, 0.2  )
	local color = 
	{
	    highlight = { r=1, g=1, b=1 },
	    shadow = { r=1, g=0, b=0.3 }
	}
	label:setEmbossColor( color )



	-- Create some buttons for navigation
	local playButton = ToggleButton( sceneGroup, centerX, bottom - 60, "Menu", onMenu, 
	                          { labelSize = 14, width = 180, height = 32,
								  labelColor = {0x01/255, 0x0f/255, 0x2a/255}, 
								  selFill 	= { 0xfd/255, 0xe5/255, 0}, 
								  unselFill 	= { 0xfd/255, 0xe5/255, 0}, 
								  selStroke 	= {1,1,1},
								  unselStroke = {0,0,0}  })

end

----------------------------------------------------------------------
----------------------------------------------------------------------
function scene:willEnter( event )
	local sceneGroup = self.view
	transition.to( back, { alpha = 0.8, time = 500 } )
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
	transition.to( back, { alpha = 0, time = 300 } )
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

	back = nil
end

----------------------------------------------------------------------
--				FUNCTION/CALLBACK DEFINITIONS						--
----------------------------------------------------------------------
onMenu = function ( self, event ) 
	post( "onSFX", { sfx = "click" } )
	local options = { effect = "slideRight",  time = 500 }
	composer.gotoScene( "ifc.mainMenu", options  )	
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
