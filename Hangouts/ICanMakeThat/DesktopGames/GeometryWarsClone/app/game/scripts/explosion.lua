-- =============================================================
-- Copyright Roaming Gamer, LLC. 2009-2015 
-- =============================================================
-- This content produced for Corona Geek Hangouts audience.
-- You may use any and all contents in this example to make a game or app.
-- =============================================================
local public = {}

local common 			   = require "scripts.common"
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
--	 create()
-- 
function public.create( group, x, y )
   local style = common.particleStyle
   
   if( not isDisplayObject( group ) ) then return end
   
   -- STYLE 1
   --
   -- Use 90 lines radiating all round the point if explosion.
   --
   if( style == 1 ) then
      -- explosion
      for i = 1, 359, 4 do
         local particle = particleMgr:get()
         particle.x = x
         particle.y = y
         particle.xScale = 1
         particle.yScale = 8
         particle:setFillColor(1,1,1)
         group:insert(particle)
         
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
   
   -- STYLE 2
   --
   -- Use 2..5 circles centered and then randomly offset from the point of explosion.
   --
   elseif( style == 2 ) then
      local total = math.random(2,5)
      local offset = 15
      for i = 1, total do
         local particle = particleMgr:get()
         particle.strokeWidth = 1
         particle:setFillColor(0,0,0,0)
         particle:setStrokeColor(1,1,1)
         particle.x = x + math.random( -offset, offset ) 
         particle.y = y + math.random( -offset, offset ) 
         particle.xScale = 0.05
         particle.yScale = 0.05
         group:insert(particle)
         
         function particle.onComplete( self ) 
            self:release()
         end         
         transition.to( particle, 
                        { 
                           xScale = 5, yScale = 5,
                           time = mRand(300,700),
                           delay = mRand(10,150),
                           alpha = 0.1,
                           onComplete = particle,
                           transition = easing.outCirc 
                        } )
         end
   end
end


return public