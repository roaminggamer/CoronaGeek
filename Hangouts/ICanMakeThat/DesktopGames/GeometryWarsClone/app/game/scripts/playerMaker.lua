-- =============================================================
-- Copyright Roaming Gamer, LLC. 2009-2015 
-- =============================================================
-- This content produced for Corona Geek Hangouts audience.
-- You may use any and all contents in this example to make a game or app.
-- =============================================================
local playerMaker = {}

local physics 			   = require "physics"
local common 			   = require "scripts.common"
local layersMaker		   = require "scripts.layersMaker"
local bulletMaker		   = require "scripts.bulletMaker"
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
function playerMaker.destroy()
   if( isValid( common.player ) ) then
      ignore( "enterFrame", common.player )
      ignore( "mouse", common.player )
      ignore( "key", common.player )
   end
   common.player = nil
end

-- 
--	 create()
-- 
function playerMaker.create()
   
   -- Get the current layers
   local layers = layersMaker.get()

   -- The Player
   --
   local player = display.newImageRect( layers.content, "images/player.png", common.playerSize, common.playerSize )
   player.x = centerX
   player.y = centerY
   physics.addBody( player, "dynamic", { radius = common.playerSize/2 - 3, filter = common.myCC:getCollisionFilter( "player" ) }  )

   -- Various player flags and values used in animations, walking, firing, etc.
   player.colliderName        = "player"
   player.fireAngle           = 0
   player.mx                  = 0
   player.my                  = 0
   player.fx                  = 0
   player.fy                  = 0
   player.thrustMag           = 500
   player.firePeriod          = 120
   player.noFirstBullet       = true
   player.bulletsPerShot      = 3
   player.bulletSpread        = 4
   player.bulletWidth         = 6
   player.bulletHeight        = 6
   player.bulletColor         = { 1, 1, 0 }
   player.bulletSpeed         = 1000
   player.bulletSpeedVariance = 100
   
   -- Left Joystick Listener
   --
   function player.onLeftJoystick( self, event )      
      -- Snag the joystick <x,y> values for later user
      self.mx     = event.x
      self.my     = event.y
   end
   listen( "onLeftJoystick", player )

   -- Left Joystick Listener
   --
   function player.onLeftJoystick( self, event )      
      -- Snag the joystick <x,y> values for later user
      self.mx     = event.x
      self.my     = event.y
   end
   listen( "onLeftJoystick", player )
   
   -- Right Joystick Listener
   --
   function player.onRightJoystick( self, event )      
      -- Snag the joystick <x,y> values for later user
      self.fx     = event.x
      self.fy     = event.y
   end
   listen( "onRightJoystick", player )

   --
   -- enterFrame Listener
   --
   function player.enterFrame( self, event )		
      if( not common.isRunning or not isValid( self ) ) then 
          return 
      end
      
      local sensitivity = 0.15

      -- Facing 	
      --	
      self.rotation = ( mAbs(self.mx) >= sensitivity or mAbs(self.my) >= sensitivity ) and vector2Angle( self.mx, self.my ) or self.rotation
 
      -- Movement
      --
      if( mAbs(self.mx) >= sensitivity or mAbs(self.my) >= sensitivity ) then
         self:setLinearVelocity( self.mx * self.thrustMag, self.my * self.thrustMag )
         
         -- Add Particle Trail
         for i = 1, 3 do
            local particle = particleMgr:get()            
            self.parent:insert( particle )
            particle:toBack()
            particle:setFillColor(1,1,1)
            particle.xScale = 0.05
            particle.yScale = 0.05
            particle.x = self.x
            particle.y = self.y
            particle.onComplete = function( self )
               self:release()               
            end
            local toScale 
            if( common.particleStyle == 1 ) then
               toScale = 6
            else
               toScale = 1
            end
            transition.to( particle, 
                           { 
                              x = particle.x + mRand( -5, 5 ), y = particle.y + mRand( -5, 5 ), 
                              alpha = 0.5, 
                              xScale = toScale, yScale = toScale, 
                              time = mRand(500, 1000), onComplete = particle } )
         end
         
      else
         self:setLinearVelocity(0,0)
      end
 
      -- Limit Player's Movement
      --
      if( self.x < common.leftLimit ) then 
         self.x = common.leftLimit 
      elseif( self.x > common.rightLimit ) then 
         self.x = common.rightLimit 
      end 
      if( self.y < common.upLimit ) then 
         self.y = common.upLimit 
      elseif( self.y > common.downLimit ) then 
         self.y = common.downLimit 
      end 

 
      -- Firing Angle
      --
      self.fireAngle = ( mAbs(self.fx) >= sensitivity or mAbs(self.fy) >= sensitivity ) and vector2Angle( self.fx, self.fy ) or self.fireAngle


      -- Firing
      --
      if( mAbs(self.fx) >= sensitivity or mAbs(self.fy) >= sensitivity ) then
         self:fireBullet()
      end

   end
   listen( "enterFrame", player )
   
   
   --
   -- Bullet Firing Code
   --
   player.fireBullet = bulletMaker.create
   
   --
   -- Store reference to player in common
   --   
   common.player = player
   
   return player
end


return playerMaker