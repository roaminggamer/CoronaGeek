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
local composer 	      = require "composer" 
local physics 			   = require "physics"
local common 			   = require "scripts.common"

-- Makers (builder)
local layersMaker		   = require "scripts.layersMaker"

local playerMaker 		= require "scripts.playerMaker"
local enemyManager 		= require "scripts.enemyManager"

-- Managers
local cameraMgr 			= require "scripts.cameraMgr"
local particleMgr       = require "scripts.particleMgr"

-- Huds
local huds              = require "scripts.huds"


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
   common.isRunning = false	    
   enemyManager.cancelGenerate()   
   particleMgr.reset()      
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
   
   -- Rese Current Life Count and Mine Count
   common.curLives      = common.startLives
   common.curMines      = common.startMines
   
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
   -- Create a Spawn Grid (four sensor objects, one per quadrant
   --
   local function onGridCollision( self, event )
      if( event.phase == "began" ) then
         self.canSpawn = false
         self:setFillColor(1,0,0)
      elseif( event.phase == "ended" ) then
         self.canSpawn = true
         self.alpha = 0.1
         self:setFillColor(0,1,0)
      end
      return false
   end
   
   
   local totalWidth = common.worldWidth * common.gridSize 
   local totalHeight = common.worldHeight * common.gridSize 
   
   common.spawnGrid = {}
   local function newGrid( x, y )
      local grid = display.newRect( layers.spawnGrid, x, y, totalWidth/4, totalHeight/4 )
      physics.addBody( grid, "static", { filter = common.myCC:getCollisionFilter( "spawnSensor" ) } )   
      grid.isSensor = true      
      grid.alpha = 0.1
      grid:setFillColor(0,1,0)
      
      grid.canSpawn = true
      grid.collision = onGridCollision
      grid:addEventListener( "collision" )
      common.spawnGrid[grid] = grid
   end
   newGrid( centerX - 3 * totalWidth/8, centerY - 3 * totalHeight/8 )
   newGrid( centerX - 1 * totalWidth/8, centerY - 3 * totalHeight/8 )
   newGrid( centerX + 1 * totalWidth/8, centerY - 3 * totalHeight/8 )
   newGrid( centerX + 3 * totalWidth/8, centerY - 3 * totalHeight/8 )
   newGrid( centerX - 3 * totalWidth/8, centerY - 1 * totalHeight/8 )
   newGrid( centerX - 1 * totalWidth/8, centerY - 1 * totalHeight/8 )
   newGrid( centerX + 1 * totalWidth/8, centerY - 1 * totalHeight/8 )
   newGrid( centerX + 3 * totalWidth/8, centerY - 1 * totalHeight/8 )
   newGrid( centerX - 3 * totalWidth/8, centerY + 3 * totalHeight/8 )
   newGrid( centerX - 1 * totalWidth/8, centerY + 3 * totalHeight/8 )
   newGrid( centerX + 1 * totalWidth/8, centerY + 3 * totalHeight/8 )
   newGrid( centerX + 3 * totalWidth/8, centerY + 3 * totalHeight/8 )
   newGrid( centerX - 3 * totalWidth/8, centerY + 1 * totalHeight/8 )
   newGrid( centerX - 1 * totalWidth/8, centerY + 1 * totalHeight/8 )
   newGrid( centerX + 1 * totalWidth/8, centerY + 1 * totalHeight/8 )
   newGrid( centerX + 3 * totalWidth/8, centerY + 1 * totalHeight/8 )
   
   layers.spawnGrid.isVisible = common.showSpawnGrid
    
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
   
   huds.create()
end

--
-- Temporary listener to catch 'onDied' event and restart game.
--
-- We'll handle this better later, but for now, this gives us a 
-- reasonable response to getting hit by enemies.
--
local function onPlayerDied( )   
   -- Wait till the next frame, then restart (lets this frame's work complete)
   timer.performWithDelay( 1, 
      function ()  
         public.destroy() 
      end )   
   timer.performWithDelay( 30, 
      function ()  
         composer.getScene("ifc.playGUI").onBack()         
      end )   
   post( "onSFX", { sfx = "died" } )
end
listen( "onPlayerDied", onPlayerDied )

return public