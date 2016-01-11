-- =============================================================
-- Your Copyright Statement Here, YYYY-YYYY
-- =============================================================
-- Options Overlay
-- =============================================================
local composer 		= require( "composer" )
local scene    		= composer.newScene()
local common 	      = require "scripts.common"

----------------------------------------------------------------------
--								LOCALS								--
----------------------------------------------------------------------
-- Variables
local backB 


-- Forward Declarations
local onBack

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
	back:setFillColor( 0, 0, 0 )	
	if(w>h) then back.rotation = 90 end
	back.alpha = 0.3

	-- Create a label showing which scene this is
	local label = display.newEmbossedText( sceneGroup, "Options", centerX, 40, native.systemFont, 60 )
	label:setFillColor( 0xCC/255, 1, 1  )
	local color = 
	{
	    highlight = { r=1, g=1, b=1 },
	    shadow = { r=0, g=1, b=0.3 }
	}
	label:setEmbossColor( color )

	-- Create a button
	backB = ControllerPushButton( sceneGroup, centerX, centerY, "Back", onBack, 
	                          { 
                                 labelColor   = {0.8,0.2,0.2}, 
                                 labelSize    = 18, 
                                 pressKey     = "buttonA",
                                 myName       = "back",
                             } )
   backB:select(true)
end

----------------------------------------------------------------------
----------------------------------------------------------------------
function scene:willEnter( event )
	local sceneGroup = self.view
   if( backB and backB.enableKeys ) then 
      backB:enableKeys()
   end
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
   if( backB and backB.enableKeys ) then 
      backB:enableKeys(false)
   end
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
onBack = function ( self, event ) 
	local options =
	{
		isModal = true, -- Don't let touches leak through
		effect = "slideUp", -- See list here: http://docs.coronalabs.com/daily/api/library/composer/gotoScene.html
		time = 500,
		params =
		{
			arg1 = "value", 
			arg2 = 0
		}
	}
	composer.gotoScene( "ifc.mainMenu", options  )		return true
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
