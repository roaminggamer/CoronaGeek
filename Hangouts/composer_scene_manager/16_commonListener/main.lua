-- =============================================================
-- main.lua
-- =============================================================
io.output():setvbuf("no") 
display.setStatusBar(display.HiddenStatusBar)  
-- =============================================================
local composer 	= require "composer" 
require "scripts.pushButtonClass"
require "scripts.toggleButtonClass"
composer.gotoScene( "ifc.scene1" )
