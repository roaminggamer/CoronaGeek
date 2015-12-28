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

-- Variables
local enemies = {}

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

local explodeVectors = {}
for i = 1, 360 do
   explodeVectors[i] = angle2Vector( i-1, true )
end

-- 
--	 destroy()
-- 
function public.destroy()
   if( public.lastTimer ) then
      timer.cancel( public.lastTimer ) 
      public.lastTimer = nil
   end
   enemies = {}
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
   return table.count( enemies )
end

-- 
--	 getRandom() - Return a random enemy
-- 
function public.getRandom()
   if( not common.isRunning ) then return nil end
   local list = {}
   for k,v in pairs( enemies ) do
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
   
   for k,v in pairs( enemies ) do
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
--	 generate()
-- 
function public.generate( )
   if( not common.isRunning ) then return end
   if( not isValid( common.player ) ) then return end

   local maxEnemies = 60 -- common.enemyDistro[common.currentLevel].maxEnemies  or common.enemyDistro[400]
   --print("Enemy count: ", table.count( enemies ), maxEnemies )   
   if( table.count( enemies )  >= maxEnemies ) then 
      public.lastTimer = timer.performWithDelay( common.enemyTweenTime, public.generate  )	
      return 
   end 

   local layers = layersMaker.get()
         
   --
   -- New Enemy
   --
   local angle = mRand( 0, 359 )
   local vec = angle2Vector( angle, true )
   vec = scaleVec( vec, mRand( 400, 600 ) )
   
   local enemy = display.newImageRect( layers.content, "images/arrow.png", 40, 40 )
   enemy.x = common.player.x + vec.x
   enemy.y = common.player.y + vec.y
   enemy:setFillColor( 0.4, 0, 0 )   
   physics.addBody( enemy, "dynamic", { radius = 20, filter = common.myCC:getCollisionFilter( "enemy" ) } )
   
   enemy.speed = 50

   -- track the enemy so we can count enemies
   --
   enemies[enemy] = enemy
   
   -- Basic collision handler
   --
   enemy.collision = function( self, event )
      local other = event.other
      local phase = event.phase
      if( phase ~= "began" ) then return end
      
      if( other.colliderName == "player" ) then 
         post( "onPlayerDied" )
         return true
      end
      if( other.colliderName == "playerbullet" ) then 
         self:selfDestruct()
         other:selfDestruct()
         return false 
      end

      
      return false
   end
   enemy:addEventListener( "collision" )

   --
   -- selfDestruct() - Clean up details about this enemy then destroy it.
   --
   function enemy.selfDestruct( self )
      if( self.ranSelfDestruct ) then return end      
      
      -- explosion
      for i = 1, 359, 4 do
         local particle = particleMgr:get()
         particle.x = self.x
         particle.y = self.y
         particle.xScale = 1
         particle.yScale = 8
         particle:setFillColor(1,1,1)
         self.parent:insert(particle)
         
         function particle.onComplete( self ) 
            self:release()
         end         
         
         local vec = explodeVectors[i]
         vec = scaleVec( vec, mRand( 50, 100) )         
         particle.rotation = i
         
         transition.to( particle, 
                        { 
                           x = particle.x + vec.x, y = particle.y + vec.y, 
                           time = mRand(200,500),
                           alpha = 0.5,
                           onComplete = particle,
                           transition = easing.outCirc 
                        } )
      end
      
      
      self.ranSelfDestruct = true      
      transition.cancel( self )
      enemies[self] = nil      
      display.remove(self)
   end

   -- Chase Player - Same as move, but adjust  after short time if player has moved short intervals.
   --
   function enemy.chasePlayer( self ) 
      if( not common.isRunning ) then return end 
      if( not isValid( self ) ) then return end      
      if( self.isDestroyed ) then return end

      local vec = diffVec( self, common.player )
      
      vec = normVec( vec )
      
      vec = scaleVec( vec, self.speed )
      
      self:setLinearVelocity( vec.x, vec.y )
      
      self.timer = self.chasePlayer
      timer.performWithDelay( 100, self )      
   end

   enemy.onComplete =  enemy.chasePlayer
   enemy:chasePlayer()
      

   -- Make another enemy in a little while
   --	
   timer.performWithDelay( common.enemyTweenTime, public.generate  )	
end



return public