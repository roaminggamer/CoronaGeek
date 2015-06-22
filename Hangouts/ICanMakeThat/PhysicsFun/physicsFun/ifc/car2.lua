-- =============================================================
-- Your Copyright Statement Here, YYYY-YYYY
-- =============================================================
-- Splash Screen
-- =============================================================
local composer 		= require( "composer" )
local scene    		= composer.newScene()

local physics = require("physics")

----------------------------------------------------------------------
--								LOCALS								--
----------------------------------------------------------------------
-- Variables
local layers
local wheelSpeed = 600

local touchJointForce		= 100000


local backImage
local leftAxle
local rightAxle

-- Forward Declarations
local onMainMenu
local onGravity

local onRightWheel
local onLeftWheel

local dragPart
local addDragger

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

	layers = ssk.display.quickLayers( sceneGroup, "underlay", "content", "overlay" )

	-- Create a simple background
	local back = newImageRect( layers.underlay, centerX, centerY, 
		                       "images/protoBack.png",
		                       { w = 380, h = 570, rotation = (w>h) and 90 or 0 } )


	-- Create a basic label
	local tmp = easyIFC:quickLabel( layers.overlay, "Wheel Car (not working yet)", centerX, top + 20, gameFont2, 22, hexcolor("#2B547E")  )


	-- Create a basic push button
	easyIFC:presetPush( layers.overlay, "default", right - 30, bottom - 15, 60, 30, "Back", onMainMenu )
	easyIFC:presetToggle( layers.overlay, "default", right - 35, top + 20, 60, 30, "Gravity", onGravity, { labelSize = 12 } )
	easyIFC:presetPush( layers.overlay, "default", right - 35, top + 55, 60, 30, "Right", nil, { onEvent = onRightWheel, labelSize = 12 } )
	easyIFC:presetPush( layers.overlay, "default", right - 35, top + 90, 60, 30, "Left", nil, { onEvent = onLeftWheel, labelSize = 12 } )

end

----------------------------------------------------------------------
----------------------------------------------------------------------
function scene:willEnter( event )
	local sceneGroup = self.view	

	physics.start()
	physics.setGravity( 0, 0 )
	physics.setContinuous( true )

	local filter = { groupIndex = - 1 }

	-- Body Size and PositioningVariables
	local jointsRadius = 12
	--local pistonLength = 20

	local segmentLen  = 100
	local segmentThickness = jointsRadius * 2 - 2

	-- ==
	--   body
	-- ==	
	local body = display.newRect( layers.content, 0, 0, 80, 30 )
	body.x = left + 100
	body.y = top + 50
	body:setFillColor( 1, 1, 0 )
	physics.addBody( body, { density = 0.2, filter = filter } )
	body.linearDamping = 0.5
	body.angularDamping = 0
	body.isSleepingAllowed = false

	-- ==
	--   left wheel
	-- ==	
	local leftWheel = display.newCircle( layers.content, body.x - body.contentWidth/2 + 15, body.y + body.contentHeight/2, 12 )
	physics.addBody( leftWheel, { density = 0.05, filter = filter, friction = 100, radius = 12 } )
	leftWheel.fill = { type="image", filename="images/coronaLogo.png" }
	leftWheel.linearDamping = 0
	leftWheel.angularDamping = 1
	leftAxle  = physics.newJoint( "wheel", body, leftWheel, leftWheel.x, leftWheel.y, 0, 0 )	

	-- ==
	--   right wheel
	-- ==	
	local rightWheel = display.newCircle( layers.content, body.x + body.contentWidth/2 - 15, body.y + body.contentHeight/2, 12 )	
	rightWheel.fill = { type="image", filename="images/coronaLogo.png" }
	physics.addBody( rightWheel, { density = 0.05, filter = filter, friction = 100, radius = 12 } )
	rightWheel.linearDamping = 0
	rightWheel.angularDamping = 1
	rightAxle  = physics.newJoint( "wheel", body, rightWheel, rightWheel.x, rightWheel.y, 0, 0 )

	-- ==
	--   Ground
	-- ==	
	local groundA = display.newRect( layers.content, 0, 0, 60, 20 )
	groundA.x = body.x - 70
	groundA.y = body.y + 50
	groundA:setFillColor( 0.2, 0.2, 0.2 )
	physics.addBody( groundA, "static", { friction = 1 } )

	local groundB = display.newRect( layers.content, 0, 0, 200, 20 )
	groundB.x = groundA.x + groundA.contentWidth + 50
	groundB.y = groundA.y + 49
	groundB:setFillColor( 0.2, 0.2, 0.2 )
	groundB.rotation = 30
	physics.addBody( groundB, "static", { friction = 1 } )

	local groundC = display.newRect( layers.content, 0, 0, 200, 20 )
	groundC.x = groundA.x + groundA.contentWidth + 220
	groundC.y = groundA.y + 97
	groundC:setFillColor( 0.2, 0.2, 0.2 )
	physics.addBody( groundC, "static", { friction = 1 } )

	local groundD = display.newRect( layers.content, 0, 0, 40, 40 )
	groundD.x = groundC.x + groundC.contentWidth/2 + 20
	groundD.y = groundC.y - 10
	groundD:setFillColor( 0.2, 0.2, 0.2 )
	physics.addBody( groundD, "static", { friction = 1 } )


	-- Add dragger to parts
	--
	--addDragger( body )

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
	physics.setContinuous( false )
	physics.stop()

	layers:purge("content")

	leftAxle = nil
	rightAxle = nil	
