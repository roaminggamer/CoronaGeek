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
local onBack
local onMusc
local onSFX

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


	-- Create some buttons for navigation
	local playButton = ToggleButton( sceneGroup, left + 42, bottom - 22, "Music", onMusic, 
	                          { labelColor = {0xff/255, 0x59/255, 0x1c/255}, 
								selFill 	= { 0xfd/255, 0xe5/255, 0, 1 }, 
								unselFill 	= { 0xfd/255, 0xe5/255, 0, 0.8 }, 
								selStroke 	= {0xff/255, 0x59/255, 0x1c/255},
								unselStroke = {0xff/255, 0x59/255, 0x1c/255},
								width = 80,
	                            labelSize = 18 } )

	-- Create some buttons for navigation
	local playButton = ToggleButton( sceneGroup, right - 42, bottom - 22, "SFX", onSFX, 
	                          { labelColor = {0xff/255, 0x59/255, 0x1c/255}, 
								selFill 	= { 0xfd/255, 0xe5/255, 0, 1 }, 
								unselFill 	= { 0xfd/255, 0xe5/255, 0, 0.8 }, 
								selStroke 	= {0xff/255, 0x59/255, 0x1c/255},
								unselStroke = {0xff/255, 0x59/255, 0x1c/255},
								width = 80,
	                            labelSize = 18 } )

	-- Create some buttons for navigation
	local playButton = ToggleButton( sceneGroup, left + 42, top + 22, "Back", onBack, 
	                          { labelColor = {0xff/255, 0x59/255, 0x1c/255}, 
								selFill 	= { 0xfd/255, 0xe5/255, 0, 1 }, 
								unselFill 	= { 0xfd/255, 0xe5/255, 0, 0.8 }, 
								selStroke 	= {0xff/255, 0x59/255, 0x1c/255},
								unselStroke = {0xff/255, 0x59/255, 0x1c/255},
								width = 80,
	                            labelSize = 18 } )

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
onMusic = function ( self, event ) 
	if(self:isSelected()) then
	else
	end
	return true
end

onSFX = function ( self, event ) 
	if(self:isSelected()) then
	else
	end
	return true
end

onBack = function ( self, event ) 
	composer.hideOverlay( "slideUp", 500  )	
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
