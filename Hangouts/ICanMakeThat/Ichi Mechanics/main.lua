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

require "ssk.loadSSK"

--[[
--local sample = require "sample1" -- Wrong
--local sample = require "sample2" -- Right
local sample = require "sample3" -- Combined
sample.run()
--]]


--[[
local talk = require "talk" -- Bumper Details
-- 1 block
-- 2 big tri
-- 3 Collision point
-- 4 Fix
-- 5 Better
-- 6 Even better
-- 7 Ichi

talk.run( 7, false ) -- arg1: 1..6, arg2: hybrid render
--]]


----[[
local editor = require "editor" -- Rudimentary level editor
editor.run()
--]]