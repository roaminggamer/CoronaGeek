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


-- Localizations
local mRand             = math.random
local getTimer          = system.getTimer
local pairs             = pairs
local isValid           = display.isValid

local addVec			   = math2d.add
local subVec			   = math2d.sub
local diffVec			   = math2d.diff
local lenVec			   = math2d.length
local len2Vec			   = math2d.length2
local normVec			   = math2d.normalize
local vector2Angle		= math2d.vector2Angle
local angle2Vector		= math2d.angle2Vector
local scaleVec			   = math2d.scale

--require "scripts.joyTest"


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

--]]