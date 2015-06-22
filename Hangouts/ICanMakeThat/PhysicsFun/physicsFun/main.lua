-- =============================================================
-- Copyright Roaming Gamer, LLC. 2009-2015
-- =============================================================
--                              License
-- =============================================================
--[[
    > This example is free to use.
    > This example is free to edit.
    > This example is free to use as the basis for a free or commercial game.
    > This example is free to use as the basis for a free or commercial non-game app.
    > This example is free to use without crediting the author (credits are still appreciated).
    > This example is NOT free to sell as a tutorial, or example of making jig saw puzzles.
    > This example is NOT free to credit yourself with.
]]
-- =============================================================
io.output():setvbuf("no") -- Don't use buffer for console messages
display.setStatusBar(display.HiddenStatusBar)  -- Hide that pesky bar

_G.gameFont = native.systemFont

require "ssk.loadSSK"

local composer 	= require "composer" 

local physics = require("physics")
physics.start()
--physics.setDrawMode( "hybrid" )

--composer.gotoScene( "ifc.template" )
--composer.gotoScene( "ifc.splash" )
composer.gotoScene( "ifc.mainMenu" )

--composer.gotoScene( "ifc.simple" )
--composer.gotoScene( "ifc.jointSampler" )
--composer.gotoScene( "ifc.doll" )
--composer.gotoScene( "ifc.posable" )
--composer.gotoScene( "ifc.car" )
--composer.gotoScene( "ifc.car2" ) -- not working yet

