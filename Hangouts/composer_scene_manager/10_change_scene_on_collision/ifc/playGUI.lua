-- =============================================================
-- Your Copyright Statement Here, YYYY-YYYY
-- =============================================================
-- Play GUI
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
end

----------------------------------------------------------------------
----------------------------------------------------------------------
function scene:willEnter( event )
	local sceneGroup = self.view
	--
	-- Recreate the scene contents every time we enter
	--
	scene.perRunGroup = display.newGroup()
	sceneGroup:insert( scene.perRunGroup )

	-- Create a simple background
	local back = display.newImageRect( scene.perRunGroup, "images/protoBack.png", 380, 570 )
	back.x = centerX
	back.y = centerY

	-- Create a randomly colored label each time
	local label = display.newText( scene.perRunGroup, "Play GUI", centerX, 40, native.systemFont, 60 )
	label:setFillColor( mRand(), mRand(), mRand()  )

	-- Create a button
	local push1 = PushButton( scene.perRunGroup, centerX, centerY + 200, "Back", onBack, 
	                          { labelColor = {0.8,0.2,0.2}, labelSize = 18 } )
end

----------------------------------------------------------------------
----------------------------------------------------------------------
function scene:didEnter( event )
	local sceneGroup = self.view

	local physics = require "physics"
	physics:start()

	local ground = display.newRect( scene.perRunGroup, centerX, centerY + 150, w, 40 )
	ground:setFillColor(0,0.5,0)
	physics.addBody( ground, "static" )

	local ball = display.newCircle( scene.perRunGroup, centerX, centerY - 150, 20 )
	ball:setFillColor(0.5,0.5,0)
	physics.addBody( ball, "dynamic", { radius = 20 } )

	ball.collision = function( self, event ) 
	   if( event.phase == "began" ) then
	   	   timer.performWithDelay( 1, onBack )
	   end
	   return true
	end
	ball:addEventListener("collision")

end

----------------------------------------------------------------------
----------------------------------------------------------------------
function scene:willExit( event )
	local sceneGroup = self.view

	local physics = require "physics"
	physics:pause()

end
----------------------------------------------------------------------
----------------------------------------------------------------------
function scene:didExit( event )
	local sceneGroup = self.view

	-- Destroy everything in 'perRunGroup' every time we exit
	display.remove( scene.perRunGroup )
	scene.perRunGroup = nil

end

----------------------------------------------------------------------
----------------------------------------------------------------------
function scene:destroy( event )
	local sceneGroup = self.view
end

----------------------------------------------------------------------
--				FUNCTION/CALLBACK DEFINITIONS						--
----------------------------------------------------------------------
onBack = function ( self, event ) 
	local options =
	{
		effect = "fromTop", -- See list here: http://docs.coronalabs.com/daily/api/library/composer/gotoScene.html
		time = 500,
		params =
		{
			arg1 = "value", 
			arg2 = 0
		}
	}
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
