-- =============================================================
-- Your Copyright Statement Here, YYYY-YYYY
-- =============================================================
-- Splash Screen
-- =============================================================
local composer 		= require( "composer" )
local scene    		= composer.newScene()
local override 		= require "override"
----------------------------------------------------------------------
--								LOCALS								--
----------------------------------------------------------------------
-- Variables
local layers

-- Forward Declarations


-- Useful Localizations
-- SSK
--
local newCircle 	= ssk.display.newCircle
local newRect 		= ssk.display.newRect
local newImageRect 	= ssk.display.newImageRect
local newAngleLine 	= ssk.display.newAngleLine
local easyIFC   	= ssk.easyIFC
local oleft 		= ssk.misc.oleft
local oright 		= ssk.misc.oright
local otop 			= ssk.misc.otop
local obottom		= ssk.misc.obottom
local isInBounds    = ssk.easyIFC.isInBounds
local persist 		= ssk.persist
local isValid 		= display.isValid
local easyFlyIn 	= easyIFC.easyFlyIn

-- Corona & Lua
--
local mAbs              = math.abs
local mRand             = math.random
local mDeg              = math.deg
local mRad              = math.rad
local mCos              = math.cos
local mSin              = math.sin
local mAcos             = math.acos
local mAsin             = math.asin
local mSqrt             = math.sqrt
local mCeil             = math.ceil
local mFloor            = math.floor
local mAtan2            = math.atan2
local mPi               = math.pi

local getInfo           = system.getInfo
local getTimer          = system.getTimer
local strMatch          = string.match
local strFormat         = string.format
local pairs             = pairs

----------------------------------------------------------------------
--	Scene Methods
----------------------------------------------------------------------

----------------------------------------------------------------------
----------------------------------------------------------------------
function scene:create( event )
	local sceneGroup = self.view

	layers = ssk.display.quickLayers( sceneGroup, "underlay", "content", "overlay" )

	-- Create a simple background
	local back = newImageRect( layers.underlay, centerX, centerY, 
		                       --"images/paper_bkg.png",
		                       "images/back.png",
		                       { w = 320, h = 480, rotation = (w>h) and 90 or 0, scale = 2.25 } )


	-- Create a basic label
	local labelColor = hexcolor("#DAA520")
	local msg = "Corona Geek - Code Sampler"
	local tmp = easyIFC:quickLabel( layers.content, msg, centerX, top + 25, gameFont2, 42, labelColor )
	local tmp = easyIFC:quickLabel( layers.content, msg, tmp.x + 1, tmp.y + 1, gameFont2, 42, _K_ )

	local examples = 
	{
		{ "Simple Car", 		"simple_car", 		148, 	false, "http://github.com/roaminggamer/CoronaGeek/raw/master/Hangouts/Sampler/downloads/simple_car.zip" },
		{ "Pivot Joint", 		"pivot_joint", 		148, 	false, "http://github.com/roaminggamer/CoronaGeek/raw/master/Hangouts/Sampler/downloads/pivot_joint.zip" },
		{ "Rope Joint", 		"rope_joint", 		148, 	false, "http://github.com/roaminggamer/CoronaGeek/raw/master/Hangouts/Sampler/downloads/rope_joint.zip" },
		{ "Pulley Joint", 		"pulley_joint", 	148, 	false, "http://github.com/roaminggamer/CoronaGeek/raw/master/Hangouts/Sampler/downloads/pulley_joint.zip" },
		{ "Distance Joint", 	"distance_joint",	148, 	false, "http://github.com/roaminggamer/CoronaGeek/raw/master/Hangouts/Sampler/downloads/distance_joint.zip" },
		--{ "Fake Sample Using SSK", 	"TBD", 		148, 	true, "TBD" },
		{ "Future Topic", 		"TBD", 		999, 	false, "TBD" },
		{ "Future Topic", 		"TBD", 		999, 	false, "TBD" },
		{ "Future Topic", 		"TBD", 		999, 	false, "TBD" },
		{ "Future Topic", 		"TBD", 		999, 	false, "TBD" },
		{ "Future Topic", 		"TBD", 		999, 	false, "TBD" },
		{ "Future Topic", 		"TBD", 		999, 	false, "TBD" },
		{ "Future Topic", 		"TBD", 		999, 	false, "TBD" },
		{ "Future Topic", 		"TBD", 		999, 	false, "TBD" },
		{ "Future Topic", 		"TBD", 		999, 	false, "TBD" },
		{ "Future Topic", 		"TBD", 		999, 	false, "TBD" },
		{ "Future Topic", 		"TBD", 		999, 	false, "TBD" },
		{ "Future Topic", 		"TBD", 		999, 	false, "TBD" },
		{ "Future Topic", 		"TBD", 		999, 	false, "TBD" },
		{ "Future Topic", 		"TBD", 		999, 	false, "TBD" },
		{ "Future Topic", 		"TBD", 		999, 	false, "TBD" },
		{ "Future Topic", 		"TBD", 		999, 	false, "TBD" },
		{ "Future Topic", 		"TBD", 		999, 	false, "TBD" },
		{ "Future Topic", 		"TBD", 		999, 	false, "TBD" },
	}
	--local function compare(a,b)
		--return a[3] > b[3]
	--end
	--table.sort(examples,compare)

	local onPress = function( event )
		local runExample = _G.require
		override.doIt( "examples/" .. examples[event.target.num][2]  )
		runExample( "examples." .. examples[event.target.num][2] .. ".main" )
		layers.x = 100000
	end
	local onPress2 = function( event )
		system.openURL( examples[event.target.num][5] )
	end

	-- Create Examples Menu
	local bh = 45
	local bw1 = 350
	local bw2 = 45
	local startY = 50 + bh/2 + 2
	local curX = display.contentCenterX - bw1/2 - 10 - 50
	local curX2 = curX + bw1/2 + bw2/2 + 10
	local curY 	= startY
	local dY = bh + 2

	for i = 1, #examples do
		if( i == 13 ) then
			curY = startY
			curX = display.contentCenterX + bw1/2 + 10
			curX2 = curX + bw1/2 + bw2/2 + 10
		end

		local goB = easyIFC:presetPush( layers.content, "gel_4_1", curX, curY, bw1, bh, "  #" .. examples[i][3] .. " - " .. examples[i][1] .. " (" .. examples[i][2] .. ")", onPress, { labelHorizAlign = "left", labelSize = 16, labelColor = _Y_, labelOffset = { 0, 8 } } )
		goB.num = i

		local getB = easyIFC:presetPush( layers.content, "gel_1_3", curX2, curY, bw2, bh, "Get It", onPress2, { labelSize = 14  } )
		getB.num = i

		if(examples[i][4]) then
			newImageRect( layers.content, goB.x + bw1/2, goB.y - bh/2, "images/SSKCorona.png", { w = 188, h = 42, scale = 0.5, anchorX = 1, anchorY = 0 } )
		end

		curY = curY + dY
		
		if( examples[i][3] == 999 ) then goB:disable() end

	end
