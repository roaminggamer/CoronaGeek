local ced = require "scripts.caseErrorDetect"
ced.promoteToError()


_G.gameFont = native.systemFont -- "FontName" 
math.randomseed(os.time());


require "scripts.pushButtonClass"
require "scripts.toggleButtonClass"
local composer 	= require "composer" 
local ssk 		= require "ssk.loadSSK"
local soundM	= require "scripts.sound"


io.output():setvbuf("no") 
display.setStatusBar(display.HiddenStatusBar)  
soundM.init()


composer.gotoScene( "ifc.splash" )
--composer.gotoScene( "ifc.mainMenu" )

