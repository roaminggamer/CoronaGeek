-- =============================================================
-- Your Copyright Statement Here, YYYY-YYYY
-- =============================================================
-- Scene 1
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

local timeLabel
local currentTime = { nil, 0, 100, 500, 1000, 2000 }
local timeIndex = 1

local sceneTransitions = {
	"fade",
	"crossFade",
	"zoomOutIn",
	"zoomOutInFade",
	"zoomInOut",
	"zoomInOutFade",
	"flip",
	"flipFadeOutIn",
	"zoomOutInRotate",
	"zoomOutInFadeRotate",
	"zoomInOutRotate",
	"zoomInOutFadeRotate",
	"fromRight",
	"fromLeft",
	"fromTop",
	"fromBottom",
	"slideLeft",
	"slideRight" ,
	"slideDown",
	"slideUp",
}

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
	print("ifc.scene1 - scene:create() @ " .. getTimer())
	local sceneGroup = self.view

	-- Create a simple background
	local back = display.newImageRect( sceneGroup, "images/protoBack.png", 380, 570 )
	back.x = centerX
	back.y = centerY
	if(w>h) then back.rotation = 90 end
	
	local label = display.newText( sceneGroup, "Scene 1:", centerX - 5, 20, native.systemFont, 20 )
	label.anchorX = 1
	label:setFillColor(1,0,0)

	timeLabel = display.newText( sceneGroup, tostring(currentTime[timeIndex]), centerX + 5, 20, native.systemFont, 20 )
	timeLabel.anchorX = 0

	local tmp = display.newText( sceneGroup, "Choose transition time:", 5, 40, native.systemFont, 10 )
	tmp.anchorX = 0

	-- Add buttons for changing time
	local numButtons = #currentTime
	local buttonSpacing = w/numButtons
	local buttonWidth = buttonSpacing - 6
	local sx = buttonSpacing/2
	for i = 1, numButtons do
		local function onTimeChange( self, event )
			timeIndex = i
			timeLabel.text = tostring( currentTime[timeIndex] )
		end
		PushButton( sceneGroup, sx + (i-1) * buttonSpacing, 60, 
			        tostring(currentTime[i]), 
			        onTimeChange,  
			        { labelColor = {0,0,0}, labelSize = 10, 
			          width = buttonWidth, height = 20 } )
	end	


	-- Add buttons for testing transitions
	local tmp = display.newText( sceneGroup, "Click any button below to transition time:", 5, 90, native.systemFont, 10 )
	tmp.anchorX = 0
	
	local sy = 110		
	local numButtons = #sceneTransitions
	local buttonSpacing = (h-sy)/numButtons
	local buttonHeight = buttonSpacing - 4
	
	for i = 1, numButtons do
		local function onTimeChange( self, event )
			print(sceneTransitions[i], timeIndex, currentTime[timeIndex])
		
			local options = {
				effect = sceneTransitions[i],
				time = currentTime[timeIndex]
			}
			composer.gotoScene( "ifc.scene2", options  )
		end
		PushButton( sceneGroup, centerX, sy + (i-1) * buttonSpacing, 
			        tostring(sceneTransitions[i]), 
			        onTimeChange,  
			        { labelColor = {0,0,0}, labelSize = 9, 
			          width = 120, height = buttonHeight, strokeWidth = 1 } )
	end	


end

----------------------------------------------------------------------
----------------------------------------------------------------------
function scene:willEnter( event )
	print("ifc.scene1 - scene:willEnter() @ " .. getTimer())
	local sceneGroup = self.view
end
----------------------------------------------------------------------
----------------------------------------------------------------------
function scene:didEnter( event )
	print("ifc.scene1 - scene:didEnter() @ " .. getTimer())
	local sceneGroup = self.view
end

----------------------------------------------------------------------
----------------------------------------------------------------------
function scene:willExit( event )
	print("ifc.scene1 - scene:willExit() @ " .. getTimer())
	local sceneGroup = self.view
end
----------------------------------------------------------------------
----------------------------------------------------------------------
function scene:didExit( event )
	print("ifc.scene1 - scene:didExit() @ " .. getTimer())
	local sceneGroup = self.view
end

----------------------------------------------------------------------
----------------------------------------------------------------------
function scene:destroy( event )
	print("ifc.scene1 - scene:destroy() @ " .. getTimer())
	local sceneGroup = self.view
	timeLabel = nil
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
