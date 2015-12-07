-- =============================================================
-- Copyright Roaming Gamer, LLC. 2009-2015 
-- =============================================================
-- This content produced for Corona Geek Hangouts audience.
-- You may use any and all contents in this example to make a game or app.
-- =============================================================
local curFrame = 0
listen( "enterFrame", function() curFrame = curFrame + 1 end )

local public = {}

----------------------------------------------------------------------
--								REQUIRES							--
----------------------------------------------------------------------
local physics 			   = require "physics"
local common 			   = require "scripts.common"

-- Makers (builder)
local layersMaker		   = require "scripts.layersMaker"
local debugMaker 		   = require "scripts.debugMaker"

local groundMaker 		= require "scripts.groundMaker"
local reticleMaker 		= require "scripts.reticleMaker"
local playerMaker 		= require "scripts.playerMaker"
local enemyManager 		= require "scripts.enemyManager"

local chestMaker		   = require "scripts.chestMaker"
local laserCannonMaker	= require "scripts.laserCannonMaker"
local leafStorm			= require "scripts.leafStorm"
local mouseTrapMaker	   = require "scripts.mouseTrapMaker"
local trapMaker			= require "scripts.trapMaker"
local needleTrapMaker	= require "scripts.needleTrapMaker"
local gemMaker	         = require "scripts.gemMaker"

-- Managers
local cameraMgr 			= require "scripts.cameraMgr"

----------------------------------------------------------------------
--								DECLARATIONS						--
----------------------------------------------------------------------


-- Variables


-- Forward Declarations

-- Localizations
local mRand             = math.random
local getTimer          = system.getTimer
local pairs             = pairs

----------------------------------------------------------------------
--								DEFINITIONS							--
----------------------------------------------------------------------

-- 
-- destroy() - Destroys the current level
--
function public.destroy( )	
	if( common.isRunning ) then
		--physics.pause() -- safer than stopping which might cause errors in future calls that 
	   		            -- come in enterFrame, collisio, or timer listeners
	end
   
   common.isRunning = false	 
   
	
   enemyManager.destroy()
   cameraMgr.detach()
   playerMaker.destroy()
   reticleMaker.destroy()
   layersMaker.destroy()	  
end


-- 
-- create() - Creates a new level.
--
function public.create( group )	
	--
	-- Destroy old level if it exists
	--
	public.destroy()
   
   -- Start Physics
   --
   --physics.start() 
   
   --
   -- Set up rendering layers for this 'game'
   --
   local layers = layersMaker.create( group )
   
	--
	-- Draw Background
	--
   local lostGarden		   = require "scripts.lostGarden"
   lostGarden.selectGroup( "B1" ) -- B0,1; D0,3; G0,3; P0,1; R0; S0,5
	groundMaker.create( )

   --
	-- Draw World Content
	-- 
	local reticle 	= reticleMaker.create()
	local player 	= playerMaker.create( reticle )
   enemyManager.create()

   debugMaker.showPlayerMovementLimit()

   --
   -- Draw HUDS
   -- 
   public.drawHUDs( layers )

   --
   -- Place Gems 
   --
   public.placeGems()

	-- 
	-- Start The Camera
	-- 
	cameraMgr.attach( player )
   --cameraMgr.detach()
	 
	common.isRunning = true
   
   enemyManager.generate()
end


-- 
-- placeGems() - Basic HUDs for game
--
function  public.placeGems()
   local layers = layersMaker.get()
   for i = 1, #common.gemColors do
      local x = (mRand(1,2) == 1) and mRand(common.leftLimit+ 40, centerX - 100) or mRand(centerX + 100, common.rightLimit - 40 )
      local y = (mRand(1,2) == 1) and mRand(common.upLimit + 40, centerY - 100) or mRand(centerY + 100, common.downLimit - 40 )
      gemMaker.create( layers.content, x, y, common.gemColors[i] )
   end
end


