-- colorPicker Library for Corona SDK
-- Copyright (c) 2014 Jason Schroeder
-- http://www.jasonschroeder.com
-- http://www.twitter.com/schroederapps

--[[ Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE. ]]--

local colorPicker = {}

------------------------------------------------------------------------------------
-- DECLARE SCREEN POSITION VARIABLES
------------------------------------------------------------------------------------
local centerX = display.contentCenterX
local centerY = display.contentCenterY
local screenTop = display.screenOriginY
local screenLeft = display.screenOriginX
local screenBottom = display.screenOriginY+display.actualContentHeight
local screenRight = display.screenOriginX+display.actualContentWidth
local screenWidth = screenRight - screenLeft
local screenHeight = screenBottom - screenTop

------------------------------------------------------------------------------------
-- FORWARD DECLARE LOCAL VARIABLES
------------------------------------------------------------------------------------
local group, background, colorBox, overlay, colorBar, boxSize, boxNode, blur, alphaBar, alphaNode, preview
local R, G, B, A = 1, 0, 0, 1
local barR, barG, barB = 1, 0, 0
local barColors = {
	{1, 0, 0},	-- red
	{1, 0, 1},	-- magenta
	{0, 0, 1},	-- blue
	{0, 1, 1},	-- cyan
	{0, 1, 0},	-- green
	{1, 1, 0},	-- yellow
	{1, 0, 0}	-- red (again)
}

------------------------------------------------------------------------------------
-- UPDATE SELECTED COLOR BASED ON NODE POSITIONS:
------------------------------------------------------------------------------------

local function updateColor()
	local target = colorBox
	local w, h = colorBox.width, colorBox.height
	
	local boxNodeX, boxNodeY = boxNode:localToContent(0,0)
	local boxLeft, boxTop = target:localToContent(-w*.5,-h*.5)
	local deltaX = boxNodeX - boxLeft
	local deltaY = boxNodeY - boxTop
	if deltaX<0 then deltaX = 0; elseif deltaX>w then deltaX = w end
	if deltaY<0 then deltaY = 0; elseif deltaY>h then deltaY = h end
	deltaX = (deltaX/w)
	deltaY = 1-(deltaY/h)
    local gray, t = (1 - deltaX) * deltaY, deltaX * deltaY
 
	R = (gray + t * barR)
	G = (gray + t * barG)
	B = (gray + t * barB)
	
	alphaBar.gradient.color1 = {R, G, B, 0}
	alphaBar.gradient.color2 = {R, G, B, 1}
	alphaBar.fill = alphaBar.gradient
	
	preview:setFillColor(R, G, B, A)
end
	
------------------------------------------------------------------------------------
-- HANDLE COLOR BOX TOUCH EVENTS
------------------------------------------------------------------------------------
local function boxTouch(event)
	local phase = event.phase
	local target = event.target
	local x, y = colorBox:contentToLocal(event.x, event.y)
	if x < -boxSize*.5 then
		x = -boxSize*.5
	elseif x > boxSize * .5 then
		x = boxSize * .5
	end
	if y < -boxSize*.5 then
		y = -boxSize*.5
	elseif y > boxSize * .5 then
		y = boxSize * .5
	end

	if phase == "began" then
		target.touchBegan = true
		display.getCurrentStage():setFocus(target, event.id)
		boxNode.x, boxNode.y = x, y
		updateColor(event)
	elseif phase == "moved" and target.touchBegan then
		boxNode.x, boxNode.y = x, y
		updateColor(event)
	elseif phase == "cancelled" or phase == "ended" then
		target.touchBegan = false
		display.getCurrentStage():setFocus(nil, nil)
		updateColor(event)
	end
	
	return true
end

