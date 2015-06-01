-- =============================================================
-- main.lua
-- =============================================================
io.output():setvbuf("no") 
display.setStatusBar(display.HiddenStatusBar)  

local meter = require "meter"
meter.create_fps()

--require "nowork"
--require "bad"
require "good"