-- =============================================================
-- Your Copyright Statement Here, YYYY-YYYY
-- =============================================================
-- Overlay 1
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
local onHide

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
	print("ifc.overlay1 - scene:create() @ " .. getTimer())
	local sceneGroup = self.view

	-- Create a label showing which scene this is
	local labelBack = display.newRect( sceneGroup, w-60, 15, 120, 30)
	local label = display.newText( sceneGroup, "Overlay 1", labelBack.x, labelBack.y, native.systemFont, 20 )
	label:setFillColor(0,0,1)
	

	-- Create a button
	PushButton( sceneGroup, w - 50, h - 100, "Hide Overlay", onHide, 
	                          { labelColor = {0,0,0}, labelSize = 14 } )

end

----------------------------------------------------------------------
----------------------------------------------------------------------
function scene:willEnter( event )
	print("ifc.overlay1 - scene:willEnter() @ " .. getTimer())
	local sceneGroup = self.view
end
----------------------------------------------------------------------
----------------------------------------------------------------------
function scene:didEnter( event )
	print("ifc.overlay1 - scene:didEnter() @ " .. getTimer())
	local sceneGroup = self.view
end

----------------------------------------------------------------------
----------------------------------------------------------------------
function scene:willExit( event )
	print("ifc.overlay1 - scene:willExit() @ " .. getTimer())
	local sceneGroup = self.view
end
----------------------------------------------------------------------
----------------------------------------------------------------------
function scene:didExit( event )
	print("ifc.overlay1 - scene:didExit() @ " .. getTimer())
	local sceneGroup = self.view
end

----------------------------------------------------------------------
----------------------------------------------------------------------
function scene:destroy( event )
	print("ifc.overlay1 - scene:destroy() @ " .. getTimer())
	local sceneGroup = self.view
end

----------------------------------------------------------------------
--				FUNCTION/CALLBACK DEFINITIONS						--
----------------------------------------------------------------------
onHide = function ( self, event ) 
	print("--------------------------")
	composer.hideOverlay( )	
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