------------------------------------------------------------------------------------
-- HANDLE COLOR BAR TOUCH EVENTS
------------------------------------------------------------------------------------
local function barTouch(event)
	local target = event.target
	local phase = event.phase
	local h = target.height
	local _, topOfBar = target:localToContent(0,-h*.5)
	local deltaY = event.y - topOfBar
	local barX, barY = target.parent:contentToLocal(event.x, event.y)
	
	if deltaY<0 then
		deltaY = 0
	elseif deltaY > target.height then
		deltaY = target.height
	end
	
	if barY < (-h * .5) + (barNode.height * .5) then
		barY = (-h * .5) + (barNode.height * .5)
	elseif barY > (h * .5) - (barNode.height * .5) then
		barY = (h * .5) - (barNode.height * .5)
	end

	
	local function setPosition()
		local dh = h / 6
		local q = math.floor(deltaY/dh)
		local r = deltaY - q * dh
		if q<6 then
			local r1, g1, b1 = unpack(barColors[q + 1])
			local r2, g2, b2 = unpack(barColors[q + 2])
			local t = r / dh
			local s = 1 - t

			barR, barG, barB = s * r1 + t * r2, s * g1 + t * g2, s * b1 + t * b2
		
			colorBox.gradient.color1 = {barR, barG, barB}
			colorBox.fill = colorBox.gradient
		end
	end

	if phase == "began" then
		target.touchBegan = true
		display.getCurrentStage():setFocus(target, event.id)
		barNode.y = barY
		setPosition()
		updateColor()
	elseif phase == "moved" and target.touchBegan then
		barNode.y = barY
		setPosition()
		updateColor()
	elseif phase == "cancelled" or phase == "ended" then
		barNode.y = barY
		target.touchBegan = false
		display.getCurrentStage():setFocus(nil, nil)
	end
	return true
end

------------------------------------------------------------------------------------
-- HANDLE ALPHA BAR TOUCH EVENTS
------------------------------------------------------------------------------------
local function alphaTouch(event)
	local target = event.target
	local phase = event.phase
	local w = target.width * .5
	local x, y = target.parent:contentToLocal(event.x, event.y)
	local barLeft, _ = target:localToContent(-w,0)
	local barRight, _ = target:localToContent(w,0)
	
	if x < -w + (alphaNode.width * .5) then
		x = -w + (alphaNode.width * .5)
	elseif x > w - (alphaNode.width * .5) then
		x = w - (alphaNode.width * .5)
	end
	
	local nodePosition = (event.x - barLeft) / (barRight - barLeft)
	if nodePosition < 0 then
		nodePosition = 0
	elseif nodePosition > 1 then
		nodePosition = 1
	end

	if phase == "began" then
		target.touchBegan = true
		display.getCurrentStage():setFocus(target, event.id)
		A = nodePosition
		alphaNode.x = x
		updateColor()
	elseif phase == "moved" and target.touchBegan then
		A = nodePosition
		alphaNode.x = x
		updateColor()
	elseif phase == "cancelled" or phase == "ended" then
		A = nodePosition
		alphaNode.x = x
		updateColor()
		target.touchBegan = false
		display.getCurrentStage():setFocus(nil, nil)
	end
	return true
end

------------------------------------------------------------------------------------
-- SET NODE POSITIONS BASED ON RGBA VALUES
------------------------------------------------------------------------------------ 
 
