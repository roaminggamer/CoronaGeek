local common      = require "scripts.common"
local spriteMaker = require 'scripts.spriteMaker'
local math2d 			   = require "plugin.math2d"

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

local leafStorm = {}

local info 	= require "images.reiners.leafstorm"
local sheet 	= info:getSheet()
local imageSheet 	=  graphics.newImageSheet("images/reiners/leafstorm.png", sheet )

local seqData = {}

local anims = {}
anims["appearing"]		= { frames = 24,  time = 1200,  loops = 1 }
anims["disappearing"]	= { frames = 24,  time = 1200,  loops = 1 }
anims["rotating"]		= { frames = 24,  time = 1200,  loops = 0 }


for k, v in pairs( anims ) do
	spriteMaker.generateSequence2( seqData, k, info, v )
end

function leafStorm.create( group, x, y, scale )
	local tmp = display.newSprite( imageSheet, seqData )
	tmp.x = x
	tmp.y = y
	group:insert( tmp )
	tmp:scale(scale,scale)
   
   
   -- Add a physics body
   physics.addBody( tmp, "dynamic", { radius =  20, filter = common.myCC:getCollisionFilter( "trap" ), isSensor = true }  )
   tmp.colliderName = "trap"
   tmp.colliderName = "trap"
      

   -- This trap stays around for 15 seconds, attacks consecutive random enemies, then disappears
   --
   
   -- Rudimentary "AI" to seek random enemies
   function tmp.seekEnemy( self )
      if( not common.isValid( self ) ) then return end
      local enemyManager 		= require "scripts.enemyManager"
      
      -- Get a target
      local target = enemyManager.getNearest( common.player )
      --local target = enemyManager.getRandom()
      
      -- If no targets, destroy me early
      if( not target ) then 
         self:setSequence( "disappearing" )
         self:play()
         
         return 
      end      

      local vec = diffVec( self, target )
      local angle = vector2Angle( vec ) 
      self.myAngle = angle      
      local len = lenVec(vec)
      local time = 1000 * len / common.leafStormSpeed

      -- Cancel prior transition if any
      transition.cancel( self )
      
      -- Start new transition      
      transition.to( self, { x = target.x, y = target.y, time = time, onComplete = self } )
      
   end
   tmp.onComplete = tmp.seekEnemy
      
   
   -- This listener handles switching animations based on current ending animation. 
   -- It also removes the object at the end of the 'disappearing' animation.
   function tmp.sprite( self, event )      
      if( event.phase == "ended" ) then
         print(self.sequence)
         if( self.sequence == "appearing" ) then
            self:setSequence( "rotating" )
            self:play()
            self:seekEnemy()
         elseif( self.sequence == "disappearing" ) then
            self:pause()
            self.onComplete = nil
            transition.cancel( self )            
            transition.to( self, { alpha = 0, time = 1000, onComplete = display.remove } )
            self:removeEventListener( "sprite" )   
         end         
      end
   end
   tmp:addEventListener( "sprite" )   
   
   -- Start the 'appearing' animation
	tmp:setSequence( "appearing" )
	tmp:play()
   
   -- Change animation in 8 seconds
   function tmp.timer( self ) 
      if( not common.isValid( self ) ) then 
         return
      end
      self:setSequence( "disappearing" )
      self:play()
   end
   timer.performWithDelay( 15000, tmp )
      
     
   -- Basic collision handler
   --
   tmp.collision = function( self, event )
      local other = event.other
      
      -- Only trigger on began
      if( event.phase ~= "began" ) then return end
      
      -- Only trigger for enemies (redundant with collision settings so this is just an example of an alternate way to cull collisions)
      if( other.colliderName ~= "zombie" and other.colliderName ~= "skeleton" ) then return false end
      
      -- Seek a new target
      self:seekEnemy()
      
      -- Stop the enemy
      transition.cancel(other)

      -- Mark enemy as destroyed (to stop AI)
      --
      other.isDestroyed = true
      
      -- Play an animation and then remove
      other:playAngleAnim( "disintegrate", common.normRot( other.myAngle ) )
      function other.sprite( self, event )
         if( event.phase == "ended" ) then
            self:delayedSelfDestruct( 10000 )
         end
      end
      other:addEventListener( "sprite" )

      return true
   end
   tmp:addEventListener( "collision" )      
      

	return tmp
end

return leafStorm