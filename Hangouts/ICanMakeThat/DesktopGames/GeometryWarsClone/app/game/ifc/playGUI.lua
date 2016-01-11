-- =============================================================
-- Your Copyright Statement Here, YYYY-YYYY
-- =============================================================
-- Play GUI
-- =============================================================
local composer 		= require( "composer" )
local scene    		= composer.newScene()
local common 	      = require "scripts.common"
local game 	         = require "scripts.game"

----------------------------------------------------------------------
--								LOCALS								--
----------------------------------------------------------------------
-- Variables
local enableKeys = false

-- Forward Declarations

-- Useful Localizations

----------------------------------------------------------------------
--	Scene Methods
----------------------------------------------------------------------

----------------------------------------------------------------------
----------------------------------------------------------------------
function scene:create( event )
	local sceneGroup = self.view
   
   -- Trick
   sceneGroup.overlay = display.newGroup()
   sceneGroup:insert(sceneGroup.overlay)
   
   -- Create a button
	PushButton( sceneGroup.overlay, left + 45, bottom - 25, "Back", scene.onBack, { labelColor = {0.8,0.2,0.2}, labelSize = 18, width = 80} )
   sceneGroup.overlay.isVisible = false
end

----------------------------------------------------------------------
----------------------------------------------------------------------
function scene:willEnter( event )
	local sceneGroup = self.view
   enableKeys = true
end
----------------------------------------------------------------------
----------------------------------------------------------------------
function scene:didEnter( event )
	local sceneGroup = self.view   
   game.create( sceneGroup )   
   sceneGroup.overlay:toFront()
   sceneGroup.overlay.isVisible = true
end

----------------------------------------------------------------------
----------------------------------------------------------------------
function scene:willExit( event )
	local sceneGroup = self.view
   enableKeys = false
   sceneGroup.overlay.isVisible = false
end
----------------------------------------------------------------------
----------------------------------------------------------------------
function scene:didExit( event )
	local sceneGroup = self.view
   game.destroy()   
end

----------------------------------------------------------------------
----------------------------------------------------------------------
function scene:destroy( event )
	local sceneGroup = self.view
end

----------------------------------------------------------------------
--				FUNCTION/CALLBACK DEFINITIONS						--
----------------------------------------------------------------------
scene.onBack = function ( self, event ) 
	local options =
	{
		effect = "slideDown", -- See list here: http://docs.coronalabs.com/daily/api/library/composer/gotoScene.html
		time = 500,
		params =
		{
			skipAnimation = true
		}
	}
	composer.gotoScene( "ifc.mainMenu", options  )	
	return true
end


function scene.key( self, event )      
   table.dump(event)
   if( not enableKeys ) then return false end
   
   
   if( event.phase == "down" ) then         
      if( event.keyName == "buttonSelect" ) then
         --print( event.keyName, params.nextKey )
         timer.performWithDelay( 1, 
            function()
               scene.onBack()
            end )
      end
   end
   
   return false      
end 
Runtime:addEventListener( "key", scene )



---------------------------------------------------------------------------------
-- Scene Dispatch Events, Etc. - Generally Do Not Touch Below This Line
---------------------------------------------------------------------------------
function scene:show( event )
	sceneGroup 	= self.view
	local willDid 	= event.phase
	if( willDid == "will" ) then
		self:willEnter( event )
	elseif( willDid == "did" ) then
		self:didEnter( event )
	end
end
function scene:hide( event )
	sceneGroup 	= self.view
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
