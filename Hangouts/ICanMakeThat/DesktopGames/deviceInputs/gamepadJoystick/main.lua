-- ** STILL A WORK IN PROGRESS **
-- ** STILL A WORK IN PROGRESS **
-- ** STILL A WORK IN PROGRESS **
-- ** STILL A WORK IN PROGRESS **


display.setStatusBar(display.HiddenStatusBar)  -- Hide that pesky bar
io.output():setvbuf("no") -- Don't use buffer for console messages
-- IGNORE ABOVE -- IGNORE ABOVE -- IGNORE ABOVE -- IGNORE ABOVE -- IGNORE ABOVE -- IGNORE ABOVE 

--
-- Requires
--
require "ssk.load"  -- Load a minimized version of the SSK library (just the bits we'll use)

--
-- Localizations
--
local getTimer = system.getTimer

--
-- Local Variables
--
local G = { 0, 1, 0 }
local W = { 1, 1, 1 }


-- ==============================================================
-- 		Buttons (digital inputs)
-- ==============================================================
local function createKeyListeners( list,x  )
	list = list or {}
	x 			= x or left + 20	
	local y 	= top + 20
	local dy 	= 40

	for i = 1, #list do
		local keyName =  list[i].keyName
		if( keyName == "*" ) then
			local bubble 	= display.newRect( x, y + (i-1) * dy, 30, 30 )
			local label 	= display.newText( keyName, x + 30, bubble.y, native.systemFont, 14 )
			label.anchorX 	= 0
			bubble.label 	= label

			function bubble.key( self, event ) 
				local key 			= event.keyName
				local device 		= event.device
				local keyCode 		= event.nativeKeyCode
				local phase 		= event.phase

				self.label.text = key .. " ( code: " .. tostring( keyCode) .. "; phase: " .. tostring( phase ) .. " ) "				
				if( phase == "down" ) then		
					self:setFillColor(unpack(_G_))
				elseif( phase == "up" ) then		
					self:setFillColor(unpack(_R_))
				end
				return false
			end
			timer.performWithDelay( 100, function()  Runtime:addEventListener( "key", bubble ) end )			

		else 
			local bubble 	= display.newCircle( x, y + (i-1) * dy, 15 )
			local label 	= display.newText( keyName, x + 30, bubble.y, native.systemFont, 14 )
			label.anchorX 	= 0
			bubble.label 	= label
			bubble.keyName 	= keyName

			function bubble.key( self, event ) 
				local watchKey 		= self.keyName
				local key 			= event.keyName
				local device 		= event.device
				local keyCode 		= event.nativeKeyCode
				local phase 		= event.phase

				if( watchKey ~= key ) then return false end
				self.label.text = key .. " ( code: " .. tostring( keyCode) .. "; phase: " .. tostring( phase ) .. " ) "				
				if( phase == "down" ) then		
					self:setFillColor(unpack(_G_))
				elseif( phase == "up" ) then		
					self:setFillColor(unpack(_R_))
				end
				return false
			end
			timer.performWithDelay( 100, function()  Runtime:addEventListener( "key", bubble ) end )			
		end
	end
end

local buttonList = 
{
	{ keyName = "*" },
	{ keyName = "left"	},
	{ keyName = "right"	},
	{ keyName = "up"	},
	{ keyName = "down"	},
	{ keyName = "buttonA"	},
	{ keyName = "buttonB"	},
	{ keyName = "buttonX"	},
	{ keyName = "buttonY"	},
	{ keyName = "leftShoulderButton1"	},
	{ keyName = "leftShoulderButton2"	},
	{ keyName = "rightShoulderButton1"	},
	{ keyName = "rightShoulderButton2"	},
	{ keyName = "buttonSelect"	},
	{ keyName = "buttonStart"	},
	{ keyName = "buttonMode"	},
	{ keyName = "leftJoystickButton"	},
	{ keyName = "rightJoystickButton"	},
	
}

createKeyListeners( buttonList )



-- ==============================================================
-- 		Joysticks and Triggers (analog inputs)
-- ==============================================================


-- This works universally on OS X and Windows

--[[
local gamePads = {}

local function discoverGamePads()
	-- Fetch all input devices currently connected to the system
	local inputDevices = system.getInputDevices()

	-- Traverse all input devices
	for i = 1, #inputDevices do
		local descriptor 	= inputDevices[i].descriptor
		local displayName 	= inputDevices[i].displayName				
		local isGamePad = string.find( string.lower( descriptor ), "gamepad"  )
		--print( i, descriptor, displayName, string.lower( descriptor ), isGamePad )
		if( isGamePad ) then
			local nameParts = string.split( descriptor, " " )
			print("Found GamePad ", descriptor, displayName )
			local gamePad = { player = nameParts[2], 
			                  device = inputDevices[i], 
			                  connected = inputDevices[i].isConnected,
			                  connectionState = inputDevices[i].connectionState,
			                  id = inputDevices[i].permanentId,
			                  canVibrate = inputDevices[i].canVibrate,
			                  axes = inputDevices[i]:getAxes()  }
			--table.print_r( inputDevices[i] )
			gamePads[#gamePads+1] = gamePad
		end
	end

end
discoverGamePads()

table.print_r(gamePads)

--]]

-- This works universally on OS X and Windows

--[[
-- Use this for discovering new inputs or re-connecting yanked devices
local function onInputDeviceStatusChanged( event )
	print( event.device.displayName .. ": " .. event.device.connectionState )
	table.print_r( event )
end
Runtime:addEventListener( "inputDeviceStatus", onInputDeviceStatusChanged )
--]]

-- This only works on universally on OS X right now .. 2015.2742

----[[
local function onAxisEvent( event )
	table.dump(event)
    print( event.axis.descriptor .. ": Normalized Value = " .. tostring(event.normalizedValue) )
end

-- Add the axis event listener
Runtime:addEventListener( "axis", onAxisEvent )

--]]