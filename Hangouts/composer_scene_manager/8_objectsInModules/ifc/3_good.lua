-- =============================================================
-- Your Copyright Statement Here, YYYY-YYYY
-- =============================================================
-- Scene 2 - Right Way To Manage Objects (Sprites) In Module (via Composer)
-- =============================================================
local composer 		= require( "composer" )
local scene    		= composer.newScene()

local spriteModule = require "scripts.spriteModule_good"

----------------------------------------------------------------------
--								LOCALS								--
----------------------------------------------------------------------
-- Variables
local w = display.contentWidth
local h = display.contentHeight
local centerX = display.contentCenterX
local centerY = display.contentCenterY


-- Forward Declarations
local onMenu

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

	-- Create a label showing which scene this is
	local label = display.newText( sceneGroup, "Sprite Module Sample - Good", centerX, 40, native.systemFont, 20 )
	
	-- Create a button
	PushButton( sceneGroup, centerX, h - 40, "Back", onMenu, 
	                          { labelColor = {1,0,0}, labelSize = 18 } )


	-- Create an animated horse
	local spriteInstance = spriteModule.create( sceneGroup, centerX, centerY )
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
end

----------------------------------------------------------------------
--				FUNCTION/CALLBACK DEFINITIONS						--
----------------------------------------------------------------------
onMenu = function ( self, event ) 
	print("--------------------------")
	local options =
	{
		effect = "slideRight",
		time = 500,
	}
	composer.gotoScene( "ifc.menu", options  )	
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
