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

local disposeGroup

-- Forward Declare Functions
local buildScene
local onChangeScene

----------------------------------------------------------------------
--	Scene Methods
----------------------------------------------------------------------

----------------------------------------------------------------------
----------------------------------------------------------------------
function scene:create( event )
	local sceneGroup = self.view
end

----------------------------------------------------------------------
----------------------------------------------------------------------
function scene:willEnter( event )
	local sceneGroup = self.view

	-- Create a group and insert it into the scene group
	--
	disposeGroup = display.newGroup()
	sceneGroup:insert(disposeGroup)

	-- Build our scene and pass in the newly created group so we can insert all 
	-- content into it.  We could do the building here, but this keeps the code clean 
	-- and makes it easy to convert to a module based approach later.
	buildScene( disposeGroup )

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

	-- Destroy and 'nil' disposeGroup to fully destroy all objects in the scene.
	--
	display.remove( disposeGroup )
	disposeGroup = nil

end

----------------------------------------------------------------------
----------------------------------------------------------------------
function scene:destroy( event )
	local sceneGroup = self.view
end

----------------------------------------------------------------------
--				FUNCTION/CALLBACK DEFINITIONS						--
----------------------------------------------------------------------

--
-- buildScene() - Takes a display group as an argument and builds scene, inserting 
--                objects into the group.
--
buildScene = function( group )
	
	-- Create a simple background
	local back = display.newImageRect( group, "images/protoBack.png", 380, 570 )
	back.x = centerX
	back.y = centerY
	if(w>h) then back.rotation = 90 end

	-- Create a label showing which scene this is
	local label = display.newEmbossedText( group, "Scene 1", centerX, 40, native.systemFont, 60 )
	label:setFillColor( 0xCC/255, 1, 1  )
	local color = 
	{
	    highlight = { r=1, g=1, b=1 },
	    shadow = { r=0, g=1, b=0.3 }
	}
	label:setEmbossColor( color )

	-- Create some buttons for navigation
	local sceneChange Button = PushButton( group, centerX, centerY - 50, "Go To Scene 2", onChangeScene, 
	                          { labelColor = {0,1,0}, labelSize = 18, width = 200 } )


	-- Create an object and move it.
	--
	local test = display.newCircle( group, centerX, centerY, 20 )
	transition.to( test, { delay = 2000, time = 1000, y = h - 10 } )
	

end

--
-- onChangeScene() - Button listener. Changes to other scene.
--
onChangeScene = function ( self, event ) 
	local options = {  effect = "fade", time = 500 }
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
