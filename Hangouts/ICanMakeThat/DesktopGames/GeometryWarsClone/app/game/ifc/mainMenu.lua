-- =============================================================
-- Your Copyright Statement Here, YYYY-YYYY
-- =============================================================
-- Main Menu
-- =============================================================
local composer 		= require( "composer" )
local scene    		= composer.newScene()
local common 	      = require "scripts.common"

----------------------------------------------------------------------
--								LOCALS								--
----------------------------------------------------------------------
-- Variables
local lastTimer 

local playB
local optionsB
local quitB

-- Forward Declarations
local onPlay
local onOptions
local explosionGenerator

----------------------------------------------------------------------
--	Scene Methods
----------------------------------------------------------------------

----------------------------------------------------------------------
----------------------------------------------------------------------
function scene:create( event )
	local sceneGroup = self.view
   
   local skipAnimation = false
   
   if( event.params and event.params.skipAnimation ) then
      skipAnimation = event.params.skipAnimation
   end


	-- Create a label showing which scene this is
	local label = display.newEmbossedText( sceneGroup, "Geometry Wars", centerX, centerY - 150, _G.gameFont , 60 )
	label:setFillColor( unpack(_G.fontColor)  )
   if( not skipAnimation ) then
      label:scale(0.05, 0.05)
      label.alpha = 0.05
      label.rotation = 720
      transition.to( label, { rotation = 0, xScale = 1, yScale = 1, transition = easing.outBack, time = 1500, delay = 500 } )
      transition.to( label, { alpha = 1, time = 2000, delay = 500 } )
   end
   
   local label = display.newEmbossedText( sceneGroup, "Retro Evolved", centerX, centerY - 50, _G.gameFont , 60 )
   label:setFillColor( unpack(_G.fontColor)  )
   if( not skipAnimation ) then
      label:scale(0.05, 0.05)
      label.alpha = 0.05
      label.rotation = -720
      transition.to( label, { rotation = 0, xScale = 1, yScale = 1, transition = easing.outBack, time = 1500, delay = 750 } )
      transition.to( label, { alpha = 1, time = 2000, delay = 500 } )
   end
   
   local label = display.newEmbossedText( sceneGroup, "Clone", centerX, centerY + 50, _G.gameFont , 60 )
	label:setFillColor( unpack(_G.fontColor)  )
   if( not skipAnimation ) then
      label:scale(0.05, 0.05)
      label.alpha = 0.05
      transition.to( label, { rotation = 0, xScale = 1, yScale = 1, transition = easing.outBounce, time = 1500, delay = 2500 } )
      transition.to( label, { alpha = 1, time = 1500, delay = 2500 } )
   end   
   
	-- Create some buttons for navigation
   local buttonsGroup = display.newGroup()
   sceneGroup:insert(buttonsGroup)
   
	playB = ControllerPushButton( buttonsGroup, centerX, bottom - 125, "Play Game", onPlay, 
              { labelColor    = _G.fontColor,
                unselFill     = { 0xa4/255, 0xee/255, 0x47/255, 0.05 },
                selFill       = { 0xa4/255, 0xee/255, 0x47/255, 0.08 },
                unselStroke   = { 0, 0, 0, 0 },
                selStroke     = { 0, 0, 0, 0 },
                labelSize     = 24, 
                labelFont     = _G.gameFont,
                width         = fullw, 
                height        = 50,
                nextKey       = "down",
                prevKey       = "up",
                pressKey      = "buttonA",
                myName        = "play",
              } )
        

	optionsB = ControllerPushButton( buttonsGroup, centerX, bottom - 75, "Options", onOptions, 
              { labelColor    = _G.fontColor,
                unselFill     = { 0xa4/255, 0xee/255, 0x47/255, 0.05 },
                selFill       = { 0xa4/255, 0xee/255, 0x47/255, 0.08 },
                unselStroke   = { 0, 0, 0, 0 },
                selStroke     = { 0, 0, 0, 0 },
                labelSize     = 24, 
                labelFont     = _G.gameFont,
                width         = fullw, 
                height        = 50,
                nextKey       = "down",
                prevKey       = "up",
                pressKey      = "buttonA",
                myName        = "options",
              } )

	quitB = ControllerPushButton( buttonsGroup, centerX, bottom - 25, "Quit Game", onQuit, 
              { labelColor    = _G.fontColor,
                unselFill     = { 0xa4/255, 0xee/255, 0x47/255, 0.05 },
                selFill       = { 0xa4/255, 0xee/255, 0x47/255, 0.08 },
                unselStroke   = { 0, 0, 0, 0 },
                selStroke     = { 0, 0, 0, 0 },
                labelSize     = 24, 
                labelFont     = _G.gameFont,
                width         = fullw, 
                height        = 50,
                nextKey       = "down",
                prevKey       = "up",
                pressKey      = "buttonA",
                myName        = "quit",
              } )
        
   playB:select(true)
   playB:setNext( optionsB )
   optionsB:setNext( quitB )
   quitB:setNext( playB )   

   if( not skipAnimation ) then
      buttonsGroup.y    = fullh
      transition.to( buttonsGroup, { y = 0, transition = easing.outCirc, time = 500, delay = 4000 } )   
   end
      
   -- Trick
   scene.explosionGroup = display.newGroup()
   sceneGroup:insert(scene.explosionGroup)
   scene.explosionGroup:toBack()
