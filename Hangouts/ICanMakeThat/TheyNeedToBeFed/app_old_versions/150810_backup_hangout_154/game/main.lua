-- =============================================================
-- Copyright Roaming Gamer, LLC. 2009-2015
-- =============================================================
-- =============================================================
-- main.lua
-- =============================================================

----------------------------------------------------------------------
--  Misc Configuration & Initialization
----------------------------------------------------------------------
display.setStatusBar(display.HiddenStatusBar)  
system.activate("multitouch")
io.output():setvbuf("no") 
math.randomseed(os.time());

----------------------------------------------------------------------
--	Requires
----------------------------------------------------------------------
local ssk 		= require "ssk.loadSSK"
local common 	= require "scripts.common"

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
local game 		= require "scripts.game"

-- Start the game and the numbered level.
game.create( 1 )

-- Load level again to test auto-destroy and (re-) create
--timer.performWithDelay( 3000, function() game.create( 1 ) end )