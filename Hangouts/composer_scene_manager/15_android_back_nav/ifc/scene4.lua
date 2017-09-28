-- =============================================================
-- Your Copyright Statement Here, YYYY-YYYY
-- =============================================================
-- Main Menu
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

----------------------------------------------------------------------
-- Handle Back Button
----------------------------------------------------------------------
local android 			= require "android"
--local backHandler = android.new( { debugEn = true } )
local backHandler

----------------------------------------------------------------------
--	Scene Methods
----------------------------------------------------------------------

----------------------------------------------------------------------
----------------------------------------------------------------------
function scene:create( event )
	local sceneGroup = self.view

	-- Create a simple background
	local back = display.newImageRect( sceneGroup, "images/protoBack.png", 380*2, 570*2 )
	back.x = centerX
	back.y = centerY
	if(w>h) then back.rotation = 90 end

	-- Create a label showing which scene this is
	local label = display.newEmbossedText( sceneGroup, "Scene 4", centerX, 40, native.systemFont, 60 )
	label:setFillColor( 0xCC/255, 1, 1  )
	local color = 
	{
	    highlight = { r=1, g=1, b=1 },
	    shadow = { r=0, g=1, b=0.3 }
	}
	label:setEmbossColor( color )

	-- Create some buttons for navigation
	PushButton( sceneGroup, centerX, centerY + 100, "Back To Scene 2", onBack, { labelColor = {0,0,0}, labelSize = 24 } )

	if( not backHandler ) then
		backHandler = android.new( { debugEn = true, onBack = onBack } )
	end
end

----------------------------------------------------------------------
----------------------------------------------------------------------
function scene:willShow( event )
	local sceneGroup = self.view
end
----------------------------------------------------------------------
----------------------------------------------------------------------
function scene:didShow( event )
	local sceneGroup = self.view
	backHandler:activate() -- BACK_HANDLER
end

----------------------------------------------------------------------
----------------------------------------------------------------------
function scene:willHide( event )
	local sceneGroup = self.view
	backHandler:deactivate() -- BACK_HANDLER
end
----------------------------------------------------------------------
----------------------------------------------------------------------
function scene:didHide( event )
	local sceneGroup = self.view
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
	composer.gotoScene( "ifc.scene2", options  )	
	return true
end

---------------------------------------------------------------------------------
-- Scene Dispatch Events, Etc. - Generally Do Not Touch Below This Line
---------------------------------------------------------------------------------
function scene:show( event )
	local sceneGroup 	= self.view
	local willDid 	= event.phase
	if( willDid == "will" ) then
		self:willShow( event )
	elseif( willDid == "did" ) then
		self:didShow( event )
	end
end
function scene:hide( event )
	local sceneGroup 	= self.view
	local willDid 	= event.phase
	if( willDid == "will" ) then
		self:willHide( event )
	elseif( willDid == "did" ) then
		self:didHide( event )
	end
end
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )
---------------------------------------------------------------------------------
return scene
