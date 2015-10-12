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


local lbutton 	= display.newCircle( 40, 40 + 4 * 50, 20 )
local tmp 	= display.newText( "Left Button", lbutton.x + 40, lbutton.y, native.systemFont, 20 )
tmp.anchorX = 0

local mbutton 	= display.newCircle( 40, 40 + 5 * 50, 20 )
local tmp 	= display.newText( "Middle Button", mbutton.x + 40, mbutton.y, native.systemFont, 20 )
tmp.anchorX = 0

local rbutton 	= display.newCircle( 40, 40 + 6 * 50, 20 )
local tmp 	= display.newText( "Right Button", rbutton.x + 40, rbutton.y, native.systemFont, 20 )
tmp.anchorX = 0

local tmp 	= display.newText( "X:", centerX, 50 + 0 * 50, native.systemFont, 20 )
tmp.anchorX = 0
local xlabel = display.newText( "", tmp.x + tmp.contentWidth + 10, tmp.y, native.systemFont, 20 )
xlabel.anchorX = 0

local tmp 	= display.newText( "Y:", centerX, 50 + 1 * 50, native.systemFont, 20 )
tmp.anchorX = 0
local ylabel 	= display.newText( "", tmp.x + tmp.contentWidth + 10, tmp.y, native.systemFont, 20 )
ylabel.anchorX = 0

local tmp 	= display.newText( "Scroll X:", centerX, 50 + 2 * 50, native.systemFont, 20 )
tmp.anchorX = 0
local scrollxlabel = display.newText( "", tmp.x + tmp.contentWidth + 10, tmp.y, native.systemFont, 20 )
scrollxlabel.anchorX = 0

local tmp 	= display.newText( "Scroll Y:", centerX, 50 + 3 * 50, native.systemFont, 20 )
tmp.anchorX = 0
local scrollylabel 	= display.newText( "", tmp.x + tmp.contentWidth + 10, tmp.y, native.systemFont, 20 )
scrollylabel.anchorX = 0

local tmp 	= display.newText( "Click Count:", centerX, 50 + 4 * 50, native.systemFont, 20 )
tmp.anchorX = 0
local clickLabel = display.newText( "", tmp.x + tmp.contentWidth + 10, tmp.y, native.systemFont, 20 )
clickLabel.anchorX = 0

local tmp 	= display.newText( "Time:", centerX, 50 + 5 * 50, native.systemFont, 20 )
tmp.anchorX = 0
local timelabel = display.newText( "", tmp.x + tmp.contentWidth + 10, tmp.y, native.systemFont, 20 )
timelabel.anchorX = 0

local tmp 	= display.newText( "Type:", centerX, 50 + 6 * 50, native.systemFont, 20 )
tmp.anchorX = 0
local typelabel = display.newText( "", tmp.x + tmp.contentWidth + 10, tmp.y, native.systemFont, 20 )
typelabel.anchorX = 0



--
-- The Mouse Listener -- https://docs.coronalabs.com/daily/api/event/mouse/index.html
--
local function onMouse( event ) 

	local isCtrlDown 	= event.isCtrlDown
	local isCommandDown	= event.isCommandDown
	local isAltDown 	= event.isAltDown
	local isShiftDown 	= event.isShiftDown
	
	local primary 		= event.isPrimaryButtonDown
	local secondary 	= event.isSecondaryButtonDown
	local middle 		= event.isMiddleButtonDown
	local time 			= event.time


	-- Update Visual Feedback:
	if( isCtrlDown ) then ctrl:setFillColor(unpack(G)) else ctrl:setFillColor(unpack(W)) end
	if( isCommandDown ) then cmd:setFillColor(unpack(G)) else cmd:setFillColor(unpack(W)) end
	if( isAltDown ) then alt:setFillColor(unpack(G)) else alt:setFillColor(unpack(W)) end
	if( isShiftDown ) then shift:setFillColor(unpack(G)) else shift:setFillColor(unpack(W)) end


	if( primary ) then lbutton:setFillColor(unpack(G)) else lbutton:setFillColor(unpack(W)) end
	if( secondary ) then rbutton:setFillColor(unpack(G)) else rbutton:setFillColor(unpack(W)) end
	if( middle ) then mbutton:setFillColor(unpack(G)) else mbutton:setFillColor(unpack(W)) end

	xlabel.text = tostring(event.x)
	ylabel.text = tostring(event.y)
	scrollxlabel.text = tostring(event.scrollX)
	scrollylabel.text = tostring(event.scrollY)
	clickLabel.text = (event.clickLabel ) and tostring(event.clickLabel) or 0
	typelabel.text = tostring(event.type)
	timelabel.text = tostring(event.time)

	print("\n ---------------------------- onKey() @ ", getTimer() )
	table.dump(event)
end

timer.performWithDelay( 100, function()  Runtime:addEventListener( "mouse", onMouse ) end )