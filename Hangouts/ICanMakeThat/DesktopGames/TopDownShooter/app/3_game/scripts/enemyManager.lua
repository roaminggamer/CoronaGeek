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
local spriteMaker 		= require 'scripts.spriteMaker'
local redZombieMaker 	= require "scripts.redZombieMaker"
local greenZombieMaker 	= require "scripts.greenZombieMaker"
local bowSkelMaker 		= require "scripts.bowSkelMaker"
local arrowMaker		   = require "scripts.arrowMaker"
local chestMaker		   = require "scripts.chestMaker"
local math2d 			   = require "plugin.math2d"

-- Variables
local enemies = {}


-- Localizations
local mRand             = math.random
local getTimer          = system.getTimer
local pairs             = pairs

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
   enemies = {}
end

-- 
--	 create()
-- 
function public.create( reticle )
   public.destroy()   
end

-- 
--	 count()
-- 
function public.getCount()
   return common.tableCount( enemies )
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
   if( not common.isValid( common.player ) ) then return end

   local maxEnemies = common.enemyDistro[common.currentLevel].maxEnemies  or common.enemyDistro[400]
   --print("Enemy count: ", common.tableCount( enemies ), maxEnemies )   
   if( common.tableCount( enemies )  >= maxEnemies ) then 
      timer.performWithDelay( common.enemyTweenTime, public.generate  )	
      return 
   end 

   local layers   = layersMaker.get()
   local player   = common.player
   local myCC     = common.myCC

   local buffer 	= 50
   local size 		= 40
   local x, y

   local from = math.random(1,4)

   local left 		= player.x - common.fullw/2 + common.enemySpawnOffset
   local right 	= player.x + common.fullw/2 - common.enemySpawnOffset
   local top 		= player.y - common.fullh/2 + common.enemySpawnOffset  
   local bottom 	= player.y + common.fullh/2 - common.enemySpawnOffset

   if( from == 1 ) then
      -- left
      x = left - buffer
      y = math.random( top - buffer, bottom + buffer )

   elseif( from == 2 ) then
      -- right
      x = right + buffer
      y = math.random( top - buffer, bottom + buffer )

   elseif( from == 3 ) then
      -- top
      x = math.random( left - buffer, right + buffer )
      y = top - buffer

   else
      -- bottom
      x = math.random( left - buffer, right + buffer )
      y = bottom + buffer
   end

   -- Create a basic enemy
   local enemy 
   local distro = common.enemyDistro[common.currentLevel] or common.enemyDistro[400]
   local enemySelect = mRand(1,distro.maxValue)
   --print( enemySelect, distro.greenZombie, distro.redZombie, distro.maxEnemies )
   
   if( enemySelect > distro.redZombie ) then
      enemy = bowSkelMaker.create( layers.content, x, y, 1 )
      enemy.myType = "bowSkel" -- Aggressive Enemy Who Shoots at you too
      enemy.chaseMode = "chasing"
      physics.addBody( enemy, "dynamic", { radius = size/2, density = 1, filter = myCC:getCollisionFilter( "skeleton" ) }  )
      enemy.colliderName = "skeleton"
      common.post( "onSFX", { sfx = "archer" } )
   
   elseif( enemySelect > distro.greenZombie ) then
      enemy = redZombieMaker.create( layers.content, x, y, 1 )
      enemy.myType = "redZombie" -- Smart Zombie
      physics.addBody( enemy, "dynamic", { radius = size/2, density = 1, filter = myCC:getCollisionFilter( "zombie" ) }  )
      enemy.colliderName = "zombie"
      common.post( "onSFX", { sfx = "zombie" .. mRand(1,3) } )
  
   else
      enemy = greenZombieMaker.create( layers.content, x, y, 1 )
      enemy.myType = "greenZombie" -- Dumb Zombie
      physics.addBody( enemy, "dynamic", { radius = size/2, density = 1, filter = myCC:getCollisionFilter( "zombie" ) }  )
      enemy.colliderName = "zombie"
      common.post( "onSFX", { sfx = "zombie" .. mRand(1,3) } )
   
   end

   enemy.myAngle = 0
   enemy.myLastAngle = -1

   if( enemy.myType == "bowSkel" ) then
      enemy.speed = math.random( common.enemyMinSpeed, common.enemyMaxSpeed ) * 1.5
   elseif( enemy.myType == "redZombie" ) then
      enemy.speed = math.random( common.enemyMinSpeed, common.enemyMaxSpeed )  * 1.25
   else
      enemy.speed = math.random( common.enemyMinSpeed, common.enemyMaxSpeed ) * 0.75
   end


   enemy.timeScale = enemy.speed / common.enemyBaseSpeed


   -- track the enemy so we can count enemies
   --
   enemies[enemy] = enemy
   if( enemyHUD ) then
      enemyHUD:update()
   end

   -- Basic collision handler
   --
   enemy.collision = function( self, event )
      local other = event.other
      if( other.colliderName ~= "player" ) then return false end

      common.post( "onPlayerDied" )
      return true
   end
   enemy:addEventListener( "collision" )

   --
   -- selfDestruct() - Clean up details about this enemy then destroy it.
   --
   function enemy.selfDestruct( self )
      if( self.ranSelfDestruct ) then return end      
      self.ranSelfDestruct = true      
      transition.cancel( self )
      enemies[self] = nil      
      display.remove(self)
   end

   --
   -- delayedSelfDestruct() - Clean up details about this enemy then destroy it.
   --
   function enemy.delayedSelfDestruct( self, delay  )
      if( self.ranSelfDestruct ) then return end      
      self.ranSelfDestruct = true      
      -- Move the enemy into the dead enemies layer to declutter the visuals
      local layers   = layersMaker.get()
      layers.deadEnemies:insert( self ) 
      transition.cancel( self )      
      physics.removeBody( self )
      enemies[self] = nil
      transition.to( self, { delay = delay, time = 500, alpha = 0, onComplete = display.remove } )
   end

   -- Move To Player - Move to where player is (if player moves do not 'adjust')
   --
   function enemy.moveToPlayer( self ) 
      if( not common.isRunning ) then return end 
      if( not common.isValid( self ) ) then return end
      local vec = diffVec( self, player )
      local angle = vector2Angle( vec ) 
      self.myAngle = angle
      local len = lenVec(vec)
      local speed = self.speed
      local time = 1000 * len / speed 
      --print( angle, len, speed, time )

      self:playAngleAnim( "walking", common.normRot( angle ) )      
      transition.to( self, { x = player.x, y = player.y, time = time , onComplete = self } )
   end

   -- Chase Player - Same as move, but adjust  after short time if player has moved short intervals.
   --
   function enemy.chasePlayer( self ) 
      if( not common.isRunning ) then return end 
      if( not common.isValid( self ) ) then return end      
      if( self.isDestroyed ) then return end

      local vec = diffVec( self, player )
      local angle = vector2Angle( vec ) 
      self.myAngle = angle      
      local len = lenVec(vec)
      local speed = self.speed
      local time = 1000 * len / speed 
      --print( angle, len, speed, time )

      if( time > 600 ) then
         self.timer = self.chasePlayer
         timer.performWithDelay( 500, self )      
      end

      if( self.myAngle == self.myLastAngle ) then
         return
      end
      self.myLastAngle = angle      
      transition.cancel( self )      
      self:playAngleAnim( "walking", common.normRot( angle ) )
      transition.to( self, { x = player.x, y = player.y, time = time , onComplete = self } )
   end

   -- Chase and Shoot at - Same as chase, but shoot on each stop and have longer pauses between stops
   --
   function enemy.chaseAndShootPlayer( self ) 
      if( not common.isRunning ) then return end 
      if( not common.isValid( self ) ) then return end      
      if( self.isDestroyed ) then return end

      local vec = diffVec( self, player )
      local angle = vector2Angle( vec ) 
      self.myAngle = angle      

      if( self.chaseMode == "chasing" ) then
         --print("Chasing")

         self.chaseMode = "pausing"

         local len = lenVec(vec)local speed = self.speed
         local time = 1000 * len / speed 
         --print( angle, len, speed, time )

         if( time > 1100 ) then
            self.timer = self.chaseAndShootPlayer
            timer.performWithDelay( 1000, self )      
         end

         self.myLastAngle = angle      
         self:playAngleAnim( "walking", common.normRot( angle ) )
         transition.to( self, { x = player.x, y = player.y, time = time , onComplete = self } )

      elseif( self.chaseMode == "pausing" ) then
         --print("Pausing")

         transition.cancel( self )         

         self.chaseMode = "shooting"
         self.myLastAngle = angle
         self:playAngleAnim( "paused", common.normRot( angle ) )
         -- FIRING CODE GOES HERE

         self.timer = self.chaseAndShootPlayer
         timer.performWithDelay( 2000, self )      

      else
         --print("Shooting")

         self.chaseMode = "chasing"
         self.myLastAngle = angle
         self:playAngleAnim( "shooting", common.normRot( angle ) )
         
         self:fireArrow()
         common.post( "onSFX", { sfx = "bowfire" } )
         
         self.timer = self.chaseAndShootPlayer
         timer.performWithDelay( 1000, self )      


      end
   end

   -- Use different movement rules for each enemy type
   --
   if( enemy.myType == "bowSkel"  ) then
      enemy.onComplete =  enemy.chaseAndShootPlayer
      enemy:chaseAndShootPlayer()

      -- ==
      --			Fire Arrow
      -- ==
      function enemy.fireArrow( self )

         if( not common.isRunning ) then return end

         -- Create a arrow
         local arrow = arrowMaker.create( layers.content, self.x, self.y, self.myAngle,  1 )
         physics.addBody( arrow, "dynamic", { radius =  10, density = 2, filter = common.myCC:getCollisionFilter( "skeletonarrow" ), isBullet = true }  )
         arrow.colliderName = "skeletonarrow"

         --arrow.strokeWidth = 3

         -- Make the arrow move

         local vec = angle2Vector( self.myAngle, true ) -- no longer rotating player
         vec = scaleVec( vec, common.arrowSpeed )
         arrow:setLinearVelocity( vec.x, vec.y )

         -- Auto-destroy arrow after lifetime expires
         arrow.timer = 
         function( self )
            display.remove( self )
         end
         timer.performWithDelay( common.arrowLifetime, arrow )

         -- Basic collision handler
         --
         arrow.collision = function( self, event )
            local other = event.other
            if( other.colliderName == "player" ) then               
               display.remove( self )            
               common.post("onPlayerDied")
               return true 
            elseif( other.colliderName == "zombie" ) then            
               display.remove( self )            
               
               -- Stop the zombie
               transition.cancel(other)

               -- Don't allow any more collisions with this enemy
               other:removeEventListener("collision")
         
               -- Mark enemy as destroyed (to stop AI)
               --
               other.isDestroyed = true
         
               -- Play an animation and then remove
               other:playAngleAnim( "disintegrate", common.normRot( other.myAngle ) )
               function other.sprite( self, event )
                  --print()
                  if( event.phase == "ended" ) then
                     --self:selfDestruct()
                     self:removeEventListener( "collision" )
                     self:delayedSelfDestruct( 10000 )
                  end
               end
               other:addEventListener( "sprite" )
                  return true
            end
            return false
         end
         arrow:addEventListener( "collision" )      
      end

   elseif( enemy.myType == "redZombie" ) then
      enemy.onComplete =  enemy.chasePlayer
      enemy:chasePlayer()

   else
      enemy.onComplete =  enemy.moveToPlayer
      enemy:moveToPlayer()
   end
   
   
   --
   -- Chest Dropper
   --
   function enemy.dropChest( self )
      if( mRand( 1, 100 ) > common.chanceToDropChest ) then return end
      local chestColors = { "red", "white", "blue" } 
      local chestColor = chestColors[mRand(1,#chestColors)]
      local layers   = layersMaker.get()
      local chest = chestMaker.create( layers.items, self.x, self.y, chestColor )
      physics.addBody( chest, "dynamic", { radius =  10, filter = common.myCC:getCollisionFilter( "chest" ) }  )
      chest.colliderName = "chest"
      
      if( chestColor == "blue" ) then
         chest.myPickup = "mouseTrap"
      elseif( chestColor == "white" ) then
         chest.myPickup = "leafStorm"
      elseif( chestColor == "red" ) then
         chest.myPickup = "spikeTrap"
      end
      
      -- When player collides, remove chest, and increment 'pickup' counter for chest pickup type
      --
      function chest.collision( self, event )
         local other = event.other
         if( other.colliderName ~= "player" ) then return false end
         
         -- Don't allow any more collisions with this enemy
         self:removeEventListener("collision")

         if( self.myPickup == "mouseTrap" ) then
            common.trapCounts.mouseTrap = common.trapCounts.mouseTrap + 1
            common.post( "onSFX", { sfx = "coin1" } )
         elseif( self.myPickup == "leafStorm" ) then
            common.trapCounts.leafStorm = common.trapCounts.leafStorm + 1
            common.post( "onSFX", { sfx = "coin2" } )
         elseif( self.myPickup == "spikeTrap" ) then
            common.trapCounts.spikeTrap = common.trapCounts.spikeTrap + 1
            common.post( "onSFX", { sfx = "coin3" } )
         end
         
         display.remove( self )

         return true
      end
      chest:addEventListener( "collision" )
   end



   -- Make another enemy in a little while
   --	
   timer.performWithDelay( common.enemyTweenTime, public.generate  )	
end



return public