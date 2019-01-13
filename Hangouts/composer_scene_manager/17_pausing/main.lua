-- =============================================================
-- main.lua
-- =============================================================

----------------------------------------------------------------------
--	1. Requires
----------------------------------------------------------------------
-- http://docs.coronalabs.com/daily/api/library/composer/index.html
local composer 	= require "composer" 

require "scripts.pushButtonClass"
require "scripts.toggleButtonClass"


----------------------------------------------------------------------
--	2. Initialization
----------------------------------------------------------------------
io.output():setvbuf("no") 
display.setStatusBar(display.HiddenStatusBar)  

----------------------------------------------------------------------
-- 3. Execution
----------------------------------------------------------------------
composer.gotoScene( "ifc.splash" )
--composer.gotoScene( "ifc.mainMenu" )
--composer.gotoScene( "ifc.playGUI" )