end

local toRun = ""
local function ON_KEY( event )
	if( event.phase == "up" ) then
		local key = event.descriptor
		if( tonumber(key) ) then
			toRun = toRun .. tostring(key)
		
		elseif( key == "enter" ) then
			local runExample = _G.require
			override.doIt( "example" .. tonumber(toRun) )
			runExample( "example" .. toRun .. ".main" )
			layers.x = 100000

		elseif( key == "deleteBack" ) then
			toRun = ""
		end
	end
	table.dump(event)
end; listen( "ON_KEY", ON_KEY )

----------------------------------------------------------------------
----------------------------------------------------------------------
function scene:willEnter( event )
	local sceneGroup = self.view
end
----------------------------------------------------------------------
----------------------------------------------------------------------
function scene:didEnter( event )
	local sceneGroup = self.view
end

----------------------------------------------------------------------
----------------------------------------------------------------------
function scene:willExit( event )
	local sceneGroup = self.view
end
----------------------------------------------------------------------
----------------------------------------------------------------------
function scene:didExit( event )
	local sceneGroup = self.view
end

----------------------------------------------------------------------
----------------------------------------------------------------------
function scene:destroy( event )
	local sceneGroup = self.view
end

----------------------------------------------------------------------
--				FUNCTION/CALLBACK DEFINITIONS						--
----------------------------------------------------------------------


---------------------------------------------------------------------------------
-- Scene Dispatch Events, Etc. - Generally Do Not Touch Below This Line
---------------------------------------------------------------------------------
function scene:show( event )
	local sceneGroup 	= self.view
	local willDid 	= event.phase
	if( willDid == "will" ) then
		self:willEnter( event )
	elseif( willDid == "did" ) then
		self:didEnter( event )
	end
end
function scene:hide( event )
	local sceneGroup 	= self.view
	local willDid 	= event.phase
	if( willDid == "will" ) then
		self:willExit( event )
	elseif( willDid == "did" ) then
		self:didExit( event )
	end
end
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )
---------------------------------------------------------------------------------
return scene
