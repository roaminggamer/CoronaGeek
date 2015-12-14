local common      = require "scripts.common"
local spriteMaker = require 'scripts.spriteMaker'

local needleTrapMaker = {}

local info 	= require "images.reiners.trap2"
local sheet 	= info:getSheet()
local imageSheet 	=  graphics.newImageSheet("images/reiners/trap2.png", sheet )

local seqData = {}

local dirs = { "front close", "front open", "iso close", "iso open " }

local anims = {}
anims["single steelneedle"]	= { frames = 9,  time = 900,  loops = 0 }

for i = 1, #dirs do
	for k, v in pairs( anims ) do
		spriteMaker.generateSequence( seqData, k, dirs[i], info, v )
	end
end

--[[ -- Alternate needles not used (uncomment to explore them)
table.print_r(seqData)
local dirs = { "front close", "front open", "iso left close", "iso left open", "iso right close", "iso right open" }
local anims = {}
anims["steel needles"]		= { frames = 9,  time = 900,  loops = 0 }
for i = 1, #dirs do
	for k, v in pairs( anims ) do
		spriteMaker.generateSequence( seqData, k, dirs[i], info, v )
	end
end
--]]


function needleTrapMaker.create( group, x, y, scale )
	local tmp = display.newSprite( imageSheet, seqData )
	tmp.x = x
	tmp.y = y
	group:insert( tmp )
	tmp:setSequence( "single steelneedle" )
	tmp:play()
	tmp:scale(scale,scale)
	

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
      if( not other.isDestroyed and 
          self.triggerCount and 
          self.triggerCount > 3 ) then
         return 
      end
      
      -- Set safety flag to avoid entering listener again
      self.triggerCount = self.triggerCount or 0
      self.triggerCount = self.triggerCount + 1
       
      -- Self-destruct after three kills
      if( self.triggerCount == 3 ) then
         transition.to( self, { alpha = 0, delay = 1000, onComplete = display.remove } )
      end
      
      
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

return needleTrapMaker