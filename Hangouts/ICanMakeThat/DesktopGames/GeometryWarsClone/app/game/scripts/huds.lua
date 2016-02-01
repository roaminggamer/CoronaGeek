-- =============================================================
-- Copyright Roaming Gamer, LLC. 2009-2015 
-- =============================================================
-- This content produced for Corona Geek Hangouts audience.
-- You may use any and all contents in this example to make a game or app.
-- =============================================================

local public = {}

----------------------------------------------------------------------
--								REQUIRES							--
----------------------------------------------------------------------
local physics 			   = require "physics"
local common 			   = require "scripts.common"

-- Makers (builder)
local layersMaker		   = require "scripts.layersMaker"

local playerMaker 		= require "scripts.playerMaker"
local enemyManager 		= require "scripts.enemyManager"

-- Managers
local cameraMgr 			= require "scripts.cameraMgr"
local particleMgr       = require "scripts.particleMgr"


----------------------------------------------------------------------
--								DECLARATIONS						--
----------------------------------------------------------------------

-- Variables
--none.

-- Forward Declarations
--none.

-- Localizations
local mRand             = math.random
local getTimer          = system.getTimer
local pairs             = pairs
local isValid           = display.isValid

----------------------------------------------------------------------
--								DEFINITIONS							--
----------------------------------------------------------------------

-- 
-- destroy() - Destroys the current level
--
function public.destroy( )	
end

-- 
-- create() - Creates a new level.
--
function public.create( group )	
   group = group or display.currentStage
   
   
	--
	-- Destroy old level if it exists
	--
	public.destroy()
   
   --
   -- Set up rendering layers for this 'game'
   --
   local layers = layersMaker.get( group )
   
   -- Score HUD
   --
   local tmp = display.newText( layers.interfaces, "Score", left + 20, top + 20, _G.gameFont, 42 )
   tmp.anchorX = 0
   tmp.anchorY = 0
   tmp:setFillColor(unpack( _G.fontColor ) )
   
   local scoreLabel = display.newText( layers.interfaces, 0, left + 20, top + 70, _G.gameFont, 42 )
   scoreLabel.anchorX = 0
   scoreLabel.anchorY = 0
   scoreLabel:setFillColor(unpack( _G.fontColor ) )
   scoreLabel.curScore = 0
   scoreLabel.showScore = 0
   scoreLabel.lastLivesIncrMult = 0
   scoreLabel.lastMinesIncrMult = 0
   function scoreLabel.enterFrame( self )
      if( autoIgnore( "enterFrame", self ) ) then return end
      self.text = string.format( "%9.9d", self.showScore )
      
      local curLivesIncrMult = math.floor( self.showScore/ common.nextLife )
      if( curLivesIncrMult > scoreLabel.lastLivesIncrMult ) then
         common.curLives = common.curLives + (curLivesIncrMult - scoreLabel.lastLivesIncrMult)
      end
      scoreLabel.lastLivesIncrMult = curLivesIncrMult
   
      local curMinesIncrMult = math.floor( self.showScore/ common.nextMine )
      if( curMinesIncrMult > scoreLabel.lastMinesIncrMult ) then
         common.curMines = common.curMines + (curMinesIncrMult - scoreLabel.lastMinesIncrMult)
      end
      scoreLabel.lastMinesIncrMult = curMinesIncrMult
   
   end
   listen( "enterFrame", scoreLabel )
   
   function scoreLabel.onSetScore( self, event )
      if( autoIgnore( "onSetScore", self ) ) then return end
      self.curScore = event.score
   end
   listen( "onSetScore", scoreLabel )
   
   function scoreLabel.onIncrScore( self, event )
      if( autoIgnore( "onIncrScore", self ) ) then return end
      self.curScore = tonumber(self.curScore) + tonumber(event.score)
      transition.cancel( self )
      transition.to( self, { showScore = self.curScore } )
   end
   listen( "onIncrScore", scoreLabel )
   
   
   
   -- Lives HUD
   --   
   display.setDefault( "textureWrapX", "repeat" )
   local livesHUD = display.newRect( layers.interfaces, centerX - 5, top + 40, 32, 32 )
   livesHUD.fill = { type="image", filename = "images/hudplayer.png" }
   livesHUD.anchorX = 1
   display.setDefault( "textureWrapX", "clampToEdge" )
   
   function livesHUD.enterFrame( self )
      if( autoIgnore( "enterFrame", self ) ) then return end
      if( common.curLives <= 0 ) then
         ignore( "enterFrame", self )   
         post( "onGameOver" ) 
         return
      end
      
      self.xScale = common.curLives
      livesHUD.fill.scaleX = 1/livesHUD.xScale
      if( livesHUD.xScale % 2 == 0 ) then
         livesHUD.fill.x = 0.5
      else 
         livesHUD.fill.x = 0
      end
   end
   listen( "enterFrame", livesHUD )      
   --timer.performWithDelay( 1000, function() common.curLives = 5 end )
         
   
   -- Mines HUD
   --   
   display.setDefault( "textureWrapX", "repeat" )
   local minesHUD = display.newRect( layers.interfaces, centerX + 5, top + 40, 32, 32 )
   minesHUD.fill = { type="image", filename = "images/mine.png" }
   minesHUD.anchorX = 0
   display.setDefault( "textureWrapX", "clampToEdge" )
   
   function minesHUD.enterFrame( self )
      if( autoIgnore( "enterFrame", self ) ) then return end
      if( common.curMines <= 0 ) then         
         self.isVisible = false         
         return
      end
      self.isVisible = true
      
      self.xScale = common.curMines
      minesHUD.fill.scaleX = 1/minesHUD.xScale
      if( minesHUD.xScale % 2 == 0 ) then
         minesHUD.fill.x = 0.5
      else 
         minesHUD.fill.x = 0
      end
   end
   listen( "enterFrame", minesHUD )      
   --timer.performWithDelay( 1000, function() common.curMines = 5 end )
   
   function minesHUD.onButtonA( self, event )
      if( autoIgnore( "onButtonA", self ) ) then return end
      if( common.curMines <= 0 ) then return end
      
      if( event.phase == "down" or event.phase == "began" ) then      
         common.curMines = common.curMines - 1      
         post( "purgeEnemies", { getPoints = true } )
      end
      return false
   end
   listen( "onButtonA", minesHUD )      
      
   
   -- Particle HUD & Max Enemies HUD
   --
   if( common.showCounts ) then
      local phud = display.newText( layers.interfaces, "0 / 0 / 0 ", right - 20, bottom - 10, _G.gameFont, 30 )
      phud.anchorX = 1
      phud.anchorY = 1
      
      local maxEnemies = display.newText( layers.interfaces, "1", right - 20, phud.y - phud.contentHeight - 10, _G.gameFont, 30 )
      maxEnemies.anchorX = 1
      maxEnemies.anchorY = 1
      maxEnemies:setFillColor(1,0,0)
      
      function phud.enterFrame( self )
         local particleMgr       = require "scripts.particleMgr"
         local f,u,t = particleMgr.getCounts()      
         self.text = f .. " / " .. u .. " / " ..  t      
         maxEnemies.text = common.maxEnemies
      end
      listen( "enterFrame", phud )
   end
      
end


return public