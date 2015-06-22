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
local backImage

local touchJointForce = 20

local filter = { groupIndex = -1 }

-- Forward Declarations
local onMainMenu
local onGravity
local onRenderMode
local onTouchStrength

local createTouch 
local createPivot 
local createWeld
local createDistance
local createFriction
local createRope
local createPulley
local createGear
local createPiston


local addNameLabel
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
	local tmp = easyIFC:quickLabel( layers.overlay, "Joints Sampler", centerX, top + 20, gameFont2, 22, hexcolor("#2B547E")  )


	-- Create a basic push button
	easyIFC:presetPush( layers.overlay, "default", right - 30, bottom - 15, 60, 30, "Back", onMainMenu )
	easyIFC:presetToggle( layers.overlay, "default", right - 35, top + 20, 60, 30, "Gravity", onGravity, { labelSize = 12 } )
	easyIFC:presetToggle( layers.overlay, "default", right - 35, top + 50, 60, 30, "Hybrid", onRenderMode, { labelSize = 12 } )
	easyIFC:presetToggle( layers.overlay, "default", right - 35, top + 80, 60, 30, "Strength", onTouchStrength, { labelSize = 12 } )

	
end

----------------------------------------------------------------------
----------------------------------------------------------------------
function scene:willEnter( event )
	local sceneGroup = self.view	

	-- Start Physics and Set Gravity to 0
	--
	physics.start()
	physics.setGravity( 0, 0 )
	

	-- Create a 'ground' object
	--
	local body = display.newRect( layers.content, 0, 0, fullw, 20 )
	body.x = centerX
	body.y = bottom - 10
	body:setFillColor( 0.5, 0.5, 0.5 )
	physics.addBody( body, "static", { bounce = 0, friction = 0.5 } )

	-- Add the samples
	--
	createTouch( left + 50, centerY - 100 )
	createWeld( left + 40, centerY - 40 )	

	createTouch( left + 50, centerY + 50 )
	createPivot( left + 40, centerY + 100 )

	createDistance( left + 150, centerY - 50 )	

	createRope( left + 250, centerY - 50 )	

	createPulley( left + 400, centerY )	

	--createFriction( left + 250, centerY - 50 )	
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
	physics.setDrawMode( "normal" )
	physics.stop()

	layers:purge("content")

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

onRenderMode = function( event )
	if(event.target:pressed()) then		
		physics.setDrawMode( "hybrid" )
	else
		print("normal")
		physics.setDrawMode( "normal" )
	end
	return true
end

onTouchStrength = function( event )
	if(event.target:pressed()) then		
		touchJointForce = 100000
	else
		touchJointForce = 20
	end
	return true
end


-- ==
--		createTouch () - Touch joint sample
-- ==
createTouch = function( x, y )	
	-- Create a block with a dynamic body
	--
	local block  = display.newRect( layers.content, 0, 0, 40, 40 )
	block.x = x
	block.y = y
	block :setFillColor( 1, 1, 0 )
	physics.addBody( block , "dynamic", { density = 1, friction = 0.5 } )
	block.linearDamping = 1
	block.angularDamping = 1
	block.isSleepingAllowed = false

	-- Attach a label that will follow the object
	--
	addNameLabel( block, "Touch")

	-- Add dragger touch handler
	--
	addDragger( block  )
end

-- ==
--		createPivot () - Pivot joint sample
-- ==
createPivot = function( x, y )
	-- Create a static object to anchor to
	--
	local anchor = display.newCircle( x, y, 10 )
	anchor.isVisible = false
	physics.addBody( anchor, "static", { filter = filter, radius = 0.05 } )
	
	-- Create a block with a dynamic body
	--
	local block  = display.newRect( layers.content, 0, 0, 40, 40 )
	block.x = x
	block.y = y
	block :setFillColor( 1, 1, 0 )
	physics.addBody( block , "dynamic", { density = 1, friction = 0.5 } )
	block.linearDamping = 1
	block.angularDamping = 1
	block.isSleepingAllowed = false

	-- Mount the 'block' to the anchor
	--
	physics.newJoint( "pivot", anchor, block, x, y )

	-- Attach a label that will follow the object
	--
	addNameLabel( block, "Pivot")

	-- Add dragger touch handler
	--
	addDragger( block )
end

