local mAbs           = math.abs
local strMatch       = string.match
local strGSub        = string.gsub
local strLower       = string.lower
local strFirstUpper  = string.first_upper
local getTimer       = system.getTimer
local isValid        = display.isValid

local gamePad = {}

local joyAxisValues = {}
joyAxisValues[1] =  { x = 0, y = 0 }
joyAxisValues[2] =  { x = 0, y = 0 }
joyAxisValues[3] =  { x = 0, y = 0 }
joyAxisValues[4] =  { x = 0, y = 0 }

--
-- Note: 'key' events from game pad are being captured in individual modules (playerMaker.lua, etc.).
--

local buttons        = { "buttonA", "buttonB",  "buttonX", "buttonY", "buttonStart", "buttonSelect" }
local dpad           = { "left", "right", "up", "down"  }
local phaseConvert   = { down = "began", up = "ended" }
local onKey = function( event )   
   --table.print_r(event)         
   -- Check for buttons we care about
   local i = 1
   local button 
   while( not button and i <= #buttons  ) do
      if( event.keyName == buttons[i] ) then
         button = buttons[i]
      end
      i = i + 1
   end
   if( not button ) then
      local i = 1
      while( not button and i <= #dpad  ) do
         if( event.keyName == dpad[i] ) then
            button = dpad[i]
         end
         i = i + 1
      end
   end
   if( button ~= nil ) then 
      
      -- Extract 'player' number from descriptor
      local player = string.split( event.descriptor, " " )    
      player = strGSub( player[2], ":", "" )
      player = tonumber(player)
      
      -- Assemble event table
      local details = { button = button,  player = player, time = getTimer(), phase = phaseConvert[event.phase] }      
      local eventName = "on" .. strFirstUpper( button )
            
      -- Button specific event
      post( eventName,  details )      
      
      -- Unified event
      details.button = button
      post( "onGamePad",  details )
      
   end
   
   return false   
end
listen( "key", onKey )


--
-- Basic Joystick Listener for joysticks on gamePad
--
-- This listener takes the 'axis' event and 'cleans it up' a bit.
--
--
local sensitivity = 0.15
local function onAxis( event )
   --table.print_r(event)
   
   local axis 		         = event.axis
   local axisType          = strLower(axis.type)
   local axisNum           = tonumber( axis.number )
   local axisDescriptor 	= axis.descriptor
   local axisValue         = event.normalizedValue
   axisDescriptor          = axisDescriptor:gsub(":", "")
   
   -- Extract 'player' number from descriptor
   local player = string.split( axisDescriptor, " " )
   player = strGSub( player[2], ":", "" )
   player = tonumber(player)
   
   local isLeftJoy   = (strMatch( axisType, "left" ) ~= nil )
   local isRightJoy  = (strMatch( axisType, "right" ) ~= nil )
   
   -- Apply sensitivity
   if( mAbs( axisValue ) < sensitivity ) then
      --axisValue = 0
   end
   
   local axisLetter
   local details
   if( isLeftJoy ) then
      
      axisLetter = strGSub( axisType, "left", "" )
      joyAxisValues[player][axisLetter] = axisValue
      details = {}
      details.player    = player
      details.stick     = "left"
      details.x         = joyAxisValues[player].x
      details.y         = joyAxisValues[player].y
      details.time      = time
      --print( "Left ", axisLetter, axisNum, player, axisValue )      
      
      post( "onLeftJoystick", details )
   elseif( isRightJoy ) then
      axisLetter = strGSub( axisType, "right", "" )
      joyAxisValues[player][axisLetter] = axisValue
      details = {}
      details.player    = player
      details.stick     = "right"
      details.x         = joyAxisValues[player].x
      details.y         = joyAxisValues[player].y
      details.time      = time
      post( "onRightJoystick", details )
      --print( "Right ", axisLetter, axisNum, player, axisValue )            
   end
   --print( player, axisLetter, axisValue )
   
   if( details ~= nil ) then
      --post( "onGamePad", details )
      post( "onJoystick", details )      
      --table.dump(details)
   end
   
   return false
end
listen( "axis", onAxis )


return gamePad