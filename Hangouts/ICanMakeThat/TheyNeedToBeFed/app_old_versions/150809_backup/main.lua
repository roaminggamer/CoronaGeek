--local ced = require "scripts.caseErrorDetect"
--ced.promoteToError()

-- =============================================================
-- Copyright Roaming Gamer, LLC. 2009-2015
-- =============================================================
-- =============================================================
-- main.lua
-- =============================================================
-- 
-- =============================================================

----------------------------------------------------------------------
--  Pre-Initialization 
----------------------------------------------------------------------
--_G.gameFont = "FontName"  -- defaults to: native.systemFont
math.randomseed(os.time());

----------------------------------------------------------------------
--	Requires
----------------------------------------------------------------------
local ssk 		= require "ssk.loadSSK"
local common 	= require "scripts.common"

----------------------------------------------------------------------
-- Initialization
----------------------------------------------------------------------
display.setStatusBar(display.HiddenStatusBar)  -- Hide that pesky bar
--system.activate("multitouch")
io.output():setvbuf("no") -- Don't use buffer for console messages

-- Physics
--
local physics = require "physics"
physics.start()
physics.setGravity( 0, 0 )
--physics.setDrawMode( "hybrid" )

----------------------------------------------------------------------
-- Start Game
----------------------------------------------------------------------
local game 		= require "scripts.game"

game.create( 1  )
