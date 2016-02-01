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

--
-- These global values are used for text and buttons throughout the app
--
_G.gameFont    = "Aileron Thin"
_G.fontColor   = { 0xa4/255, 0xee/255, 0x47/255 }
_G.fontColor2  = { 1, 1, 1 }

----------------------------------------------------------------------
--	Requires
----------------------------------------------------------------------
-- Include SSK Core (Features I just can't live without.)
require("ssk_core.globals.variables")
require("ssk_core.globals.functions")
require("ssk_core.extensions.display")
require("ssk_core.extensions.io")
require("ssk_core.extensions.math")
require("ssk_core.extensions.string")
require("ssk_core.extensions.table")
require("ssk_core.extensions.transition_color")


-- Load common and gamePad modules so they get initialized
--
local common 	= require "scripts.common"
local gamePad  = require "scripts.gamePad" 


-- Push Button and Toggle Button OOP Classes (from a prior hangout)
-- Load these to so they will get inserted into the global space.
require "scripts.buttonClasses.pushButtonClass"
require "scripts.buttonClasses.toggleButtonClass"
require "scripts.buttonClasses.controllerPushButtonClass"

-- Are we running on a desktop build?
-- If so, start listening for key inputs that affect windowing (full screen, minimize, maximize, etc. )
--
-- Tips: onSimulator and onDesktop can be found in ssk_core/globals/variables.lua
if( not onSimulator and onDesktop ) then
   require "scripts.windowing"
end

----------------------------------------------------------------------
-- Run FPS and Memory Meters?
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
if( common.inputStyle == "mobile" ) then   
elseif( common.inputStyle == "desktop" ) then
   print("Initialize GamePad")
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

--composer.gotoScene( "ifc.splash" )
composer.gotoScene( "ifc.mainMenu", { params = { skipAnimation = true } } )
--composer.gotoScene( "ifc.playGUI" )

