io.output():setvbuf("no") 
display.setStatusBar(display.HiddenStatusBar)  


local composer 	= require "composer" 

gameFont = native.systemFont
require "ssk.loadSSK"

local init  = require "init"
init.run()


composer.gotoScene( "test1" )
