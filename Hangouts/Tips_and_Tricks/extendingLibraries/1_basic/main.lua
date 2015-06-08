-- =============================================================
-- main.lua
-- =============================================================
io.output():setvbuf("no") 
display.setStatusBar(display.HiddenStatusBar)  

-- Require 'extension' scripts
require "extensions.display"
require "extensions.string"
require "extensions.io"
require "extensions.table"


local function test_extended_display()
   local circ = display.newCircle( 100, 100, 10 )
   print( circ, "valid?", display.isValid( circ) )

   timer.performWithDelay( 1000, function() display.remove(circ) end )

   timer.performWithDelay( 2000, function() print( circ, "valid?", display.isValid( circ) ) end )
   
end
--test_extended_display()


local function test_extended_table()

	-- Load (or create) settings table
	local mySettings = table.load("mySettings.json") or {}
	table.dump( mySettings, nil, "---- mySettings after Load ")

	-- Increment (or initialize) score
  	mySettings.score = mySettings.score and (mySettings.score + 10) or 0
  	table.dump( mySettings, nil, "---- mySettings after increment. ")

  	-- Save settings
	table.save( mySettings, "mySettings.json" )

	print("-----------------------\n\n")

end
test_extended_table()

