-- =============================================================
-- Your Copyright Statement Here, YYYY-YYYY
-- =============================================================
-- Splash Screen
-- =============================================================
local composer 		= require( "composer" )
local scene    		= composer.newScene()
local common 	      = require "scripts.common"

----------------------------------------------------------------------
--								LOCALS								--
----------------------------------------------------------------------
-- Variables
local splashDelay = 5000

-- Forward Declarations
local goToMainMenu

----------------------------------------------------------------------
--	Scene Methods
----------------------------------------------------------------------

----------------------------------------------------------------------
----------------------------------------------------------------------
function scene:create( event )
	local sceneGroup = self.view

	-- Create a simple background
	local back = display.newRect( sceneGroup, centerX, centerY , fullw , fullh )
   back:setFillColor(0)

	-- Create a label showing which scene this is
	local label = display.newEmbossedText( sceneGroup, "Roaming Gamer, LLC.", centerX, centerY - 150, _G.gameFont , 60 )
	label:setFillColor( unpack(_G.fontColor)  )
   label.x = fullw * 2
   transition.to( label, { x = centerX, transition = easing.outBack, time = 2000, delay = 500 } )
   
	local label = display.newEmbossedText( sceneGroup, "and", centerX, centerY - 50, _G.gameFont , 60 )
	label:setFillColor( unpack(_G.fontColor)  )
   label.x = -fullw * 2
   transition.to( label, { x = centerX, transition = easing.outBack, time = 1750, delay = 750 } )
   
	local label = display.newEmbossedText( sceneGroup, "Corona Geek", centerX, centerY + 50, _G.gameFont , 60 )
	label:setFillColor( unpack(_G.fontColor)  )
   label.x = fullw * 2
   transition.to( label, { x = centerX, transition = easing.outBack, time = 1500, delay = 1000 } )
   
   	local label = display.newEmbossedText( sceneGroup, "Present", centerX, centerY + 150, _G.gameFont , 60 )
	label:setFillColor( unpack(_G.fontColor)  )
   label.x = -fullw * 2
   transition.to( label, { x = centerX, transition = easing.outBack, time = 1250, delay = 1250 } )


	-- Automatically Go to main menu in splashDelay milliseconds 
	--
	local timerHandle = timer.performWithDelay( splashDelay, goToMainMenu )

	-- If user touches back, go to main menu early.
	--
	back.touch = function( self, event )
		if(event.phase == "ended") then
			timer.cancel(timerHandle)
			goToMainMenu()
		end
		return true
	end
	back:addEventListener( "touch" )	
end

----------------------------------------------------------------------
----------------------------------------------------------------------
function scene:willEnter( event )
	local sceneGroup = self.view
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
end

----------------------------------------------------------------------
----------------------------------------------------------------------
function scene:destroy( event )
	local sceneGroup = self.view
end

----------------------------------------------------------------------
--				FUNCTION/CALLBACK DEFINITIONS						--
----------------------------------------------------------------------
goToMainMenu = function()
	local options =
	{
		effect = "slideLeft", -- See list here: http://docs.coronalabs.com/daily/api/library/composer/gotoScene.html
		time = 500,
		params =
		{
			arg1 = "value", 
			arg2 = 0
		}
	}
	composer.gotoScene( "ifc.mainMenu", options  )	
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
