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

local field1  -- GATE
local field2  -- GATE

local canChangeScene = false  -- GATE

-- Forward Declare Functions
local onChangeScene  -- GATE

----------------------------------------------------------------------
--	Scene Methods
----------------------------------------------------------------------

----------------------------------------------------------------------
----------------------------------------------------------------------
function scene:create( event )
	local sceneGroup = self.view

	-- Create a simple background
	local back = display.newImageRect( sceneGroup, "images/protoBack.png", 380, 570 )
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
	local sceneChangeButton = PushButton( sceneGroup, centerX, centerY - 50, "Go To Scene 2", onChangeScene, 
	                          { labelColor = {0,1,0}, labelSize = 18, width = 200 } )

	-- Text Field For This Scene
	--	
	local function textListener(  self, event )
		if ( event.phase == "began" ) then

		elseif ( event.phase == "ended" or event.phase == "submitted" ) then
			print( event.target.text )

		elseif ( event.phase == "editing" ) then
			print( event.newCharacters )
			print( event.oldText )
			print( event.startPosition )
			print( event.text )
		end
	end

	-- Create two text fields
	field1 = native.newTextField( centerX, centerY, 300, 30 )
	field1.userInput = textListener	
	field1:addEventListener( "userInput" )
	field1.placeholder = "Both fields must contain at least"

	field1.isVisible = false
	sceneGroup:insert(field1)

	field2 = native.newTextField( centerX, centerY + 40, 300, 30 )
	field2.userInput = textListener	
	field2:addEventListener( "userInput" )
	field2.placeholder = "one letter to change scenes."

	field2.isVisible = false
	sceneGroup:insert(field2)

end

----------------------------------------------------------------------
----------------------------------------------------------------------
function scene:willEnter( event )
	local sceneGroup = self.view

	if( field1 ) then
		field1.isVisible = true
	end
	if( field2 ) then
		field2.isVisible = true
	end
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

	if( field1 ) then
		field1.isVisible = false
	end
	if( field2 ) then
		field2.isVisible = false
	end
end

----------------------------------------------------------------------
----------------------------------------------------------------------
function scene:destroy( event )
	local sceneGroup = self.view

	if( field1 ) then
		field1 = nil
	end
	if( field2 ) then
		field2 = nil
	end
end

----------------------------------------------------------------------
--				FUNCTION/CALLBACK DEFINITIONS						--
----------------------------------------------------------------------

--
-- onChangeScene() - Button listener. Changes to other scene.
--
onChangeScene = function ( self, event ) 
	if( not field1 or not field2 ) then return end -- GATE
	if( string.len(field1.text) < 1 or string.len(field2.text) < 1 ) then return end  -- GATE

	local options = {  effect = "slideLeft", time = 500 }
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