local function setColor (r, g, b, a)
	
	local function FindBarColor (r, g, b)
		local function IsEqual (x, y)
			return math.abs(x - y) < 1e-3
		end

		local function BarPos (base, t)
			return (base + t) / 6
		end
	
		if IsEqual(r, 1) then
			if g > 0 then
				return BarPos(5, 1 - g)
			else
				return BarPos(0, b)
			end
		elseif IsEqual(g, 1) then
			if b > 0 then
				return BarPos(3, 1 - b)
			else
				return BarPos(4, r)
			end
		else
			if r > 0 then
				return BarPos(1, 1 - r)
			else
				return BarPos(2, g)
			end
		end
	end
 
	local function getNodePositions (r, g, b)
		local t, u, v
		local RGB = {}

		if r == g and g == b then
			RGB[1], RGB[2], RGB[3] = 1, 0, 0
			t, u, v = 0, 0, 1 - r

		else
			RGB[1], RGB[2], RGB[3] = r, g, b
			local ri, bi = 1, 1

			for i = 2, 3 do
					ri = RGB[i] > RGB[ri] and i or ri
					bi = RGB[i] < RGB[bi] and i or bi
			end

			local gi = 6 - (ri + bi)
			r, g, b = RGB[ri], RGB[gi], RGB[bi]
			u, v = (r - b) / r, 1 - r
			RGB[ri], RGB[gi], RGB[bi] = 1, (g - b) / (r - b), 0
			t = FindBarColor(unpack(RGB))
		end

		return t, u, v
	end

	-- get positions for colorBox & colorBar nodes:
	local t, u, v = getNodePositions(r, g, b)
	
	-- set barNode position and tint colorBox accordingly:
	local barPosition = t * colorBar.height
	local dh = colorBar.height / 6
	local q = math.floor(barPosition/dh)
	local r = barPosition - q * dh
	local r1, g1, b1 = unpack(barColors[q + 1])
	local r2, g2, b2 = unpack(barColors[q + 2])
	local z = r / dh
	local s = 1 - t
	barR, barG, barB = s * r1 + z * r2, s * g1 + z * g2, s * b1 + z * b2
	colorBox.gradient.color1 = {barR, barG, barB}
	colorBox.fill = colorBox.gradient
	local barTop = colorBar.y - colorBar.height * .5
	barNode.y = barTop + barPosition
	
	-- set boxNode in the correct position:
	local boxLeft, boxTop = colorBox.x - colorBox.width * .5, colorBox.y - colorBox.height * .5
	boxNode.x, boxNode.y = boxLeft + u * colorBox.width, boxTop + v * colorBox.height
	
	-- set alphaNode in the correct position:
	local alphaLeft = alphaBar.x - alphaBar.width * .5
	alphaNode.x = alphaLeft + A * alphaBar.width
	
	-- adjust barNode & alphaNode position if they are at the extreme end of the bar
	if barNode.y < (-colorBar.height * .5) + (barNode.height * .5) then
		barNode.y = (-colorBar.height * .5) + (barNode.height * .5)
	elseif barNode.y > (colorBar.height * .5) - (barNode.height * .5) then
		barNode.y = (colorBar.height * .5) - (barNode.height * .5)
	end
	
	if alphaNode.x < (-alphaBar.width * .5) + (alphaNode.width * .5) then
		alphaNode.x = (-alphaBar.width * .5) + (alphaNode.width * .5)
	elseif alphaNode.x > (alphaBar.width * .5) - (alphaNode.width * .5) then
		alphaNode.x = (alphaBar.width * .5) - (alphaNode.width * .5)
	end
	
end

