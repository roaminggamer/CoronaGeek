local common      = require "scripts.common"
local spriteMaker = require 'scripts.spriteMaker'

local mouseTrap = {}

local info 	= require "images.reiners.mousetrap"
local sheet 	= info:getSheet()
local imageSheet 	=  graphics.newImageSheet("images/reiners/mousetrap.png", sheet )

local seqData = {}

local dirs = { "front ", "iso left ", "iso right " }

local anims = {}
anims["mousetrap"]		= { frames = 9,  time = 900,  loops = 1 }

for i = 1, #dirs do
	for k, v in pairs( anims ) do
		spriteMaker.generateSequence( seqData, k, dirs[i], info, v )
	end
end

function mouseTrap.create( group, x, y, scale )
   
	local tmp = display.newSprite( imageSheet, seqData )
	tmp.x = x
	tmp.y = y
	group:insert( tmp )
	tmp:play()
	tmp:scale(scale,scale)

	tmp:setSequence( "front" )
	--tmp:pause()
   
   -- Add a physics body
   physics.addBody( tmp, "dynamic", { radius =  20, filter = common.myCC:getCollisionFilter( "trap" ), isSensor = true }  )
   tmp.colliderName = "trap"
   
   -- Basic collision handler
   --
   tmp.collision = function( self, event )
      local other = event.other
      
      -- Only trigger on began
      if( event.phase ~= "began" ) then return end
      
      -- Only trigger for enemies (redundant with collision settings so this is just an example of an alternate way to cull collisions)
      if( other.colliderName ~= "zombie" and other.colliderName ~= "skeleton" ) then return false end
      
      -- Already triggered!  Abort early
      if( self.triggerCount and self.triggerCount > 0 ) then
         return 
      end
      
      -- Set safety flag to avoid entering listener again
      self.triggerCount = 1
      
      -- Listen for end of animation and remove trap after short delay
      function self.sprite( self, event )
         if( event.phase == "ended" ) then
            transition.to( self, { alpha = 0, delay = 1000, time = 1000, onComplete = display.remove } )
         end
      end
      self:addEventListener( "sprite" )
      
      -- Start animation
      self:play()      
      
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

return mouseTrap