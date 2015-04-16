local ced = require "scripts.caseErrorDetect"
ced.promoteToError()


math.randomseed(os.time());


local ssk 		= require "ssk.loadSSK"
local game 		= require "scripts.game"
local soundM	= require "scripts.sound"


display.setStatusBar(display.HiddenStatusBar)  -- Hide that pesky bar
io.output():setvbuf("no") -- Don't use buffer for console messages

soundM.init()
game.create()