end

----------------------------------------------------------------------
----------------------------------------------------------------------
function scene:willEnter( event )
	local sceneGroup = self.view
   if( playB and playB.enableKeys ) then 
      playB:enableKeys()
      optionsB:enableKeys()
      quitB:enableKeys()
   end
end
----------------------------------------------------------------------
----------------------------------------------------------------------
function scene:didEnter( event )
	local sceneGroup = self.view   
   lastTimer = timer.performWithDelay( 5000, explosionGenerator )
end

----------------------------------------------------------------------
----------------------------------------------------------------------
function scene:willExit( event )
	local sceneGroup = self.view
   
   if( playB and playB.enableKeys ) then 
      playB:enableKeys(false)
      optionsB:enableKeys(false)
      quitB:enableKeys(false)
   end
   
   if( lastTimer ) then 
      timer.cancel( lastTimer ) 
      lastTimer = nil
   end
   
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
   
   scene.explosionGroup = nil
end

----------------------------------------------------------------------
--				FUNCTION/CALLBACK DEFINITIONS						--
----------------------------------------------------------------------
onPlay = function ( self, event ) 
	local options =
	{
		effect = "slideUp", -- See list here: http://docs.coronalabs.com/daily/api/library/composer/gotoScene.html
		time = 500,
		params =
		{
			arg1 = "value", 
			arg2 = 0
		}
	}
	composer.gotoScene( "ifc.playGUI", options  )	
	return true
end

onOptions = function ( self, event ) 
	local options =
	{
		isModal = true, -- Don't let touches leak through
		effect = "slideDown", -- See list here: http://docs.coronalabs.com/daily/api/library/composer/gotoScene.html
		time = 500,
		params =
		{
			arg1 = "value", 
			arg2 = 0
		}
	}
	composer.gotoScene( "ifc.optionsOverlay", options  )	
	return true
end


explosionGenerator = function()
   if( not scene.explosionGroup ) then return end
   
   if( lastTimer ) then 
      timer.cancel( lastTimer ) 
      lastTimer = nil
   end
   
   local explosion = require "scripts.explosion"
   explosion.create( scene.explosionGroup, math.random(-fullw/2, fullw/2) + centerX, math.random(-fullh/2, fullh/2) + centerY, 1 )

   lastTimer = timer.performWithDelay( math.random( 250, 1000 ), explosionGenerator )
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