------------------------------------------------------------------------------------
-- SHOW COLOR PICKER
------------------------------------------------------------------------------------
function colorPicker.show(listener, r, g, b, a)

	-- function to close the picker and return color values to the listener function
	local function closePicker()
		local function removeGroup()
			display.remove(group)
			group = nil
			display.remove(blur)
			blur = nil
		end
	
		transition.to(blur, {alpha = 0})
		transition.to(group, {y = centerY + screenHeight, alpha = 0, onComplete = removeGroup})
	
		if listener~=nil then listener(R, G, B, A) end
		return true
	end
	
	-- set default r, g, b, & a values if not defined
	if r==nil then r = 1 end
	if g==nil then g = 0 end
	if b==nil then b = 0 end
	if a==nil then a = 1 end
	R, G, B, A = r, g, b, a

	-- let's dim & blur the scene underneath our picker
	blur = display.captureScreen()
	blur.x, blur.y = centerX, centerY
	blur:setFillColor(.4,.4,.4)
	blur.fill.effect = "filter.blur"
	blur.alpha = 0
	blur:addEventListener("tap", closePicker)
	blur:addEventListener("touch", function() return true end)

	if screenWidth<screenHeight then
		boxSize = screenWidth*.4
	else
		boxSize = screenHeight*.4
	end
	
	-- create a display group to contain the picker
	group = display.newGroup()
		group.x, group.y = centerX - boxSize*.075, centerY + screenHeight
		group.alpha = 0
	
	-- create a bounding box for the picker
	background = display.newRoundedRect(group, 0, 0, boxSize*1.75, boxSize*1.65, boxSize/5)
		background:setFillColor(.85, .85, .85)
		background.x, background.y = boxSize*.075, boxSize*.075
		background:setStrokeColor(0,0,0,.6)
		background.strokeWidth = boxSize*.04
	background:addEventListener("touch", function() return true end)
	background:addEventListener("tap", function() return true end)
	
	-- create the "color box" where we will fine-tune our selected color
	colorBox = display.newRect(group, 0, 0, boxSize, boxSize)
		colorBox.x, colorBox.y = 0, 0
	colorBox.gradient = {
		type = "gradient",
		color1 = { barR, barG, barB },
		color2 = { 1, 1, 1 },
		direction = "left"
	}
	colorBox.fill = colorBox.gradient
	colorBox:addEventListener("touch", boxTouch)
	colorBox:addEventListener("tap", boxTouch)

	overlay = display.newRect(group, 0, 0, colorBox.width, colorBox.height)
		overlay.x, overlay.y = colorBox.x, colorBox.y
	overlay.gradient = {
		type = "gradient",
		color1 = { 1, 1, 1 },
		color2 = { 0, 0, 0 },
		direction = "down"
	}
	overlay.fill = overlay.gradient
	overlay.blendMode = "multiply"
	
	boxNode = display.newCircle(group, 0, 0, boxSize/30)
		boxNode:setFillColor(0, 0, 0, 0)
		boxNode:setStrokeColor(.85, .85, .85)
		boxNode.strokeWidth = boxSize/80

	-- create the "color bar" where we can tint the color box
	colorBar = display.newGroup()
		group:insert(colorBar)
		colorBar.x = boxSize*.65
	for i = 1, 6 do
		local gradient = {
			type = "gradient",
			color1 = barColors[i],
			color2 = barColors[i+1],
			direction = "down"
		}
		local rect = display.newRect(colorBar, 0, 0, boxSize*.15, boxSize/6)
			rect.anchorX, rect.anchorY = .5, 0
			rect.x, rect.y = 0, -boxSize*.5+(rect.height*(i-1))
			rect.fill = gradient
	end
	colorBar:addEventListener("touch", barTouch)
	colorBar:addEventListener("tap", barTouch)
	
	barNode = display.newRect(group, 0, 0, boxSize * .16, boxSize * .03)
		barNode.x, barNode.y = colorBar.x, 0
		barNode:setFillColor(1, 1, 1, .5)
		barNode:setStrokeColor(1, 1, 1)
		barNode.strokeWidth = boxSize/80
	
	--create the "alpha bar" used to set opacity
	alphaBar = display.newRect(group, 0, 0, boxSize, boxSize*.15)
	alphaBar.x, alphaBar.y = 0, boxSize*.65
	alphaBar.gradient = {
			type = "gradient",
			color1 = {R, G, B, 0},
			color2 = {R, G, B, 1},
			direction = "right"
		}
	alphaBar.fill = alphaBar.gradient
	
	alphaBar:addEventListener("touch", alphaTouch)
	alphaBar:addEventListener("tap", alphaTouch)
	
	alphaNode = display.newRect(group, 0, 0, boxSize * .03, boxSize * .16)
		alphaNode.x, alphaNode.y = 0, alphaBar.y
		alphaNode:setFillColor(1, 1, 1, .5)
		alphaNode:setStrokeColor(1, 1, 1)
		alphaNode.strokeWidth = boxSize/80
	
	-- create a preview dot to show our selected color
	preview = display.newCircle(group, boxSize * .65, boxSize * .65, boxSize/12)
		preview:setFillColor(R, G, B, A)
	
	-- bring in the picker
	setColor(R,G,B,A)
	transition.to(blur, {alpha=1})
	transition.to(group, {y = centerY - boxSize*.075, alpha = 1})
end

return colorPicker