-- 
-- drawHUDS() - Basic HUDs for game
--
function public.drawHUDs( layers )
   -- Level HUD
   local levelHUDShadow = display.newText( layers.interfaces, "Level " .. common.currentLevel, common.centerX + 4, common.top + 44, gameFont, 60 )   
   levelHUDShadow:setFillColor(0)
   
   local levelHUD = display.newText( layers.interfaces, "Level " .. common.currentLevel, common.centerX, common.top + 40, gameFont, 60 )
   levelHUD.shadow = levelHUDShadow
   function levelHUD.enterFrame( self ) 
      self.shadow.text = "Level " .. common.currentLevel 
      self.text = "Level " .. common.currentLevel 
   end
   common.listen( "enterFrame",  levelHUD )
   

   --
   -- Gem HUDs
   --
   for i = 1, #common.gemColors do
      local x = common.centerX - 85 + (i - 1 ) * 55
      local tmp = display.newRoundedRect( layers.interfaces, x + 3, common.top + 113, 40, 40, 12 )
      tmp:setFillColor(0,0,0,0)
      tmp:setStrokeColor(0)
      tmp.strokeWidth = 3
      
      local gemHUD = display.newRoundedRect( layers.interfaces, x, common.top + 110, 40, 40, 12 )
      gemHUD:setFillColor(0,0,0,0)
      gemHUD:setStrokeColor(0.5,0.5,0.5)
      gemHUD.strokeWidth = 3
      gemHUD.myColor = common.gemColors[i]
      local tmp = display.newImageRect( layers.interfaces, "images/reiners/gem_" .. gemHUD.myColor .. ".png", 17, 23 )
      tmp:setFillColor(0)
      tmp.x = gemHUD.x + 4 + 2
      tmp.y = gemHUD.y + 4 + 2
      local tmp = display.newImageRect( layers.interfaces, "images/reiners/gem_" .. gemHUD.myColor .. ".png", 17, 23 )
      tmp.x = gemHUD.x + 2
      tmp.y = gemHUD.y + 2
      function gemHUD.enterFrame( self )
         if( not common.isRunning ) then return end
         if( not common.isValid( self ) ) then
            common.ignore( "enterFrame", self ) 
            return            
         end
         if( common.hasGem[self.myColor] ) then
            self:setStrokeColor(0.3,1,0.3)
         else
            self:setStrokeColor(0.5,0.5,0.5)
            --common.ignore( "enterFrame", self ) 
         end
      end
      common.listen("enterFrame", gemHUD)
   end
         
   
   --
   -- Trap Drop Counters/HUDs
   --
   -- Mouse Trap Counter/Selector
   local x = common.centerX - 100
   local tmp = display.newRoundedRect( layers.interfaces, x + 4, common.bottom - 86, 80, 80, 12 )
   tmp:setFillColor(0,0,0,0)
   tmp:setStrokeColor(0)
   tmp.strokeWidth = 5
   
   local mouseTrapHUD = display.newRoundedRect( layers.interfaces, x, common.bottom - 90, 80, 80, 12 )
   mouseTrapHUD:setFillColor(0,0,0,0)
   mouseTrapHUD:setStrokeColor(1)
   mouseTrapHUD.strokeWidth = 5
   mouseTrapHUD.labelShadow = display.newText( layers.interfaces, 0, x + 4, mouseTrapHUD.y + 64, gameFont, 30 )   
   mouseTrapHUD.labelShadow:setFillColor(0)
   mouseTrapHUD.label = display.newText( layers.interfaces, 0, x, mouseTrapHUD.y + 60, gameFont, 30 ) 
   local tmp = display.newImageRect( layers.interfaces, common.mouseTrapSheet, 1, 64, 64 )
   tmp:setFillColor(0)
   tmp.x = mouseTrapHUD.x + 4
   tmp.y = mouseTrapHUD.y + 4 - 6
   local tmp = display.newImageRect( layers.interfaces, common.mouseTrapSheet, 1, 64, 64 )
   tmp.x = mouseTrapHUD.x
   tmp.y = mouseTrapHUD.y - 6
   function mouseTrapHUD.enterFrame( self )
      if( not common.isRunning ) then return end
      if( not common.isValid( self ) ) then
         common.ignore( "enterFrame", self ) 
         return
      end
      self.labelShadow.text = common.trapCounts.mouseTrap
      self.label.text = common.trapCounts.mouseTrap
   end
   common.listen("enterFrame", mouseTrapHUD)
      
   
   -- Spike Trap Counter/Selector
   local x = common.centerX 
   local tmp = display.newRoundedRect( layers.interfaces, x + 4, common.bottom - 86, 80, 80, 12 )
   tmp:setFillColor(0,0,0,0)
   tmp:setStrokeColor(0)
   tmp.strokeWidth = 5
   
   local spikeTrapHUD = display.newRoundedRect( layers.interfaces, x, common.bottom - 90, 80, 80, 12 )
   spikeTrapHUD:setFillColor(0,0,0,0)
   spikeTrapHUD:setStrokeColor(1)
   spikeTrapHUD.strokeWidth = 5
   spikeTrapHUD.labelShadow = display.newText( layers.interfaces, 0, x + 4, spikeTrapHUD.y + 64, gameFont, 30 )   
   spikeTrapHUD.labelShadow:setFillColor(0)
   spikeTrapHUD.label = display.newText( layers.interfaces, 0, x, spikeTrapHUD.y + 60, gameFont, 30 )   
   local tmp = display.newImageRect( layers.interfaces, common.needleTrapSheet, 8, 64, 64 )
   tmp:scale(1.25, 1.25)
   tmp:setFillColor(0)
   tmp.x = spikeTrapHUD.x + 4
   tmp.y = spikeTrapHUD.y + 4  + 10
   local tmp = display.newImageRect( layers.interfaces, common.needleTrapSheet, 8, 64, 64 )
   tmp:scale(1.25, 1.25)
   tmp.x = spikeTrapHUD.x
   tmp.y = spikeTrapHUD.y + 10
   function spikeTrapHUD.enterFrame( self )
      if( not common.isRunning ) then return end
      if( not common.isValid( self ) ) then
         common.ignore( "enterFrame", self ) 
         return
      end
      self.labelShadow.text = common.trapCounts.spikeTrap
      self.label.text = common.trapCounts.spikeTrap
   end
   common.listen("enterFrame", spikeTrapHUD)
   

   -- Leaf Storm Counter/Selector
   local x = common.centerX + 100
   local tmp = display.newRoundedRect( layers.interfaces, x + 4, common.bottom - 86, 80, 80, 12 )
   tmp:setFillColor(0,0,0,0)
   tmp:setStrokeColor(0)
   tmp.strokeWidth = 5
   
   local leafStormHUD = display.newRoundedRect( layers.interfaces, x, common.bottom - 90, 80, 80, 12 )
   leafStormHUD:setFillColor(0,0,0,0)
   leafStormHUD:setStrokeColor(1)
   leafStormHUD.strokeWidth = 5
   leafStormHUD.labelShadow = display.newText( layers.interfaces, 0, x + 4, leafStormHUD.y + 64, gameFont, 30 )   
   leafStormHUD.labelShadow:setFillColor(0)
   leafStormHUD.label = display.newText( layers.interfaces, 0, x, leafStormHUD.y + 60, gameFont, 30 )   
   local tmp = display.newImageRect( layers.interfaces, common.leafStormSheet, 30, 64, 64 )
   tmp:setFillColor(0)
   tmp.x = leafStormHUD.x + 4
   tmp.y = leafStormHUD.y + 4
   local tmp = display.newImageRect( layers.interfaces, common.leafStormSheet, 30, 64, 64 )
   tmp.x = leafStormHUD.x
   tmp.y = leafStormHUD.y 
   function leafStormHUD.enterFrame( self )
      if( not common.isRunning ) then return end
      if( not common.isValid( self ) ) then
         common.ignore( "enterFrame", self ) 
         return
      end
      self.labelShadow.text = common.trapCounts.leafStorm
      self.label.text = common.trapCounts.leafStorm
   end
   common.listen("enterFrame", leafStormHUD)
      
   
   -- Trap Selection Logic
   --
   local trapHUDs = {}
   
   mouseTrapHUD.myType = "mouseTrap"
   trapHUDs[1] = mouseTrapHUD
   
   spikeTrapHUD.myType = "spikeTrap"
   trapHUDs[2] = spikeTrapHUD
   
   leafStormHUD.myType = "leafStorm"
   trapHUDs[3] = leafStormHUD
   
   common.selectedTrap = 3
   function trapHUDs.key( self, event )
      if( not common.isRunning ) then return end
      if( not common.isValid( layers ) ) then
         common.ignore( "key", self ) 
         return false
      end
      if( event.keyName ==  "tab" and event.phase == "up" ) then
         self:selectNext()
      end
      
      return false
   end
   common.listen("key", trapHUDs)
         
   function trapHUDs.selectNext( self )
      for i = 1, #self do
         self[i]:setStrokeColor( 0.5, 0.5, 0.5 )
      end
      common.selectedTrap = common.selectedTrap + 1
      if( common.selectedTrap > #self ) then
         common.selectedTrap = 1
      end
      self[common.selectedTrap]:setStrokeColor( 0.3, 1, 0.3 )
      common.selectedTrapType = self[common.selectedTrap].myType
   end
   trapHUDs:selectNext()
end



--
-- Temporary listener to catch 'onDied' event and restart game.
--
-- We'll handle this better later, but for now, this gives us a 
-- reasonable response to getting hit by enemies.
--
local function onPlayerDied( )
   
   -- Insta death.  Start over w/ no traps
   common.currentLevel = common.startLevel   
   common.trapCounts.mouseTrap = 0
   common.trapCounts.leafStorm = 0
   common.trapCounts.spikeTrap = 0
   
   common.hasGem.red = false
   common.hasGem.blue = false
   common.hasGem.white = false
   common.hasGem.yellow = false
   
   -- Wait till the next frame, then restart (let's this frame's work complete)
   timer.performWithDelay( 1, function ()  public.create() end )
   --print("BOB")
end
listen( "onPlayerDied", onPlayerDied )


--
-- Catch 'onDied' event and restart game.
--
local function onLevelComplete( )
   common.hasGem.red = false
   common.hasGem.blue = false
   common.hasGem.white = false
   common.hasGem.yellow = false
   -- Wait till the next frame, then restart (let's this frame's work complete)
   --timer.performWithDelay( 1, function ()  public.create() end )
   public.placeGems()   
end
listen( "onLevelComplete", onLevelComplete )


return public