end

----------------------------------------------------------------------
----------------------------------------------------------------------
function scene:destroy( event )
	local sceneGroup = self.view
end

----------------------------------------------------------------------
--				FUNCTION/CALLBACK DEFINITIONS						--
----------------------------------------------------------------------
onMainMenu = function( event )
	local options = { effect = "fromLeft", time = 500 }
	composer.gotoScene( "ifc.mainMenu", options  )	
end


onGravity = function( event )
	if(event.target:pressed()) then
		physics.setGravity(0,10)
	else
		physics.setGravity(0,0)
	end
	return true
end


onRightWheel = function( event )
	if(event.target:pressed()) then
		rightAxle.isMotorEnabled = true
		rightAxle.motorSpeed = -wheelSpeed
		rightAxle.maxMotorTorque = 100000
	else
		rightAxle.isMotorEnabled = false
		rightAxle.motorSpeed = 0
		rightAxle.maxMotorTorque = 100000
	end
	return true
end



onLeftWheel = function( event )
	if(event.target:pressed()) then
		leftAxle.isMotorEnabled = true
		leftAxle.motorSpeed = wheelSpeed
		leftAxle.maxMotorTorque = 100000
	else
		leftAxle.isMotorEnabled = false
		leftAxle.motorSpeed = 0
		leftAxle.maxMotorTorque = 100000
	end
	return true
end



-- ==
--		dragPart() - EFM
-- ==
dragPart = function( self, event )
	local phase = event.phase
 
    if( phase == "began" ) then
	    display.getCurrentStage():setFocus(self,event.id)
		self.isFocus = true
		self.tempJoint = physics.newJoint( "touch", self, self.x, self.y )
		self.tempJoint.maxForce = touchJointForce
	
	elseif( self.isFocus ) then

		if( phase == "moved" ) then
			self.tempJoint:setTarget( event.x, event.y )

		elseif( phase == "ended" ) then
			display.getCurrentStage():setFocus( self, nil )
			self.isFocus = false

			display.remove( self.tempJoint ) 
		end			
    end 
    return true
end

addDragger = function( obj )

	obj.touch = dragPart
	obj:addEventListener( "touch", obj )

	obj:setFillColor(0,1,0)
	obj.strokeWidth = 1	
	obj:setStrokeColor(0,0,0)

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
