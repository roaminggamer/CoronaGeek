-- =============================================================
-- Copyright Roaming Gamer, LLC. 2009-2015
-- =============================================================
-- =============================================================
-- main.lua
-- =============================================================
--[[
https://coronalabs.com/blog/2015/10/16/from-the-forum-issue-94/
http://gamasutra.com/blogs/ItayKeren/20150511/243083/Scroll_Back_The_Theory_and_Practice_of_Cameras_in_SideScrollers.php
]]
----------------------------------------------------------------------
--  Pre-Require Configuration & Initialization
----------------------------------------------------------------------
math.randomseed(os.time());

_G.gameFont = "AdelonSerial"


--
-- Requires
--
require "ssk.loadSSK"  -- Load a minimized version of the SSK library (just the bits we'll use)

local logger 		= require "scripts.logger" -- Requires SSK

local common 		= require "scripts.common"
local windowing 	= require "scripts.windowing"
local menu 			= require "scripts.menu"

local meter 		= require "scripts.meter"
meter.create_fps()
meter.create_mem()

----------------------------------------------------------------------
--  Post-Require Configuration & Initialization
----------------------------------------------------------------------
if( onIOS or onAndroid ) then
	display.setStatusBar(display.HiddenStatusBar)  -- Hide that pesky bar	
end
io.output():setvbuf("no") -- Don't use buffer for console messages


menu.create()
