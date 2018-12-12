-- =============================================================
-- Your Copyright Statement Here, YYYY-YYYY
-- =============================================================
-- Main Menu
-- =============================================================
local composer 			= require( "composer" )
local scene    			= composer.newScene()
local commonListeners 	= require "scripts.commonListeners"
----------------------------------------------------------------------
--	Scene Methods
----------------------------------------------------------------------

----------------------------------------------------------------------
----------------------------------------------------------------------
function scene:create( event )
	local sceneGroup = self.view

	-- Create a label showing which scene this is
	local label = display.newText( sceneGroup, "Scene 5", display.contentCenterX, display.contentCenterY - 200, native.systemFont, 60 )


	-- Create some buttons for navigation
	local button1 = PushButton( sceneGroup, display.contentCenterX - 150, display.contentCenterY, "Scene 4", 
		                         commonListeners.listener1, 
	                            { labelColor = {0,1,0}, labelSize = 24 } )

	local optionsButton = PushButton( sceneGroup, display.contentCenterX + 150, display.contentCenterY, "Scene 1", 
		                               commonListeners.listener2, 
	                                  { labelColor = {0,1,1}, labelSize = 24 } )

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
	commonListeners.setDestinations( "scene4", "scene1" )
end

----------------------------------------------------------------------
----------------------------------------------------------------------
function scene:willHide( event )
	local sceneGroup = self.view
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
