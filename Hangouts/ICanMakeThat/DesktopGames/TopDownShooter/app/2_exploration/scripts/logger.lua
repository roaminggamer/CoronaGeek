local json = require "json"
local _print = _G.print

local logFont 

local systemFonts = native.getFontNames()
table.sort(systemFonts)

-- Display each font in the Terminal/console
for i, fontName in ipairs( systemFonts ) do
	local tmp = fontName
	tmp = fontName:gsub( "% ", "" )
	tmp = tmp:gsub( "%-", "" )
	--print( i, fontName, tmp)
	if( tmp:lower() == "courier" ) then
		logFont = fontName
	elseif( tmp:lower() == "couriernew" ) then
		logFont = fontName
	end
end

_print("\n============================================")
_print("Selected logFont == ", logFont )
_print("============================================\n")



local logger = {}

logger._print = _print

logger.data = {}

_G.print = function( ... )

	local inString = ""	
	for i = 1, #arg do
		local dataToShow = arg[i] 
		local resultType = type(dataToShow)
		--_print( "ARG", i, resultType )
		
		if resultType == "table" then
			--_print(i, "In Table convert")
			dataToShow = table.toString(dataToShow,true)
		--elseif( resultType == "boolean" ) then
			--dataToShow = tostring( dataToShow )
		--elseif( resultType == "number" ) then
			--dataToShow = tostring( dataToShow )
		elseif( resultType ~= "string" ) then
			dataToShow = tostring( dataToShow )
		else
			local jsonDecoded = json.decode(dataToShow)
			if jsonDecoded ~= nil then
				--_print(i, "In Other convert")
				dataToShow = table.toString(dataToShow,true)
			
			else 
				--_print(i, "In String no-convert")	
			end
		end
		--_print(i, type(dataToShow), resultType )
		if( inString:len() > 0 ) then
			inString = inString .. " " .. dataToShow
		else
			inString = string.format( "%6.6d : %s" , system.getTimer(), dataToShow )
		end
	end
	--_print("BOB" , inString )

	logger.data[#logger.data + 1] = inString 

	if( #logger.data > 200 ) then
		table.remove(logger.data,1)
	end

	--[[
	local inString = ""	
	for i = 1, #arg do		
		--_print("BOB" , i, arg[i] )

	end
	--]]
	
	_print( unpack(arg) )
end

function logger.purge()
	logger.data = {}
end

-- Doesn't work if called too soon
function logger.hide()
	_print("logger.hide()", logger.doHide)
	if( logger.doHide ) then
		logger.doHide()
	end
end

--------------------------------------------------------------------------------
-- CONVERT TABLE TO STRING
-- From Jason Schroeder's Twitter Demo
-- http://www.jasonschroeder.com/
--------------------------------------------------------------------------------
local frontGroup = display.newGroup()
function logger.showCurrentLogs( dataToShow )
	display.remove(frontGroup)
	frontGroup = display.newGroup()
	local resultType = type(dataToShow)
	local json = require "json"
	local widget = require("widget")

	local accumHeight = 0

	if resultType == "table" then
		dataToShow = table.toString_old(dataToShow,true)
	else
		local jsonDecoded = json.decode(dataToShow)
		if jsonDecoded ~= nil then
			dataToShow = table.toString_old(dataToShow,true)
		else
			local text = dataToShow
			dataToShow = {text}
		end
	end
	
	local scrollView = widget.newScrollView({
		width = fullw - 100,
		height = fullh - 100,
		topPadding = 15,
		bottomPadding = 15,
		leftPadding = 15,
		rightPadding = 15,
		x = centerX,
		y = bottom + fullh,
		horizontalScrollDisabled = true,
	})
	scrollView:addEventListener("tap", function() return true end)
	frontGroup:insert(1, scrollView)

	local textObjects = {}

	for i = 1, #dataToShow do
		local text 		= display.newText({
			text 		= dataToShow[i],
			width 		= scrollView.contentWidth - 60,
			font 		= logFont,
			fontSize 	= 14,
		})
		text.anchorX, text.anchorY = 0, 0
		text.x = 30
		if textObjects[i-1] then
			text.y = textObjects[i-1].y + textObjects[i-1].height
		else
			text.y = 0
		end
		scrollView:insert(text)
		text:setFillColor(0)
		textObjects[i] = text
		accumHeight = accumHeight + text.contentHeight
	end

	if( accumHeight > scrollView.contentHeight ) then
		scrollView:scrollTo( "bottom", { time = 1500 } )
	end

	local blackout = display.newRect(frontGroup, centerX, centerY, fullw, fullh)
	blackout:setFillColor(0, 0, 0, .6)
	blackout.alpha = 0
	blackout.isHitTestable = true

	function logger.doHide()
		_print("closing")

		local function remove()
			display.remove(blackout)
			display.remove(scrollView)
		end

		local function part4()
			scrollView:toBack()
			transition.to(scrollView, {y = bottom + fullh, time = 800, transition = easing.inOutSine, onComplete = remove})
		end

		local function part3()
			transition.to(blackout, { alpha = 0, time = 300, transition = easing.inOutSine})
			transition.to(scrollView, {y = top + fullh*.25, time = 300, transition = easing.inOutSine, onComplete = part4})
		end

		if blackout.alpha == 1 then
			blackout.tap = function() return true end
			part3()
		end
		--logger.doHide = nil

		logger.isOpen = false
		return true
	end
	blackout.tap = logger.doHide
	blackout:addEventListener("tap")
	blackout:addEventListener("touch", function() return true end)

	local function part2()
		scrollView:toFront()
		transition.to(scrollView, {y = centerY, time = 300, transition = easing.inOutSine, onComplete = part3})
		transition.to(blackout, {alpha = 1})
	end

	transition.to(scrollView, {y = top + fullh*.25, time = 800, transition = easing.inOutSine, onComplete = part2})
end


logger.isOpen = false
logger.ignoringOpenHide = false

function logger.show()
	-- Prevent open-close spamming
	--
	if( logger.ignoringOpenHide ) then 
		--_print("SPAM @ ".. system.getTimer())
		return 
	end
	logger.ignoringOpenHide = true
	timer.performWithDelay( 2000,
		function()
			logger.ignoringOpenHide = false
		end )


	-- Already open?  Close it
	if( logger.isOpen ) then 
		--_print("CLOSE @ ".. system.getTimer())
		logger.hide()
		return 
	end

	-- Open it.
	--_print("OPEN @ ".. system.getTimer())
	--print("")
	--print("")
	logger.isOpen = true
	logger.showCurrentLogs( logger.data )
end


local unhandledErrorListener = function( event )
    print("unhandledError:\n", event.errorMessage)
    --table.print_r( event )
end
Runtime:addEventListener( "unhandledError", unhandledErrorListener )

return logger