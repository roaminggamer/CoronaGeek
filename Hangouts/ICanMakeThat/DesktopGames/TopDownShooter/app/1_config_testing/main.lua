-- =============================================================
-- Copyright Roaming Gamer, LLC. 2009-2015
-- =============================================================
-- =============================================================
-- main.lua
-- =============================================================

----------------------------------------------------------------------
--  Pre-Require Configuration & Initialization
----------------------------------------------------------------------
math.randomseed(os.time());

--
-- Requires
--
require "ssk.loadSSK"  -- Load a minimized version of the SSK library (just the bits we'll use)
local logger 		= require "scripts.logger" -- Requires SSK
local windowing 	= require "scripts.windowing"

----------------------------------------------------------------------
--  Post-Require Configuration & Initialization
----------------------------------------------------------------------
if( onIOS or onAndroid or onSimulator ) then
	display.setStatusBar(display.HiddenStatusBar)  -- Hide that pesky bar
	io.output():setvbuf("no") -- Don't use buffer for console messages
end


----------------------------------------------------------------------
--  Following Code To Verify build.settings and config.lua are correct
----------------------------------------------------------------------
local _R_ = { 1,0,0 }
local _G_ = { 0,1,0 }
local _B_ = { 0,0,1 }
local _Y_ = { 1,1,0 }
local _P_ = { 1,0,1 }

local group

local function drawTest()

	display.remove(group)

	group = display.newGroup()

	local size = 80

	local tmp = display.newLine( group, centerX, top, centerX, bottom )
	tmp.strokeWidth = 2

	local tmp = display.newLine( group, left, centerY, right, centerY )
	tmp.strokeWidth = 2

	local ul = display.newRect( group, left, top, size, size )
	ul.anchorX = 0
	ul.anchorY = 0
	ul:setFillColor( unpack( _R_ ) )


	local ur = display.newRect( group, right, top, size, size )
	ur.anchorX = 1
	ur.anchorY = 0
	ur:setFillColor( unpack( _G_ ) )


	local lr = display.newRect( group, right, bottom, size, size )
	lr.anchorX = 1
	lr.anchorY = 1
	lr:setFillColor( unpack( _B_ ) )


	local ll = display.newRect( group, left, bottom, size, size )
	ll.anchorX = 0
	ll.anchorY = 1
	ll:setFillColor( unpack( _Y_ ) )

	local c = display.newRect( group, centerX, centerY, size, size )
	c:setFillColor( unpack( _P_ ) )
end

-- https://docs.coronalabs.com/daily/api/event/resize/index.html
Runtime:addEventListener( "resize", drawTest )

drawTest()
