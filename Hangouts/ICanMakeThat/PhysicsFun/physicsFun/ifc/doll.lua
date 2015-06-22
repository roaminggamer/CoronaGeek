-- =============================================================
-- Your Copyright Statement Here, YYYY-YYYY
-- =============================================================
-- Doll Example
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

local parts

local lDamp					= 1
local aDamp					= 100
local touchJointForce		= 100000

-- Forward Declarations
local onMainMenu
local onGravity

local createArmSegment
local createLegSegment
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
	local tmp = easyIFC:quickLabel( layers.overlay, "Draggable Rag Doll", centerX, top + 20, gameFont2, 22, hexcolor("#2B547E")  )


	-- Create a basic push button
	easyIFC:presetPush( layers.overlay, "default", right - 30, bottom - 15, 60, 30, "Back", onMainMenu )
	easyIFC:presetToggle( layers.overlay, "default", right - 35, top + 20, 60, 30, "Gravity", onGravity, { labelSize = 12 } )
end

----------------------------------------------------------------------
----------------------------------------------------------------------
function scene:willEnter( event )
	local sceneGroup = self.view	

	physics.start()
	physics.setGravity( 0, 0 )
	--physics.setContinuous( true )

	local filter = { groupIndex = -1 }

	local torsoEn 		= true
	local headEn		= true and torsoEn
	local rightArmEn 	= true and torsoEn
	local leftArmEn 	= true and torsoEn
	local rightLegEn 	= true and torsoEn and rightArmEn
	local leftLegEn 	= true and torsoEn and leftArmEn
	local draggingEn 	= true and (torsoEn and headEn and rightArmEn and leftArmEn and rightLegEn and leftLegEn )

	-- Body Parts
	parts = {}

	-- Body Size and PositioningVariables
	local jointsRadius = 12
	local neckLength = 6

	local armSegmentLength  = 64
	local armSegmentThickness = jointsRadius * 2 - 2

	local legSegmentLength = 72 
	local legSegmentThickness  = jointsRadius * 2 - 2

	-- ==
	--   Ground
	-- ==	
	local ground = display.newRect( layers.content, 0, 0, 300, 20 )
	ground.x = centerX
	ground.y = bottom - 15
	ground:setFillColor( 0.2, 0.2, 0.2 )
	physics.addBody( ground, "static" )

	-- ==
	--   TORSO
	-- ==	
	if( torsoEn ) then		
		parts.torso = display.newRoundedRect( layers.content, 0, 0, 62, 96, jointsRadius )
		parts.torso.x = centerX
		parts.torso.y = centerY - 24
		parts.torso:setFillColor( 1, 1, 0 )
		physics.addBody( parts.torso, { density = 1, filter = filter } )
		parts.torso.linearDamping = lDamp
		parts.torso.angularDamping = aDamp
		parts.torso.isSleepingAllowed = false
	end

	-- ==
	--   HEAD
	-- ==
	if( headEn ) then
		parts.head = display.newCircle( layers.content, 0, 0, 18 )
		parts.head.x = parts.torso.x
		parts.head.y = parts.torso.y - parts.torso.contentHeight/2 - parts.head.contentHeight/2 - neckLength
		physics.addBody( parts.head, { density = 1, filter = filter, radius = 18 } )
		physics.newJoint( "weld", parts.head, parts.torso, parts.head.x, parts.head.y )
	end

	-- ==
	--   ARMS
	-- ==

	if( rightArmEn ) then
		parts.rBicep, parts.rTmp, parts.rShoulderMarker = createArmSegment( layers.content, centerX + 40, centerY-60, armSegmentLength, armSegmentThickness, jointsRadius )
		parts.rForearm, parts.rHandMarker, parts.rElbowMarker = createArmSegment( layers.content, centerX + 40 + armSegmentLength - 2 * jointsRadius, centerY-60, armSegmentLength, armSegmentThickness, jointsRadius )
		parts.rightElbowJoint = physics.newJoint( "pivot", parts.rForearm, parts.rBicep, parts.rElbowMarker.x, parts.rElbowMarker.y )
		parts.rightShoulderJoint = physics.newJoint( "pivot", parts.rBicep, parts.torso, parts.rShoulderMarker.x, parts.rShoulderMarker.y )
		display.remove(parts.rTmp)
		parts.rTmp = nil
		parts.rElbowMarker:setFillColor(0,0,1)		
	end

	if( leftArmEn ) then
		parts.lBicep, parts.lShoulderMarker, parts.lTmp = createArmSegment( layers.content, centerX - 40, centerY-60, armSegmentLength, armSegmentThickness, jointsRadius )
		parts.lForearm, parts.lElbowMarker, parts.lHandMarker = createArmSegment( layers.content, centerX - 40 - armSegmentLength + 2 * jointsRadius, centerY-60, armSegmentLength, armSegmentThickness, jointsRadius )
		parts.leftElbow = physics.newJoint( "pivot", parts.lBicep, parts.lElbowMarker, parts.lElbowMarker.x, parts.lElbowMarker.y )
		parts.leftShoulderJoint = physics.newJoint( "pivot", parts.lShoulderMarker, parts.torso, parts.lShoulderMarker.x, parts.lShoulderMarker.y )
		display.remove(parts.lTmp)
		parts.lTmp = nil
		parts.lElbowMarker:setFillColor(1,0,0)	
	end 

	-- ==
	--   LEGS
	-- ==
	if( rightLegEn ) then
		parts.rThigh, parts.rTmp, parts.rHipMarker = createLegSegment( layers.content, parts.rShoulderMarker.x, centerY + 36, legSegmentThickness, legSegmentLength, jointsRadius )
		parts.rCalf, parts.rFootMarker, parts.rKneeMarker = createLegSegment( layers.content, parts.rShoulderMarker.x, centerY + 82, legSegmentThickness, legSegmentLength, jointsRadius )
		parts.rightKnee = physics.newJoint( "pivot", parts.rThigh, parts.rCalf, parts.rKneeMarker.x, parts.rKneeMarker.y )
		parts.rightHipJoint = physics.newJoint( "pivot", parts.rHipMarker, parts.torso, parts.rHipMarker.x, parts.rHipMarker.y )
		display.remove(parts.rTmp)
		parts.rTmp = nil
		parts.rKneeMarker:setFillColor(0,0,1)		
	end

	if( leftLegEn ) then
		parts.lThigh, parts.lTmp, parts.lHipMarker = createLegSegment( layers.content, parts.lShoulderMarker.x, centerY + 36, legSegmentThickness, legSegmentLength, jointsRadius )
		parts.lCalf, parts.lFootMarker, parts.lKneeMarker = createLegSegment( layers.content, parts.lShoulderMarker.x, centerY + 82, legSegmentThickness, legSegmentLength, jointsRadius )
		parts.leftKneeJoint = physics.newJoint( "pivot", parts.lThigh, parts.lCalf, parts.lKneeMarker.x, parts.lKneeMarker.y )
		parts.leftHipJoint = physics.newJoint( "pivot", parts.lHipMarker, parts.torso, parts.lHipMarker.x, parts.lHipMarker.y )
		display.remove(parts.lTmp)
		parts.lTmp = nil
		parts.lKneeMarker:setFillColor(1,0,0)	
	end

	-- Turn Head, Hands, and Feet into draggable objects
	--
	if( draggingEn ) then
		addDragger( parts.head )
		addDragger( parts.rHandMarker )
		addDragger( parts.lHandMarker )
		addDragger( parts.torso )
		addDragger( parts.rFootMarker )
		addDragger( parts.lFootMarker )
	end

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

	parts = nil

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


