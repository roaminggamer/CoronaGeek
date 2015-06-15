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

local parts

local lDamp					= 0 -- 1
local aDamp					= 0 -- 100
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
	local tmp = easyIFC:quickLabel( layers.overlay, "Simple Joint", centerX, top + 20, gameFont2, 22, hexcolor("#2B547E")  )


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

	local myFilter = { groupIndex = - 1 }

	-- Body Parts
	parts = {}

	-- Body Size and PositioningVariables
	local jointsRadius = 12

	local segmentLen  = 100
	local segmentThickness = jointsRadius * 2 - 2

	-- ==
	--   cube
	-- ==	
	parts.cube = display.newRect( layers.content, 0, 0, 40, 40 )
	parts.cube.x = centerX
	parts.cube.y = centerY
	parts.cube:setFillColor( 1, 1, 0 )
	physics.addBody( parts.cube, "static", { density = 1, filter = myFilter } )
	--parts.cube.isSleepingAllowed = false

	-- ==
	--   PIVOT ARM
	-- ==
	--parts.segment1, parts.marker1, parts.marker2 = createArmSegment( layers.content, parts.cube.x, parts.cube.y, segmentLen, segmentThickness, jointsRadius )
	parts.segment1, parts.marker1, parts.marker2 = createArmSegment( layers.content, parts.cube.x + segmentLen/2 - jointsRadius, parts.cube.y, segmentLen, segmentThickness, jointsRadius )
	parts.pivotJoint = physics.newJoint( "pivot", parts.marker2, parts.cube, parts.cube.x, parts.cube.y)
	parts.marker1.isSleepingAllowed = false

	-- Add dragger to parts	
	--
	----[[
	addDragger( parts.cube )
	addDragger( parts.marker1 )
	--]]

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
