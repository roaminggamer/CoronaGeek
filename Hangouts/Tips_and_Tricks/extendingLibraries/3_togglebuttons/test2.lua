-- =============================================================
-- Your Copyright Statement Here, YYYY-YYYY
-- =============================================================
-- Splash Screen
-- =============================================================
local composer 		= require( "composer" )
local scene    		= composer.newScene()

----------------------------------------------------------------------
--								LOCALS								--
----------------------------------------------------------------------
-- Variables
local tmpGroup

-- Forward Declarations
local onOtherScene
local onDifficulty

-- Useful Localizations
-- SSK 
local newSprite         = ssk.display.sprite
local newCircle         = ssk.display.circle
local newRect           = ssk.display.rect
local newImageRect      = ssk.display.imageRect
local easyIFC           = ssk.easyIFC
local persist 			= ssk.persist

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

	tmpGroup = display.newGroup()
	sceneGroup:insert(tmpGroup)

	-- Create a simple background
	newImageRect( tmpGroup, centerX, centerY, "images/protoBack.png",
		          { w=  380, h = 570, rotation = 90 } )

	-- Create a Label
	easyIFC:quickLabel( tmpGroup, "TEST 2" , centerX-1, centerY - 101, gameFont, 55, _R_ )
	easyIFC:quickLabel( tmpGroup, "TEST 2" , centerX+1, centerY - 99, gameFont, 55, _B_ )
	easyIFC:quickLabel( tmpGroup, "TEST 2" , centerX, centerY - 100, gameFont, 55, _G_ )



	-- Three radio Buttons	
	local difficultyButtons = {}
	difficultyButtons[1] = easyIFC:presetRadio( tmpGroup, "default", centerX - 50, centerY, 30, 30, "1", onDifficulty )	
	difficultyButtons[2] = easyIFC:presetRadio( tmpGroup, "default", centerX, centerY, 30, 30, "2", onDifficulty )	
	difficultyButtons[3] = easyIFC:presetRadio( tmpGroup, "default", centerX + 50, centerY, 30, 30, "3", onDifficulty )	

	difficultyButtons[persist.get( "settings.json", "difficulty" )]:toggle()

	-- Scene changing button
	easyIFC:presetToggle( tmpGroup, "default", right - 45, bottom - 20, 80, 30, "Switch", onOtherScene )	
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
	display.remove(tmpGroup)
	tmpGroup = nil
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
end

----------------------------------------------------------------------
--				FUNCTION/CALLBACK DEFINITIONS						--
----------------------------------------------------------------------
onOtherScene = function()
	local options =
	{
		effect = "slideRight", -- See list here: http://docs.coronalabs.com/daily/api/library/composer/gotoScene.html
		time = 1500,
		params =
		{
			arg1 = "value", 
			arg2 = 0
		}
	}
	composer.gotoScene( "test1", options  )	
end


onDifficulty = function( event )
	persist.set( "settings.json", "difficulty", tonumber(event.target:getText()) ) 
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