-- ==
--		createWeld () - Weld joint sample
-- ==
createWeld = function( x, y )
	-- Create a static object to anchor to
	--
	local anchor = display.newCircle( x, y, 10 )
	anchor.isVisible = false
	physics.addBody( anchor, "static", { filter = filter, radius = 0.05 } )
	
	-- Create a block with a dynamic body
	--
	local block  = display.newRect( layers.content, 0, 0, 40, 40 )
	block.x = x
	block.y = y
	block :setFillColor( 1, 1, 0 )
	physics.addBody( block , "dynamic", { density = 1, friction = 0.5 } )
	block.linearDamping = 1
	block.angularDamping = 1
	block.isSleepingAllowed = false

	-- Mount the 'block' to the anchor
	--
	physics.newJoint( "weld", anchor, block, x, y )

	-- Attach a label that will follow the object
	--
	addNameLabel( block, "Weld")

	-- Add dragger touch handler
	--
	addDragger( block )
end

-- ==
--		createDistance() - Distance joint sample
-- ==
createDistance = function( x, y )	
	-- Create a block with a dynamic body
	--
	local blockA = display.newRect( layers.content, 0, 0, 60, 40 )
	blockA.x = x
	blockA.y = y
	blockA :setFillColor( 1, 1, 0 )
	physics.addBody( blockA , "dynamic", { density = 1, friction = 0.5 } )
	blockA.linearDamping = 1
	blockA.angularDamping = 1
	blockA.isSleepingAllowed = false


	-- Create a block with a dynamic body
	--
	local blockB = display.newRect( layers.content, 0, 0, 60, 40 )
	blockB.x = x
	blockB.y = y + 100
	blockB :setFillColor( 1, 1, 0 )
	physics.addBody( blockB , "dynamic", { density = 1, friction = 0.5 } )
	blockB.linearDamping = 1
	blockB.angularDamping = 1
	blockB.isSleepingAllowed = false

	-- Mount the objects to each other with a distance joint
	--
	physics.newJoint( "distance", blockA, blockB, blockA.x, blockA.y, blockB.x, blockB.y )



	-- Attach a label that will follow the objects
	--
	addNameLabel( blockA, "Distance A")
	addNameLabel( blockB, "Distance B")

	-- Add dragger touch handler
	--
	addDragger( blockA  )
	addDragger( blockB  )
end

-- ==
--		createFriction() - Distance joint sample
-- ==
createFriction = function( x, y )	
	-- Create a block with a dynamic body
	--
	local blockA = display.newRect( layers.content, 0, 0, 60, 40 )
	blockA.x = x
	blockA.y = y
	blockA :setFillColor( 1, 1, 0 )
	physics.addBody( blockA , "dynamic", { density = 1, friction = 0.5 } )
	blockA.linearDamping = 1
	blockA.angularDamping = 1
	blockA.isSleepingAllowed = false


	-- Create a block with a dynamic body
	--
	local blockB = display.newRect( layers.content, 0, 0, 60, 40 )
	blockB.x = x + 0
	blockB.y = y + 42
	blockB :setFillColor( 1, 1, 0 )
	physics.addBody( blockB , "dynamic", { density = 1, friction = 0.5 } )
	blockB.linearDamping = 1
	blockB.angularDamping = 1
	blockB.isSleepingAllowed = false

	-- Mount the objects to each other with a friction joint
	--
	local frictionJoint = physics.newJoint( "friction", blockA, blockB, blockA.x, blockA.y )
	frictionJoint.maxForce = 5
	frictionJoint.maxTorque = 5

	-- Attach a label that will follow the objects
	--
	addNameLabel( blockA, "Friction A")
	addNameLabel( blockB, "Friction B")

	-- Add dragger touch handler
	--
	addDragger( blockA  )
	addDragger( blockB  )
end



