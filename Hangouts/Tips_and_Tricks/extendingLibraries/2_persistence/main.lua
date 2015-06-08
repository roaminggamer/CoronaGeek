
display.setStatusBar(display.HiddenStatusBar)  -- Hide that pesky bar
io.output():setvbuf("no") -- Don't use buffer for console messages

gameFont = native.systemFont

require "ssk.loadSSK"

local init  = require "init"
local test1 = require "test1"
local test2 = require "test2"

-- Set up some default values
init.run()


print("\n --------------------- Test 1")
test1.run()

print("\n --------------------- Test 2")
test2.run()

print("\n --------------------- Test 1")
test1.run()

