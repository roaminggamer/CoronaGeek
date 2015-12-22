-- =============================================================
-- Copyright Roaming Gamer, LLC. 2009-2015 
-- =============================================================
-- This content produced for Corona Geek Hangouts audience.
-- You may use any and all contents in this example to make a game or app.
-- =============================================================
local public = {}

local common 			   = require "scripts.common"
local layersMaker		   = require "scripts.layersMaker"
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

local curFrame = 0
common.listen( "enterFrame", function() curFrame = curFrame + 1 end )

-- 
--	 destroy()
-- 
function public.destroy()
end

-- 
--	 create()
-- 
function public.create()
   
   public.destroy()
   
   local layers = layersMaker.get()
   
   local reticle = display.newImageRect( layers.interfaces, "images/reticle2.png", 80, 80 )
	reticle.x = centerX
	reticle.y = 10000

	reticle.lastMouseFrame = curFrame - 1

   if( common.inputStyle == "keyboardAndMouse" ) then
      -- Mouse Listener - Reticle tracks position of mouse
      function reticle.mouse( self, event )
         if( self.lastMouseFrame == curFrame ) then return false end
         self.lastMouseFrame = curFrame

         if( not common.isRunning ) then return end

         if( common.autoIgnore( "mouse", self ) ) then  return end
         self.x = event.x
         self.y = event.y
      end
      common.listen( "mouse", reticle )
   else
      --
      -- onJoystick is a custom event (see gamePad.lua) where extract axis values and package them up to easier consumption.
      --
      function reticle.onLeftJoystick( self, event )
         --table.dump(event)
         local angle = vector2Angle( event.vec )
         angle = common.normRot( angle ) 
         local len = lenVec( event.vec )
         if( len > 1 ) then 
            len = 1
         end         
         
         local vec = normVec( event.vec )
         vec = scaleVec( vec, common.reticleDist * len )
         
         self.x = common.centerX + vec.x
         self.y = common.centerY + vec.y
      end
      common.listen( "onLeftJoystick", reticle )
   end

	return reticle
end

return public