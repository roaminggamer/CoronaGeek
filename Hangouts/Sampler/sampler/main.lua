-- =============================================================
-- Copyright Roaming Gamer, LLC. 2009-2015
-- =============================================================
-- Physics Fun Sampler
-- =============================================================
-- 			
-- =============================================================
io.output():setvbuf("no") -- Don't use buffer for console messages
display.setStatusBar(display.HiddenStatusBar)  -- Hide that pesky bar

_G.details = {}
details.week = 26
details.year = 2015
details.questions = 10

_G.gameFont = native.systemFont
--_G.gameFont = "Abierta"

require "ssk.loadSSK"

require "presets.gel.presets"

local composer 	= require "composer" 

composer.gotoScene( "ifc.mainMenu1" )
