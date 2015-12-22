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

_G.gameFont = "AdelonSerial"

----------------------------------------------------------------------
--	Requires
----------------------------------------------------------------------
-- Include SSK
local ssk 		= require "ssk.loadSSK"

local common 	= require "scripts.common"

-- Start listening for key inputs that affect windowing (full screen, minimize, maximize, etc. )
require "scripts.windowing"

----------------------------------------------------------------------
-- Physics
----------------------------------------------------------------------
local physics = require "physics"
physics.start()
physics.setGravity( 0, 0 )
--physics.setDrawMode( "hybrid" )

----------------------------------------------------------------------
-- Start Game
----------------------------------------------------------------------
local soundMgr = require "scripts.soundMgr"
--soundMgr.init()
--soundMgr.enableSFX( true )

-- Play a sound track
--soundMgr.playSoundTrack( "sounds/music/8bit Dungeon Level.mp3" )

if( common.inputStyle == "controller" ) then
   require "scripts.gamePad"
end


-- Start the game and the numbered level.
local game 	   = require "scripts.game"
game.create()

-- Uncomment to test that destroy/create works fine
--timer.performWithDelay( 500 , function() game.create() end )

