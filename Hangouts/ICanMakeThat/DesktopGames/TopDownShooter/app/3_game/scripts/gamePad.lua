local common 	= require "scripts.common"

local curFrame = 0
local lastFrame = -1
common.listen( "enterFrame", function() curFrame = curFrame + 1 end )

local public = {}
local joyValues = { 0, 0, 0, 0 }

--
-- Note: 'key' events from game pad are being captured in individual modules (playerMaker.lua, etc.).
--

--
-- Basic Joystick Listener for joysticks on gamePad
--
-- This listener takes the 'axis' event and 'cleans it up' a bit.
-- It also regulates flooding and only sends out one new 'joystick' event per frame.
--
--
local sensitivity = 0.15
local function onAxis( event )
   --table.dump(event)
   --table.dump(event.axis)
   local axis 		         = event.axis
   local axisDescriptor 	= axis.descriptor
   local normValue         = event.normalizedValue
   axisDescriptor          = axisDescriptor:gsub(":", "")
   local parts             = common.split( axisDescriptor, " " )
   local padNum = parts[2]
   
   print( normValue )
   
   --local axisNum = tonumber(parts[4])
   axisNum = tonumber( axis.number )
   --
   -- For typical gamepad axes are as follows:
   --[[
         1 - Left joystick X
         2 - Left joystick Y
         3 - Right joystick X
         4 - Right joystick Y
         5 - Left Trigger
         6 - Right Trigger
   --]]
   --
   
   joyValues[axisNum] = normValue
   
   -- You need to set a sensitivity level because joysticks are NOISY.
   --
   -- The easiest way to solve this is to ignore values below a certain 'sensitivity' threshold
   --if( normValue > sensitivity ) then
      --print( padNum, axisNum, normValue )
   --else
      --joyValues[axisNum] = 0
   --end
   
   if( lastFrame < curFrame ) then 
      lastFrame = curFrame
      if( axisNum == 1 or axisNum == 2 ) then
         common.post( "onLeftJoystick", { axis = axisNum, vec = { x = tonumber(joyValues[1]), y = tonumber(joyValues[2]) } } )
      elseif( axisNum == 3 or axisNum == 4 ) then
         common.post( "onRightJoystick", { axis = axisNum, vec = { x = tonumber(joyValues[3]), y = tonumber(joyValues[4]) } } )
      end
   end
   return false
end
Runtime:addEventListener( "axis", onAxis )


return public