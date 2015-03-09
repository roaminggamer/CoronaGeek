local ced = require "scripts.caseErrorDetect"
ced.promoteToError()

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
_G.gameFont = native.systemFont -- "FontName" 
math.randomseed(os.time());

----------------------------------------------------------------------
--	Requires
----------------------------------------------------------------------
local ssk 		= require "ssk.loadSSK"
local game 		= require "scripts.game"

----------------------------------------------------------------------
-- General Initialization
----------------------------------------------------------------------
display.setStatusBar(display.HiddenStatusBar)  -- Hide that pesky bar
--system.activate("multitouch")
io.output():setvbuf("no") -- Don't use buffer for console messages

-- Physics
--
physics.start()
physics.setGravity( 0, 0 )
--physics.setDrawMode( "hybrid" )

-- Android Settings
--
if ( system.getInfo("platformName") == "Android" ) then
	local androidVersion = string.sub( system.getInfo( "platformVersion" ), 1, 3)
	if( androidVersion and tonumber(androidVersion) >= 4.4 ) then
	  native.setProperty( "androidSystemUiVisibility", "immersiveSticky" )
	  --native.setProperty( "androidSystemUiVisibility", "lowProfile" )
	elseif( androidVersion ) then
	  native.setProperty( "androidSystemUiVisibility", "lowProfile" )
	end
end

-- Debug Stuff
--

-- Lock Globls (detect global creations beyond this point)
--local glock = require "scripts.global_lock"
--glock.lock( _G )

-- Meter Memory Usage
--ssk.misc.createEasyMeter( centerX, top + 20, fullw, 16)

----------------------------------------------------------------------
-- Declarations
----------------------------------------------------------------------
-- none. 

----------------------------------------------------------------------
-- Definitions
----------------------------------------------------------------------
-- none. 

----------------------------------------------------------------------
-- Execution
----------------------------------------------------------------------
game.init()

timer.performWithDelay( 1000, game.start )
--timer.performWithDelay( 2000, game.stop )
--timer.performWithDelay( 32000, game.cleanup )
	
