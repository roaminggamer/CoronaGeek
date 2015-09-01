--local ced = require "scripts.caseErrorDetect"
--ced.promoteToError()

-- =============================================================
-- main.lua
-- =============================================================
_G.gameFont = native.systemFont -- "FontName" 
math.randomseed(os.time());


----------------------------------------------------------------------
--	1. Requires
----------------------------------------------------------------------
-- http://docs.coronalabs.com/daily/api/library/composer/index.html
local composer 	= require "composer" 

local ssk 		= require "ssk.loadSSK"

require "scripts.pushButtonClass"
require "scripts.toggleButtonClass"


----------------------------------------------------------------------
--	2. Initialization
----------------------------------------------------------------------
-- Turn on debug output for composer + Various other settings
--
composer.isDebug = false
--composer.recycleOnLowMemory = false
--composer.recycleOnSceneChange = true

-- Print to console immediately.
--
io.output():setvbuf("no") 

-- Hide that pesky bar
--
display.setStatusBar(display.HiddenStatusBar)  

-- Need multi-touch?  Enable it now.
--
--system.activate("multitouch") 

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
-- 3. Execution
----------------------------------------------------------------------
composer.gotoScene( "ifc.splash" )
--composer.gotoScene( "ifc.mainMenu" )

