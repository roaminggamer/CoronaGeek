-- =============================================================
-- Copyright Roaming Gamer, LLC. 2009-2015 
-- =============================================================
-- This content produced for Corona Geek Hangouts audience.
-- You may use any and all contents in this example to make a game or app.
-- =============================================================
local particleMgr = {}

--
-- Forward Declarations For (slight) Speedup
--
local newCircle      = display.newCircle
local newRect        = display.newRect
local newImageRect   = display.newImageRect
local newSprite      = display.newSprite

--
-- Basic Sprite For Example
--
local pinkyInfo   = require "pinky"
local pinkySheet  = graphics.newImageSheet("pinky.png", pinkyInfo:getSheet() )
local pinkySeqData = 
   {
      { name = "rightwalk", frames = {3,4,5,6,7,8,9,10,11,12,13}, time = 500, loopCount = 0, loopDirection = "forward"}, 
   }


local freeParticles = { }
local usedParticles = { }

-- 
--	 reset()
-- 
function particleMgr.reset()
   while(#usedParticles > 0 ) do
      usedParticles[1]:release()
   end
end

-- 
--	 getCounts()
-- 
function particleMgr.getCounts()
   return #freeParticles, #usedParticles, #freeParticles + #usedParticles
end

-- 
--	 get()
-- 
function particleMgr.get( particleStyle, caching )
   --print("particleMgr.get( ", particleStyle, caching, " )", #usedParticles, #freeParticles )
   -- Default to style 1 + caching on
   particleStyle = particleStyle or 1
   if( caching == nil ) then
      caching = true
   end

   local particle
   if( caching and #freeParticles > 0 ) then 
      --print("USED CACHED", #usedParticles, #freeParticles )
      particle = freeParticles[#freeParticles]
      table.remove( freeParticles, #freeParticles )
      particle.inUse = true
   
   else
      --- == Styles: 
      --
      --- 1 - display.newCircle()
      --- 2 - display.newRect()
      --- 3 - display.newImageRect()
      --- 4 - display.newSprite()
      ---
      if( particleStyle == 1 ) then
         particle = newCircle( 100000, 100000, 10 )

      elseif( particleStyle == 2 ) then
         particle = newRect( 100000, 100000, 20, 20 )

      elseif( particleStyle == 3 ) then
         particle = newImageRect( "smiley.png", 20, 20 )
         particle.x = 100000
         particle.y = 100000

      elseif( particleStyle == 4 ) then
         particle = newSprite( pinkySheet, pinkySeqData )
         particle.x = 100000
         particle.y = 100000
      end
      
      if( caching ) then
         function particle.release(self)
            --print("CACHE RELEASE", self.inUse )
            if( not self.inUse ) then return end            
            self.x = 10000
            self.y = 10000
            self.inUse = false
            table.remove( usedParticles, table.indexOf( usedParticles, self ) )
            freeParticles[#freeParticles+1] = self
            display.currentStage:insert( self )
            --print("CACHE RELEASED", #usedParticles, #freeParticles )
         end
         particle.inUse = true
         usedParticles[#usedParticles+1] = particle
      else
         particle.release = display.remove
      end
      
      --print("CREATED NEW", #usedParticles, #freeParticles )
   end
   
   return particle
end


return particleMgr