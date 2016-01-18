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


-- 
--	 create()
-- 
function public.create( x, y )
   
   local layers = layersMaker.get()
         
   --
   -- New Enemy
   --   
   local enemy = display.newImageRect( layers.content, "images/diamond.png", common.enemySize, common.enemySize )
   enemy.x = x
   enemy.y = y
   enemy:setFillColor( 1, 1, 1, 0.5 )   
   physics.addBody( enemy, "dynamic", { radius = common.enemySize/2, filter = common.myCC:getCollisionFilter( "enemy" ) } )   
   enemy.speed = common.enemyDebugSpeed or 75   
   enemy.currentState = "spawn"
   enemy.createdTime = getTimer()
   enemy.blinkTrans = transition.blink( enemy, { time = 500 } )
   
   enemy.value = 250
   
   local time = 750
   local squeeze = 1.25
   local rebound = 0.8
   
   enemy.onSqueezed = function( self )
      self.onComplete = self.onRebounded
      transition.to( self, { xScale = squeeze, yScale = rebound, time = time, onComplete = self } )
   end

   enemy.onRebounded = function( self )
      self.onComplete = self.onSqueezed
      transition.to( self, {  xScale = rebound, yScale = squeeze, time = time, onComplete = self } )
   end

   
   -- Enemy 'Brain' - Handles all actions of the enemy
   --
   function enemy.think( self ) 
      if( not common.isRunning ) then return end 
      if( not isValid( self ) ) then return end      
      if( self.isDestroyed ) then return end
      
      local curTime = getTimer()
      
      -- SPAWNING
      if( self.currentState == "spawn" ) then
         if( curTime - self.createdTime > 1000 ) then
            self.currentState = "seeking"
            transition.cancel( self.blinkTrans )
            self.alpha = 1
         
            self.onComplete = enemy.onSqueezed
            transition.to( self, {  xScale = rebound,  yScale = squeeze, time = time/500, onComplete = self } )
         
         end
      
      -- SEEKING
      else
         local vec = diffVec( self, common.player )      
         vec = normVec( vec )      
         vec = scaleVec( vec, self.speed )      
         self:setLinearVelocity( vec.x, vec.y )      
      end            
      timer.performWithDelay( 500, self )      
   end
   enemy.timer = enemy.think
      
   return enemy
end



return public