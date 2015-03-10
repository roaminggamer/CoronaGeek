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
	print("ifc.scene2 - scene:create() @ " .. getTimer())
	local sceneGroup = self.view

	-- Create a label showing which scene this is
	display.newText( sceneGroup, "Managing", centerX, 40, native.systemFont, 20 )
	display.newText( sceneGroup, "Objects (Sprites)", centerX, 70, native.systemFont, 20 )	
	display.newText( sceneGroup, "In Modules", centerX, 100, native.systemFont, 20 )
	

	-- Simple Menu
	local options = { effect = "slideLeft", time = 500, }

	PushButton( sceneGroup, centerX, centerY - 50, "Wrong", 
		        function ( self, event )  composer.gotoScene( "ifc.1_wrong", options  );  return true; end, 
				{ labelColor = {1,0,0}, labelSize = 18 } )

	PushButton( sceneGroup, centerX, centerY, "OK", 
		        function ( self, event )  composer.gotoScene( "ifc.2_ok", options  );  return true; end, 
				{ labelColor = {1,1,1}, labelSize = 18 } )

	PushButton( sceneGroup, centerX, centerY + 50, "Good", 
		        function ( self, event )  composer.gotoScene( "ifc.3_good", options  );  return true; end, 
				{ labelColor = {0,1,0}, labelSize = 18 } )

	PushButton( sceneGroup, centerX, centerY + 100, "Best", 
		        function ( self, event )  composer.gotoScene( "ifc.4_best", options  );  return true; end, 
				{ labelColor = {0,0,1}, labelSize = 18 } )


end

----------------------------------------------------------------------
----------------------------------------------------------------------
function scene:willEnter( event )
	print("ifc.scene2 - scene:willEnter() @ " .. getTimer())
	local sceneGroup = self.view
end
----------------------------------------------------------------------
----------------------------------------------------------------------
function scene:didEnter( event )
	print("ifc.scene2 - scene:didEnter() @ " .. getTimer())
	local sceneGroup = self.view
end

----------------------------------------------------------------------
----------------------------------------------------------------------
function scene:willExit( event )
	print("ifc.scene2 - scene:willExit() @ " .. getTimer())
	local sceneGroup = self.view
end
----------------------------------------------------------------------
----------------------------------------------------------------------
function scene:didExit( event )
	print("ifc.scene2 - scene:didExit() @ " .. getTimer())
	local sceneGroup = self.view
end

----------------------------------------------------------------------
----------------------------------------------------------------------
function scene:destroy( event )
	print("ifc.scene2 - scene:destroy() @ " .. getTimer())
	local sceneGroup = self.view
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
