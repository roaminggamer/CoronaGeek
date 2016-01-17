--require("mobdebug").start() -- ZeroBrane Users
-- =============================================================
-- Copyright Roaming Gamer, LLC. 2009-2015 
-- =============================================================
-- This content produced for Corona Geek Hangouts audience.
-- You may use any and all contents in this example to make a game or app.
-- =============================================================

----------------------------------------------------------------------
--  Misc Configuration & Initialization
----------------------------------------------------------------------
display.setStatusBar(display.HiddenStatusBar)  
system.activate("multitouch")
io.output():setvbuf("no") 
math.randomseed(os.time());
native.setProperty( "mouseCursorVisible", false )

----------------------------------------------------------------------
--	Globals
----------------------------------------------------------------------
_G.gameFont    = "Aileron Thin"
--_G.gameFont    = "Space Cruiser Pro"
_G.fontColor   = { 0xa4/255, 0xee/255, 0x47/255 }
_G.fontColor2  = { 1, 1, 1 }

----------------------------------------------------------------------
--	Requires
----------------------------------------------------------------------
-- Include SSK Core (Features I just can't live without.)
--local ssk 		= require "ssk.loadSSK"
require("ssk_core.globals.variables")
require("ssk_core.globals.functions")
require("ssk_core.extensions.display")
require("ssk_core.extensions.io")
require("ssk_core.extensions.math")
require("ssk_core.extensions.string")
require("ssk_core.extensions.table")
require("ssk_core.extensions.transition_color")

local common 	= require "scripts.common"
local gamePad  = require "scripts.gamePad" 
local math2d   = require "plugin.math2d"

-- Push Button and Toggle Button OOP Classes (from a prior hangout)
require "scripts.buttonClasses.pushButtonClass"
require "scripts.buttonClasses.toggleButtonClass"
require "scripts.buttonClasses.controllerPushButtonClass"

-- Start listening for key inputs that affect windowing (full screen, minimize, maximize, etc. )
if( not onSimulator ) then
   require "scripts.windowing"
end



----------------------------------------------------------------------
-- Sound
----------------------------------------------------------------------
if( common.meterEn ) then
   local meter = require "scripts.meter"
   meter.create_fps()
   meter.create_mem()
end
  
  
----------------------------------------------------------------------
-- Sound
----------------------------------------------------------------------
local soundMgr = require "scripts.soundMgr"
--soundMgr.init()
--soundMgr.enableSFX( true )
--soundMgr.playSoundTrack( "sounds/music/8bit Dungeon Level.mp3" )


----------------------------------------------------------------------
-- Inputs
----------------------------------------------------------------------
if( common.inputStyle == "controller" ) then
   require "scripts.gamePad"
end

----------------------------------------------------------------------
-- Physics
----------------------------------------------------------------------
local physics = require "physics"
physics.start()
physics.setGravity( 0, 0 )
--physics.setDrawMode( "hybrid" )

----------------------------------------------------------------------
-- Composer
----------------------------------------------------------------------
-- http://docs.coronalabs.com/daily/api/library/composer/index.html
local composer 	= require "composer" 
--composer.isDebug = true
--composer.recycleOnLowMemory = false
--composer.recycleOnSceneChange = true

composer.gotoScene( "ifc.splash" )
--composer.gotoScene( "ifc.mainMenu", { params = { skipAnimation = true } } )
--composer.gotoScene( "ifc.playGUI" )

