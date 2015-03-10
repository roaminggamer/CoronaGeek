-- =============================================================
-- Your Copyright Statement Here, YYYY-YYYY
-- =============================================================
-- Scene 1
-- =============================================================
local composer 		= require( "composer" )
local scene    		= composer.newScene()
local myPersistentData 		= require "scripts.myPersistentData"

----------------------------------------------------------------------
--								LOCALS								--
----------------------------------------------------------------------
-- Variables
local w = display.contentWidth
local h = display.contentHeight
local centerX = display.contentCenterX
local centerY = display.contentCenterY

local sceneNum = 10

local lastCountLabel
local newDefaultLabel

-- Forward Declarations


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
	local startTime = getTimer()
	local label = display.newText( sceneGroup, "Scene " .. sceneNum, w - 10, 20, native.systemFont, 10 )
	label.anchorX = 1
	label:setFillColor(1,0,1)

	lastCountLabel = display.newText( sceneGroup, "", centerX, 20, native.systemFont, 8 )
	lastCountLabel.anchorX = 0

	newDefaultLabel = display.newText( sceneGroup, "", centerX, 40, native.systemFont, 8 )
	newDefaultLabel.anchorX = 0

	
	local endTime = getTimer()
	post( "onSceneEvent", { action = "created in " .. endTime - startTime .. " ms" , sceneNum = sceneNum } )
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

	local value =  myPersistentData.get("count")
	myPersistentData.set( "count", value + 1, true )

	lastCountLabel.text = "Count " .. value	

	newDefaultLabel.text = tostring( myPersistentData.get("something") )

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

	lastSceneLabel = nil
	lastCountLabel = nil

	post( "onSceneEvent", { action = "destroyed @ " .. getTimer() , sceneNum = sceneNum } )
end

----------------------------------------------------------------------
--				FUNCTION/CALLBACK DEFINITIONS						--
----------------------------------------------------------------------


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
