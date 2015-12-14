-- =============================================================
-- Copyright Roaming Gamer, LLC. 2009-2015 
-- =============================================================
-- This content produced for Corona Geek Hangouts audience.
-- You may use any and all contents in this example to make a game or app.
-- =============================================================
local physics 			   = require "physics"
local common 			   = require "scripts.common"

local gemMaker = {}

function gemMaker.create( group, x, y, color )
   local gem = display.newImageRect( group, "images/reiners/gem_" ..color .. ".png", 17, 23 )   
   gem.x = x
   gem.y = y
   physics.addBody( gem, "static", { radius = 20, filter = common.myCC:getCollisionFilter( "gem" ), isSensor = true }  )
   gem.colliderName = "gem"   
   gem.myColor = color
   
   function gem.collision( self, event )
      local other = event.other        
      if( other.colliderName ~= "player" ) then return false end      
      
      if( event.phase == "began" ) then
         self:removeEventListener("collision")         
         common.hasGem[self.myColor] = true
         display.remove(self)
         
         common.post( "onSFX", { sfx = "gem" } )
         
         local hasAll = true
         for k,v in pairs( common.hasGem ) do
            hasAll = hasAll and v
         end
         if( hasAll ) then
            timer.performWithDelay( 250,
               function()
                  common.currentLevel = common.currentLevel + 1
                  common.post( "onLevelComplete" )                  
               end )
         end         
      end
      return true
   end
   gem:addEventListener("collision")
	return gem
end

return gemMaker