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
local onGotoScene2
local onGotoScene3
local onOptions

----------------------------------------------------------------------
-- Handle Back Button
----------------------------------------------------------------------
local android 			= require "android"
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
	local label = display.newEmbossedText( sceneGroup, "Scene 1", centerX, 40, native.systemFont, 60 )
	label:setFillColor( 0xCC/255, 1, 1  )
	local color = 
	{
	    highlight = { r=1, g=1, b=1 },
	    shadow = { r=0, g=1, b=0.3 }
	}
	label:setEmbossColor( color )

	-- Create some buttons for navigation
	PushButton( sceneGroup, centerX, centerY - 100, "Go To Scene 2", onGotoScene2, { labelColor = {1,0.5,0}, labelSize = 24 } )
	PushButton( sceneGroup, centerX, centerY, "Go To Scene 3", onGotoScene3, { labelColor = {0,1,0}, labelSize = 24 } )

	local optionsButton = PushButton( sceneGroup, centerX, centerY + 100, "Options", onOptions, 
	                          { labelColor = {0,1,1}, labelSize = 24 } )

	if( not backHandler ) then
		backHandler = android.new( { 
			debugEn = true, 
			title = "Quit Game?", 
			msg = "This will exit the game.\n\nAre you sure you want to quit?" } )
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
onGotoScene2 = function ( self, event ) 
	composer.gotoScene( "ifc.scene2", options  )	
	return true
end

onGotoScene3 = function ( self, event ) 
	composer.gotoScene( "ifc.scene3", options  )	
	return true
end

onOptions = function ( self, event ) 
  -- BACK_HANDLER	
	--
	-- Overlays are a little tricky.  They don't trigger this scenes exit events because we are not actually exiting.
	--
	backHandler:deactivate() -- BACK_HANDLER
	local function onCloseOverlay()
		backHandler:activate() -- BACK_HANDLER
	end
	
	local options =
	{
		isModal = true, -- Don't let touches leak through
		effect = "fade", -- See list here: http://docs.coronalabs.com/daily/api/library/composer/gotoScene.html
		time = 30,
		params =
		{
			onCloseOverlay = onCloseOverlay -- BACK_HANDLER	
		}
	}
	composer.showOverlay( "ifc.optionsOverlay", options  )	
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