-- ==
--		createRope() - Rope joint sample
-- ==
createRope = function( x, y )	
	-- Create a block with a dynamic body
	--
	local blockA = display.newRect( layers.content, 0, 0, 60, 40 )
	blockA.x = x
	blockA.y = y
	blockA :setFillColor( 1, 1, 0 )
	physics.addBody( blockA , "dynamic", { density = 1, friction = 0.5 } )
	blockA.linearDamping = 1
	blockA.angularDamping = 1
	blockA.isSleepingAllowed = false


	-- Create a block with a dynamic body
	--
	local blockB = display.newRect( layers.content, 0, 0, 60, 40 )
	blockB.x = x
	blockB.y = y + 100
	blockB :setFillColor( 1, 1, 0 )
	physics.addBody( blockB , "dynamic", { density = 1, friction = 0.5 } )
	blockB.linearDamping = 1
	blockB.angularDamping = 1
	blockB.isSleepingAllowed = false

	-- Mount the objects to each other with a distance joint
	--
	local ropeJoint = physics.newJoint( "rope", blockA, blockB, 0, 0, 10, 0 )
	ropeJoint.maximumLength = 100


	-- Attach a label that will follow the objects
	--
	addNameLabel( blockA, "Rope A")
	addNameLabel( blockB, "Rope B")

	-- Add dragger touch handler
	--
	addDragger( blockA  )
	addDragger( blockB  )
end

-- ==
--		createPulley() - Pulley joint sample
-- ==
createPulley = function( x, y, oy )	

	-- Optional y offset for anchorB
	oy = oy or 0

	-- Create markers for the pulley anchors
	local anchorA = display.newCircle( layers.content, x - 50, y, 2 )
	local anchorB = display.newCircle( layers.content, x + 50, y + oy, 2 )

	-- Create a block with a dynamic body
	--
	local blockA = display.newRect( layers.content, 0, 0, 40, 40 )
	blockA.x = anchorA.x
	blockA.y = anchorB.y + 50
	blockA :setFillColor( 1, 1, 0 )
	physics.addBody( blockA , "dynamic", { density = 1, friction = 0.5 } )
	blockA.linearDamping = 1
	blockA.angularDamping = 1
	blockA.isSleepingAllowed = false


	-- Create a block with a dynamic body
	--
	local blockB = display.newRect( layers.content, 0, 0, 30, 30 )
	blockB.x = anchorB.x
	blockB.y = anchorB.y + 50
	blockB :setFillColor( 1, 1, 0 )
	physics.addBody( blockB , "dynamic", { density = 1, friction = 0.5 } )
	blockB.linearDamping = 1
	blockB.angularDamping = 1
	blockB.isSleepingAllowed = false

	-- Mount the objects to each other with a distance joint
	--
	local pulleyJoint = physics.newJoint( "pulley", blockA, blockB,
		                                  anchorA.x, anchorA.y,
		                                  anchorB.x, anchorB.y,
		                                  blockA.x, blockA.y,
		                                  blockB.x, blockB.y )
	pulleyJoint.ratio = 1


	-- Attach a label that will follow the objects
	--
	addNameLabel( blockA, "Rope A")
	addNameLabel( blockB, "Rope B")

	-- Add dragger touch handler
	--
	addDragger( blockA  )
	addDragger( blockB  )
end

-- ==
--		createGear() - Gear joint sample
-- ==
createGear = function( x, y )	
end

-- ==
--		createPiston() - Piston joint sample
-- ==
createPiston = function( x, y )	
end


-- ==
--		addNameLabel() - Adds a label to an object that will follow and rotate with object
-- ==
addNameLabel = function( obj, text )
	local label = easyIFC:quickLabel( layers.overlay, text, centerX, top + 20, gameFont2, 8, _K_  )
	label.enterFrame = function( self, event ) 
	    if( self.removeSelf == nil ) then
	    	ignore( "enterFrame", self )
	    	return
	    end
	    self.x = obj.x
	    self.y = obj.y
	    self.rotation = obj.rotation
	end; listen( "enterFrame", label )
end

-- ==
--		dragPart() - EFM
-- ==
dragPart = function( self, event )
	local phase = event.phase
 
    if( phase == "began" ) then
	    display.getCurrentStage():setFocus(self,event.id)
		self.isFocus = true
		-- Use this code to set joint in middle of object
		--self.tempJoint = physics.newJoint( "touch", self, self.x, self.y )

		-- Use this code to set joint at touch point
		self.tempJoint = physics.newJoint( "touch", self, event.x, event.y )

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


-- ==
--		addDragger() - EFM
-- ==
addDragger = function( obj )
	obj.touch = dragPart
	obj:addEventListener( "touch", obj )
	obj:setFillColor(0,1,0)
	obj.strokeWidth = 1	
	obj:setStrokeColor(1,0,1)
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
