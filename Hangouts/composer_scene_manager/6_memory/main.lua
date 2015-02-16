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

local misc = require "scripts.misc"
require "scripts.extensions.io"
require "scripts.extensions.string"
require "scripts.extensions.table"


----------------------------------------------------------------------
--	2. Initialization
----------------------------------------------------------------------
-- Variables
local w = display.contentWidth
local h = display.contentHeight
local centerX = display.contentCenterX
local centerY = display.contentCenterY

-- Turn on debug output for composer + Various other settings
--
composer.isDebug = true
--composer.recycleOnLowMemory = false
composer.recycleOnSceneChange = true

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

misc.createEasyMeter( centerX, h - 20, w - 40, 12 )


local function doMemSink()
	timer.performWithDelay( 2000,
		function()
			require "memSink"
			--require "memSink"
			--require "memSink"
			--require "memSink"
		end )
end

local function createSceneEventListeners()
	local strMatch = string.match

	local prefix = {}
	prefix[1] = "empty"
	prefix[2] = "unmanaged local"
	prefix[3] = "managed local"
	prefix[4] = "scenegroup - no clear"
	prefix[5] = "scenegroup - clear"
	prefix[6] = "shared data 1 - A"
	prefix[7] = "shared data 1 - B"
	prefix[8] = "shared data 2 - A"
	prefix[9] = "shared data 2 - B"
	prefix[10] = "persistent data"

	local function onSceneEvent( self, event )
		if( event.sceneNum == self.sceneNum ) then
			local action 	= event.action	
			local sceneNum 	= self.sceneNum	
			local indicator = self
			local label 	= self.label
			
			if( strMatch( action, "create") ) then
				label.text = sceneNum .. " (" .. prefix[sceneNum] .. ") " .. action
				indicator:setFillColor( 0,1,0 )
			
			elseif( strMatch( action, "destroy") ) then
				label.text = sceneNum .. " (" .. prefix[sceneNum] .. ") " .. action
				indicator:setFillColor( 1,0,0 )
			end
		end		
	end

	for i = 1, 10 do
		local x = 12
		local y = i * 40 + 20
		local tmp = display.newCircle( x, y, 8 )
		tmp.sceneNum = i
		tmp.label = display.newText( i .. " (" .. prefix[i] .. ") Not loaded yet.", x + 10, y, native.systemFont, 8 )
		tmp.label.anchorX = 0
		tmp.onSceneEvent = onSceneEvent
		listen( "onSceneEvent", tmp )
	end
end

local function createSceneLoadingButtons()
	for i = 1, 10 do
		local x = 20
		local y = i * 40 + 20

		PushButton( sceneGroup, w- 50, y, "Scene " .. i, 
			        function() composer.gotoScene( "ifc.scene" .. i ) end, 
					{ labelColor = {0,0,0}, labelSize = 10, height = 30 } )
	end
end


----------------------------------------------------------------------
-- 3. Execution
----------------------------------------------------------------------
--doMemSink()

_G.testType = "Display Objects"
--_G.testType = "Lua Objects"

local label = display.newText( "Test Type: " .. testType, 10, 20, native.systemFont, 10 )
label.anchorX = 0 
label:setFillColor(0,1,1)


createSceneEventListeners()
createSceneLoadingButtons()

