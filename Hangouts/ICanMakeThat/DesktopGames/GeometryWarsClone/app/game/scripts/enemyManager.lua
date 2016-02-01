-- =============================================================
-- Copyright Roaming Gamer, LLC. 2009-2015 
-- =============================================================
-- This content produced for Corona Geek Hangouts audience.
-- You may use any and all contents in this example to make a game or app.
-- =============================================================
local public = {}

local physics 			   = require "physics"
local common 			   = require "scripts.common"
local layersMaker		   = require "scripts.layersMaker"
local particleMgr       = require "scripts.particleMgr"
local math2d 			   = require "plugin.math2d"

local pinwheel          = require "scripts.enemies.pinwheel"
local diamond           = require "scripts.enemies.diamond"

-- Variables

-- Localizations
local mRand             = math.random
local getTimer          = system.getTimer
local pairs             = pairs
local isValid           = display.isValid

local addVec			   = math2d.add
local subVec			   = math2d.sub
local diffVec			   = math2d.diff
local lenVec			   = math2d.length
local len2Vec			   = math2d.length2
local normVec			   = math2d.normalize
local vector2Angle		= math2d.vector2Angle
local angle2Vector		= math2d.angle2Vector
local scaleVec			   = math2d.scale


-- 
--	 destroy() - Stop spawning and clear 'enemies' list.
-- 
function public.destroy()
   if( public.lastTimer ) then
      timer.cancel( public.lastTimer ) 
      public.lastTimer = nil
   end
   common.enemies = {}
end

-- 
--	 create() -- Cleanup just in case; All other work done by generate() below.
-- 
function public.create( )
   public.destroy()   
end

-- 
--	 count() -- Return total number of enemies on screen.
-- 
function public.getCount()
   return table.count( common.enemies )
end

-- 
--	 getRandom() - Return a random enemy
-- 
function public.getRandom()
   if( not common.isRunning ) then return nil end
   local list = {}
   for k,v in pairs( common.enemies ) do
      list[#list+1] = v
   end
   if( #list == 0 ) then return nil end
   return list[mRand(1,#list)]   
end


-- 
--	 cancelGenerate()  -- Stop the generator.
-- 
function public.cancelGenerate( )
   if( public.lastTimer ) then 
      timer.cancel( public.lastTimer )
      public.lastTimer = nil
   end
end


-- 
--	 generate() -- Generate one new enemiy every N milliseconds, up to  the
--                maximum number of enemies as determined by the current difficulty.
-- 
function public.generate( )
   if( not common.isRunning ) then return end
   if( not isValid( common.player ) ) then return end
   
   -- Cancel any 'dangling' timer (just in case)
   if( public.lastTimer ) then 
      timer.cancel( public.lastTimer )
      public.lastTimer = nil
   end
   
   -- Calculate current difficulty
   local dt = getTimer() - common.difficultyStart   
   common.maxEnemies = round(dt/common.msPerLevel)
   
   -- How many enemies should we have on the screen?
   if( common.maxEnemies < 1 ) then 
      common.maxEnemies = 1
   elseif( common.maxEnemies > common.maxEnemiesCap ) then
      common.maxEnemies = common.maxEnemiesCap
   end
   --print(dt, common.maxEnemies, getTimer(), common.difficultyStart )

   local maxEnemies = common.maxEnemies
   --print("Enemy count: ", table.count( common.enemies ), maxEnemies )   
   
   -- If we are at 'maxEnemies' do not spawn, just come back later and check again.
   if( table.count( common.enemies )  >= maxEnemies ) then 
      public.lastTimer = timer.performWithDelay( common.enemyTweenTime, public.generate  )	
      return 
   end 
   
   -- Spawn an enemy by selecting a 'safe to spawn' location (via spawn grids) and then randomly generate
   -- an enemy somewhere in the bounds of that grid position.
   local spawnGrids = {}
   for k,v in pairs(common.spawnGrid) do
      if( v.canSpawn == true ) then
         v:setFillColor(0,1,0)
         spawnGrids[#spawnGrids+1] = v
      end
   end
   if( #spawnGrids == 0 ) then return end
   local spawnGrid = spawnGrids[math.random(1,#spawnGrids)]
   
   local spawnX = spawnGrid.x - spawnGrid.contentWidth/2 + math.random(common.enemySize, spawnGrid.contentWidth-common.enemySize)
   local spawnY = spawnGrid.y - spawnGrid.contentHeight/2 + math.random(common.enemySize, spawnGrid.contentHeight-common.enemySize)
   spawnGrid:setFillColor(1,1,0)
   
   -- Now that we know where to put the enemy, let's choose the type randomly and create it.
   local enemy
   if( math.random(1,100) > 50 ) then
      enemy = pinwheel.create( spawnX, spawnY )
   else
      enemy = diamond.create( spawnX, spawnY )
   end
   
   -- Attach collision, selfDestruct, and purgeEnemies methods/listeners to this enemy
   enemy.collision = public.enemyCollision
   enemy:addEventListener( "collision" )   
   enemy.selfDestruct = public.enemySelfDestruct   
   enemy.purgeEnemies = enemy.selfDestruct
   listen( "purgeEnemies", enemy )
      
   -- Store a reference to the enemy in our 'enemies' table
   common.enemies[enemy] = enemy
   
   -- Tell the enemy to start doing it's evil work....
   enemy:think()      

   -- Come back in a bit and try to spawn a new enemy.
   public.lastTimer = timer.performWithDelay( common.enemyTweenTime, public.generate )	
end


-- Basic collision handler
--
public.enemyCollision = function( self, event )
   if( self.isDestroyed ) then return end
   local other       = event.other
   local phase       = event.phase
   
   if( phase ~= "began" ) then return end
   
   -- If 'other' is a player, purge all enemies, move the player back to the center of the screen, and reset the diffuculty level
   -- 
   if( other.colliderName == "player" ) then       
      common.curLives = common.curLives - 1
      post("onResetDifficulty")
      post("purgeEnemies")
      timer.performWithDelay( 1,
         function()
            other.x = centerX
            other.y = centerY
         end )
      self:selfDestruct()
      return true
   end
   
   -- If 'other' is a bullet, destroy the enemy and give the player some points.
   if( other.colliderName == "playerbullet" ) then 
      post( "onIncrScore", { score = self.value  } )
      self.isDestroyed = true
      self:selfDestruct()
      return false 
   end
   return false
end

--
-- enemySelfDestruct() - Clean up details about this enemy then destroy it.
--
function public.enemySelfDestruct( self, event )
   if( self.ranSelfDestruct ) then return end     
   if( not common.isRunning ) then return end
   
   event = event or {}
   local getPoints = event.getPoints
   
   local explosion = require "scripts.explosion"         
   explosion.create( self.parent, self.x, self.y, 1 )   
   
   -- If getPoints is set to try, give the player some points for destroying this enemy.
   -- 
   if( getPoints ) then
      post( "onIncrScore", { score = self.value  } )
   end
   
   self.ranSelfDestruct = true      
   transition.cancel( self )
   common.enemies[self] = nil      
   display.remove(self)
end



return public