-- ==
--		createArmSegment() - EFM
-- ==
createArmSegment = function( group, x, y, width, height, radius ) 
	local filter = { groupIndex = - 1 }

	local segment = display.newRoundedRect( group, 0, 0 , width, height, 12 )
	physics.addBody( segment, { density = 1, filter = filter } )

	segment.x = x
	segment.y = y
	segment.linearDamping = lDamp
	segment.angularDamping = aDamp

	local joint1  = display.newCircle(group, 0, 0, radius-1)
	joint1:setFillColor( 0.78, 0.78, 0.78 )
	joint1.strokeWidth = 1	
	joint1:setStrokeColor(0,0,0)
	joint1.x = segment.x + segment.contentWidth/2 - joint1.contentWidth/2
	joint1.y = segment.y
	physics.addBody( joint1, { density = 1, filter = filter, radius = radius-1 } )

	local joint2  = display.newCircle(group, 0, 0, radius-1)
	joint2:setFillColor( 0.78, 0.78, 0.78 )
	joint2.strokeWidth = 1	
	joint2:setStrokeColor(0,0,0)
	joint2.x = segment.x - segment.contentWidth/2 + joint2.contentWidth/2
	joint2.y = segment.y
	physics.addBody( joint2, { density = 1, filter = filter, radius = radius-1 } )

	physics.newJoint( "weld", joint1, segment, joint1.x, joint1.y )
	physics.newJoint( "weld", joint2, segment, joint2.x, joint2.y )

	return segment, joint1, joint2
end


-- ==
--		createLegSegment() - EFM
-- ==
createLegSegment = function( group, x, y, width, height, radius ) 
	local filter = { groupIndex = - 1 }

	local segment = display.newRoundedRect( group, 0, 0 , width, height, 12 )
	physics.addBody( segment, { density = 1, filter = filter } )

	segment.x = x
	segment.y = y
	segment.linearDamping = lDamp
	segment.angularDamping = aDamp


	local joint1  = display.newCircle(group, 0, 0, radius-1)
	joint1:setFillColor( 0.78, 0.78, 0.78 )
	joint1.strokeWidth = 1	
	joint1:setStrokeColor(0,0,0)
	joint1.y = segment.y + segment.contentHeight/2 - joint1.contentHeight/2
	joint1.x = segment.x
	physics.addBody( joint1, { density = 1, filter = filter, radius = radius-1 } )

	local joint2  = display.newCircle(group, 0, 0, radius-1)
	joint2:setFillColor( 0.78, 0.78, 0.78 )
	joint2.strokeWidth = 1	
	joint2:setStrokeColor(0,0,0)
	joint2.y = segment.y - segment.contentHeight/2 + joint2.contentHeight/2
	joint2.x = segment.x
	physics.addBody( joint2, { density = 1, filter = filter, radius = radius-1 } )

	physics.newJoint( "weld", joint1, segment, joint1.x, joint1.y )
	physics.newJoint( "weld", joint2, segment, joint2.x, joint2.y )

	return segment, joint1, joint2
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
