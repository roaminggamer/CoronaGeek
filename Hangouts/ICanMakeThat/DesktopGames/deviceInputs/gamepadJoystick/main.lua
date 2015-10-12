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

--
-- Visual Feedback
--
local tmp 	= display.newText( "Phase Name:", 30, 50 + 0 * 50, native.systemFont, 20 )
tmp.anchorX = 0
local phaseNameLabel = display.newText( "", tmp.x + tmp.contentWidth + 10, tmp.y, native.systemFont, 20 )
phaseNameLabel.anchorX = 0

local tmp 	= display.newText( "Key Name:", 30, 50 + 1 * 50, native.systemFont, 20 )
tmp.anchorX = 0
local keyNameLabel 	= display.newText( "", tmp.x + tmp.contentWidth + 10, tmp.y, native.systemFont, 20 )
keyNameLabel.anchorX = 0

local tmp 	= display.newText( "Key Code:", 30, 50 + 2 * 50, native.systemFont, 20 )
tmp.anchorX = 0
local keyCodeLabel = display.newText( "", tmp.x + tmp.contentWidth + 10, tmp.y, native.systemFont, 20 )
keyCodeLabel.anchorX = 0




--
-- The Axis Listener -- https://docs.coronalabs.com/daily/api/event/axis/index.html
--
local function onAxis( event ) 

	print("\n ---------------------------- onKey() @ ", getTimer() )
	table.dump(event)
end

timer.performWithDelay( 100, function()  Runtime:addEventListener( "axis", onAxis ) end )


--
-- The Key Listener - https://docs.coronalabs.com/daily/api/event/key/index.html
--
local function onKey( event ) 

	local key 			= event.keyName
	local device 		= event.device
	local keyCode 		= event.nativeKeyCode
	local phase 		= event.phase

	-- Update Visual Feedback:
	phaseNameLabel.text = phase
	
	if( phase == "down" ) then		
		keyNameLabel.text = key
		keyCodeLabel.text = keyCode
	end


	print("\n ---------------------------- onKey() @ ", getTimer() )
	table.dump(event)
end

timer.performWithDelay( 100, function()  Runtime:addEventListener( "key", onKey ) end )