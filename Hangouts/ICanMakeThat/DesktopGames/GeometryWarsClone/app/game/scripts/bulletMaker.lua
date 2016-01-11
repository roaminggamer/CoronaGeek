-- =============================================================
-- Copyright Roaming Gamer, LLC. 2009-2015 
-- =============================================================
-- This content produced for Corona Geek Hangouts audience.
-- You may use any and all contents in this example to make a game or app.
-- =============================================================
local bulletMaker = {}

local physics 			   = require "physics"
local common 			   = require "scripts.common"
local layersMaker		   = require "scripts.layersMaker"
local particleMgr       = require "scripts.particleMgr"

local math2d 			   = require "plugin.math2d"

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
local mAbs              = math.abs



-- 
--	 destroy()
-- 
function bulletMaker.destroy()
   bulletMaker.bullets = {}   
end

-- 
--	 create()
-- 
function bulletMaker.create( self )
   
   bulletMaker.destroy()
   
   local isPlayer = (self == common.player)   
   local shooter  = self
   
   local colliderName = isPlayer and "playerbullet" or "enemybullet"
   
   --
   -- Limit firing to 'fire period' for this shooter
   --
   shooter.lastFireTime = shooter.lastFireTime or -1   
   local curTime = getTimer()   
   if( ( curTime - shooter.lastFireTime ) < shooter.firePeriod ) then return end   
   shooter.lastFireTime = curTime
   
   -- Fire 'bulletsPerShot'
   --   
   local first = true
   local spreadMult  = 0
   local spreadCount = 0
   local start = 1
   if( shooter.noFirstBullet == true ) then 
      start = 2
      spreadCount = 1
   end   
   for i = start, shooter.bulletsPerShot do
      -- 
      -- Fire Angle Calc (for multiple bullets per shot)
      --
      local fireAngle = shooter.fireAngle
      if( first ) then
         first = false
         spreadMult = 0
      else
         if( (i - 1) % 2 == 1) then
            spreadCount = spreadCount + 1
            spreadMult = 1 * spreadCount
         else
            spreadMult = -1 * spreadCount
         end
      end
      fireAngle = fireAngle + spreadMult * (shooter.bulletSpread + mRand( -1, 1 ) )
            
      -- 
      -- Create a bullet
      --
      --local bullet = display.newImageRect( shooter.parent, "images/arrow.png", 1, 1 )
      local bullet = particleMgr.get()
      shooter.parent:insert( bullet )
      bullet.x = shooter.x 
      bullet.y = shooter.y
      if( common.particleStyle == 1 ) then
         bullet.xScale = shooter.bulletWidth
         bullet.yScale = shooter.bulletHeight
      else
         bullet.xScale = shooter.bulletWidth/20
         bullet.yScale = shooter.bulletHeight/20
      end
      
      bullet:toBack()
      bullet:setFillColor(unpack(shooter.bulletColor))
      bullet.rotation = fireAngle      
      physics.addBody( bullet, "dynamic", { radius = shooter.bulletHeight/2, filter = common.myCC:getCollisionFilter( colliderName ), isBullet = true, isSensor = true }  )
      bullet.hasBody = true
      bullet.colliderName = colliderName
      
      local vec = angle2Vector( bullet.rotation, true )
      vec = scaleVec( vec, shooter.bulletSpeed + mRand( -shooter.bulletSpeedVariance, shooter.bulletSpeedVariance ) )
      bullet:setLinearVelocity( vec.x, vec.y )   
      
      bulletMaker.bullets[bullet] = bullet
      
      function bullet.selfDestruct( self )
         if( self and self.inUse ) then
            self:release()
         end
      end
      
      bullet.lastTimer = timer.performWithDelay( 1000, function() bullet:release() end )
      
   end
end


return bulletMaker