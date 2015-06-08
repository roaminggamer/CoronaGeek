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
local onMusic
local onSFX

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
	easyIFC:quickLabel( tmpGroup, "TEST 1" , centerX-1, centerY - 101, gameFont, 55, _R_ )
	easyIFC:quickLabel( tmpGroup, "TEST 1" , centerX+1, centerY - 99, gameFont, 55, _B_ )
	easyIFC:quickLabel( tmpGroup, "TEST 1" , centerX, centerY - 100, gameFont, 55, _G_ )


	-- Two Toggle Buttons
	local musicEn = easyIFC:presetToggle( tmpGroup, "default", centerX - 50, centerY, 80, 30, "Music", onMusic )	
	local sfxEn = easyIFC:presetToggle( tmpGroup, "default", centerX + 50, centerY, 80, 30, "SFX", onSFX )	

	-- Initialize button states
	if( persist.get( "settings.json", "musicEn" ) ) then
		musicEn:toggle(true) -- true says 'skip firing listener'
	end

	if( persist.get( "settings.json", "sfxEn" ) ) then
		sfxEn:toggle(true) -- true says 'skip firing listener'
	end
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
		effect = "slideLeft", -- See list here: http://docs.coronalabs.com/daily/api/library/composer/gotoScene.html
		time = 1500,
		params =
		{
			arg1 = "value", 
			arg2 = 0
		}
	}
	composer.gotoScene( "test2", options  )	
end


onMusic = function( event )
	persist.set( "settings.json", "musicEn", event.target:pressed() ) 
end


onSFX = function( event )
	persist.set( "settings.json", "sfxEn", event.target:pressed() ) 
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
