-- =============================================================
-- main.lua
-- =============================================================

----------------------------------------------------------------------
--	1. Requires
----------------------------------------------------------------------
-- http://docs.coronalabs.com/daily/api/library/composer/index.html
local composer 	= require "composer" 

require "scripts.pushButtonClass"
require "scripts.toggleButtonClass"


----------------------------------------------------------------------
--	2. Initialization
----------------------------------------------------------------------
-- Turn on debug output for composer + Various other settings
--
composer.isDebug = true
--composer.recycleOnLowMemory = false
--composer.recycleOnSceneChange = true

-- Print to console immediately.
--
io.output():setvbuf("no") 

-- Hide that pesky bar
--
display.setStatusBar(display.HiddenStatusBar)  

-- Need multi-touch?  Enable it now.
--
--system.activate("multitouch") 

--local physics = require "physics"
--physics.setGravity( 0, 10 )
--physics.setDrawMode( "hybrid" )


----------------------------------------------------------------------
-- 3. Execution
----------------------------------------------------------------------
local initialString = "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum." 
initialString = initialString .. " " .. initialString
initialString = initialString .. " " .. initialString
initialString = ""
local options = 
{
    --parent = textGroup,
    text = initialString,
    x = 5,
    y = 5,
    width = display.contentWidth - 20,  
    height = display.contentHeight - 10, 
    fontSize = 8,
    align = "left" 
}

local altConsole = display.newText( options )
altConsole.anchorX = 0
altConsole.anchorY = 0

local _print = print
_G.print = function( ... )
	local nextLine = ""
	for i = 1, #arg do
		nextLine = nextLine .. tostring( arg[i] )
	end
	nextLine = nextLine .. "\n"
	altConsole.text = altConsole.text .. nextLine
	_print( unpack(arg) )
end






local group = display.newGroup()
local function onStart( self, event ) 
	display.remove(group)
	group = nil
	composer.gotoScene( "ifc.scene1" )	
	return true
end
-- Create some buttons for navigation
local tmp = PushButton( group, display.contentWidth - 50, display.contentHeight - 50, "Start", onStart )
