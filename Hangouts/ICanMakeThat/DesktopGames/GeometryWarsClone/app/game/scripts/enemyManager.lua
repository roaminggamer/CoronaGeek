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
--	 destroy()
-- 
function public.destroy()
   if( public.lastTimer ) then
      timer.cancel( public.lastTimer ) 
      public.lastTimer = nil
   end
   common.enemies = {}
end

-- 
--	 create()
-- 
function public.create( )
   public.destroy()   
end

-- 
--	 count()
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
--	 getNearest() - Return a random enemy
-- 
function public.getNearest( obj )
   if( not common.isRunning ) then return nil end
   
   local dist = math.huge
   local nearest   
   
   for k,v in pairs( common.enemies ) do
      local vec = diffVec( v, obj )
      local len2 = len2Vec( vec )
      if( not v.isDestroyed and len2 < dist ) then 
         dist = len2
         nearest = v
      end
   end   
   return nearest
end


-- 
--	 cancelGenerate()
-- 
function public.cancelGenerate( )
   if( public.lastTimer ) then 
      timer.cancel( public.lastTimer )
      public.lastTimer = nil
   end
end


-- 
--	 generate()
-- 
function public.generate( )
   if( not common.isRunning ) then return end
   if( not isValid( common.player ) ) then return end
   
   if( public.lastTimer ) then 
      timer.cancel( public.lastTimer )
      public.lastTimer = nil
   end

   local maxEnemies = common.maxEnemies
   --print("Enemy count: ", table.count( common.enemies ), maxEnemies )   
   if( table.count( common.enemies )  >= maxEnemies ) then 
      public.lastTimer = timer.performWithDelay( common.enemyTweenTime, public.generate  )	
      return 
   end 
   
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
   
   
   local enemy

   if( math.random(1,100) > 50 ) then
      enemy = pinwheel.create( spawnX, spawnY )
   else
      enemy = diamond.create( spawnX, spawnY )
   end
   
   enemy.collision = common.enemyCollision
   enemy:addEventListener( "collision" )
   
   enemy.selfDestruct = common.enemySelfDestruct
   
   enemy.purgeEnemies = enemy.selfDestruct
   listen( "purgeEnemies", enemy )
      
   common.enemies[enemy] = enemy
   
   
   enemy:think()      

   public.lastTimer = timer.performWithDelay( common.enemyTweenTime, public.generate )	
end



return public