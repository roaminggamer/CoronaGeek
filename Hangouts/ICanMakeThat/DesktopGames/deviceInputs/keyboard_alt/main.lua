display.setStatusBar(display.HiddenStatusBar)  -- Hide that pesky bar
io.output():setvbuf("no") -- Don't use buffer for console messages
-- IGNORE ABOVE -- IGNORE ABOVE -- IGNORE ABOVE -- IGNORE ABOVE -- IGNORE ABOVE -- IGNORE ABOVE 

--
-- Requires
--
require "ssk.load"  -- Load a minimized version of the SSK library (just the bits we'll use)
local keyCleaner = require "keyCleaner"

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
local ctrl 	= display.newCircle( 40, 40 + 0 * 50, 20 )
local tmp 	= display.newText( "Control Key", ctrl.x + 40, ctrl.y, native.systemFont, 20 )
tmp.anchorX = 0

local cmd 	= display.newCircle( 40, 40 + 1 * 50, 20 )
local tmp 	= display.newText( "Command Key", cmd.x + 40, cmd.y, native.systemFont, 20 )
tmp.anchorX = 0

local alt 	= display.newCircle( 40, 40 + 2 * 50, 20 )
local tmp 	= display.newText( "Alt Key", alt.x + 40, alt.y, native.systemFont, 20 )
tmp.anchorX = 0

local shift = display.newCircle( 40, 40 + 3 * 50, 20 )
local tmp 	= display.newText( "Shift Key", shift.x + 40, shift.y, native.systemFont, 20 )
tmp.anchorX = 0

local tmp 	= display.newText( "Phase Name:", 30, 50 + 4 * 50, native.systemFont, 20 )
tmp.anchorX = 0
local phaseNameLabel = display.newText( "", tmp.x + tmp.contentWidth + 10, tmp.y, native.systemFont, 20 )
phaseNameLabel.anchorX = 0

local tmp 	= display.newText( "Key Name:", 30, 50 + 5 * 50, native.systemFont, 20 )
tmp.anchorX = 0
local keyNameLabel 	= display.newText( "", tmp.x + tmp.contentWidth + 10, tmp.y, native.systemFont, 20 )
keyNameLabel.anchorX = 0

local tmp 	= display.newText( "Key Code:", 30, 50 + 6 * 50, native.systemFont, 20 )
tmp.anchorX = 0
local keyCodeLabel = display.newText( "", tmp.x + tmp.contentWidth + 10, tmp.y, native.systemFont, 20 )
keyCodeLabel.anchorX = 0


--
-- The Key Listener - https://docs.coronalabs.com/daily/api/event/key/index.html
--
local function onKey( event ) 

	event = keyCleaner(event)

	local key 			= event.keyName
	local device 		= event.device
	local keyCode 		= event.nativeKeyCode
	local isCtrlDown 	= event.isCtrlDown
	local isCommandDown	= event.isCommandDown
	local isAltDown 	= event.isAltDown
	local isShiftDown 	= event.isShiftDown
	local phase 		= event.phase

	-- Update Visual Feedback:
	if( isCtrlDown ) then ctrl:setFillColor(unpack(G)) else ctrl:setFillColor(unpack(W)) end
	if( isCommandDown ) then cmd:setFillColor(unpack(G)) else cmd:setFillColor(unpack(W)) end
	if( isAltDown ) then alt:setFillColor(unpack(G)) else alt:setFillColor(unpack(W)) end
	if( isShiftDown ) then shift:setFillColor(unpack(G)) else shift:setFillColor(unpack(W)) end

	phaseNameLabel.text = phase
	
	if( phase == "ended" ) then		
		keyNameLabel.text = key
		keyCodeLabel.text = keyCode
	end


	print("\n ---------------------------- onKey() @ ", getTimer() )
	table.dump(event)
end

timer.performWithDelay( 100, function()  Runtime:addEventListener( "key", onKey ) end )