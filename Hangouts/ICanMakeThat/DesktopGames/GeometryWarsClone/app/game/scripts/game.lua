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


-- Forward Declarations

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
   particleMgr.reset()
   
   common.isRunning = false	 
   cameraMgr.detach()
   playerMaker.destroy()
   layersMaker.destroy()	  
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
   local layers = layersMaker.create( group )
   
   --
	-- Create Simple Background
	-- 
   local startX   = centerX - common.gridSize * common.worldWidth /2 + common.gridSize/2
   local startY   = centerY - common.gridSize * common.worldHeight /2 + common.gridSize/2
   local col      = 1
   local row      = 1
   local curX     = startX
   local curY     = startY
   local count = 1
   for row = 1, common.worldHeight do
      for col = 1, common.worldWidth do
         if( count % 2 == 1 ) then            
            local tile = display.newRect( layers.underlay, curX, curY, common.gridSize, common.gridSize )
            tile:setFillColor(0,0,0,0)
            tile:setStrokeColor( 0, 1, 1, 0.2 )
            tile.strokeWidth = 2
         end
         count = count + 1
         curX = curX + common.gridSize
      end      
      curX = startX
      curY = curY + common.gridSize
   end
   local width = common.rightBorder - common.leftBorder
   local height = common.downBorder - common.upBorder
   local viewBorder = display.newRect( layers.underlay, centerX, centerY, width, height )
   viewBorder:setFillColor(0,0,0,0)
   viewBorder:setStrokeColor( 0, 1, 1)
   viewBorder.strokeWidth = 3
   
   --
	-- Create Player
	-- 
	local player 	= playerMaker.create( reticle )

	-- 
	-- Start The Camera
	-- 
	cameraMgr.attach( player )
   --cameraMgr.detach()
	 
	common.isRunning = true
   
   --
   -- Init enemy manager and start it
   --
   enemyManager.create()
   enemyManager.generate()
   
   
   -- Particle HUD
   local phud = display.newText( layers.interfaces, "0 / 0 / 0 ", left + 20, top + 40, native.systemFont, 30 )
   phud.anchorX = 0
   function phud.enterFrame( self )
      local particleMgr       = require "scripts.particleMgr"
      local f,u,t = particleMgr.getCounts()
      
      self.text = f .. " / " .. u .. " / " ..  t
      
      
   end
   listen( "enterFrame", phud )
   
   
end

--
-- Temporary listener to catch 'onDied' event and restart game.
--
-- We'll handle this better later, but for now, this gives us a 
-- reasonable response to getting hit by enemies.
--
local function onPlayerDied( )   
   -- Wait till the next frame, then restart (lets this frame's work complete)
   timer.performWithDelay( 1, function ()  public.create() end )
   
   post( "onSFX", { sfx = "died" } )
end
listen( "onPlayerDied", onPlayerDied )

return public