-- =============================================================
-- Copyright Roaming Gamer, LLC. 2009-2015
-- =============================================================
-- 
-- =============================================================
local misc = {}

if( not _G.ssk ) then
	_G.ssk = {}
end
_G.ssk.misc = misc

local socket		= require "socket"
local getTimer		= system.getTimer
local strGSub		= string.gsub
local strSub		= string.sub
local strFormat 	= string.format
local mFloor		= math.floor
local angle2Vector	= ssk.math2d.angle2Vector
local scaleVec		= ssk.math2d.scale



-- ==
--		noErrorAlerts(	) - Turns off those annoying error popups! :)
-- ==
function misc.noErrorAlerts()
	Runtime:hideErrorAlerts( )
end

misc.isConnectedToWWW = function( url )
	local url = url or "www.google.com" 
	local hostFound = true
	local con = socket.tcp()
	con:settimeout( 2 ) -- Timeout connection attempt after 2 seconds
						
	-- Check if socket connection is open
	if con:connect(url, 80) == nil then 
			hostFound = false
	end

	return hostFound
end

-- ==
--		func() - what it does
-- ==
function misc.secondsToTimer( seconds, version )	
	local seconds = seconds or 0
	version = version or 1

	if(version == 1) then
		seconds = tonumber(seconds)
		local minutes = math.floor(seconds/60)
		local remainingSeconds = seconds - (minutes * 60)

		local timerVal = "" 

		if(remainingSeconds < 10) then
			timerVal =	minutes .. ":" .. "0" .. remainingSeconds
		else
			timerVal = minutes .. ":"	.. remainingSeconds
		end

		return timerVal
	elseif( version == 2 ) then
		seconds = tonumber(seconds)
		local nHours = string.format("%02.f", mFloor(seconds/3600));
		local nMins = string.format("%02.f", mFloor(seconds/60 - (nHours*60)));
		local nSecs = string.format("%02.f", mFloor(seconds - nHours*3600 - nMins *60));
		return nHours..":"..nMins.."."..nSecs

	elseif( version == 3 ) then
		local nDays = 0
		seconds = tonumber(seconds)
		local nHours = string.format("%02.f", mFloor(seconds/3600));
		local nMins = string.format("%02.f", mFloor(seconds/60 - (nHours*60)));
		local nSecs = string.format("%02.f", mFloor(seconds - nHours*3600 - nMins *60));

		nHours = tonumber(nHours)
		nMins = tonumber(nMins)
		
		while (nHours >= 24) do
			nDays = nDays + 1
			nHours = nHours - 24
		end

		return nDays,nHours,nMins,nSecs 
	end
end

function misc.easyUnderline( obj, color, strokeWidth, extraWidth, yOffset )
		color = color or { 1,1,1,1 }
		strokeWidth = strokeWidth or 1
		extraWidth = extraWidth or 0
		yOffset = yOffset or 0
		local lineWidth = obj.contentWidth + extraWidth
		local x = obj.x - lineWidth/2
		local y = obj.y + obj.contentHeight/2 + strokeWidth + yOffset
		local line = display.newLine( obj.parent, x, y, x + lineWidth, y )
		line:setStrokeColor( unpack(color) )
		line.strokeWidth = strokeWidth
		return line
end

function misc.quickLine( group, x, y, len, color, strokeWidth, yOffset )
		color = color or { 1,1,1,1 }
		strokeWidth = strokeWidth or 1
		extraWidth = extraWidth or 0
		yOffset = yOffset or 0
		local line = display.newLine( group, x, y + yOffset , x + len, y + yOffset )
		line:setStrokeColor( unpack(color) )
		line.strokeWidth = strokeWidth
		return line
end

misc.normRot = function( obj )
	while( obj.rotation >= 360 ) do obj.rotation = obj.rotation - 360 end
	while( obj.rotation < 0 ) do obj.rotation = obj.rotation + 360 end
end

misc.normRot2 = function( rotation )
	while( rotation >= 360 ) do rotation = rotation - 360 end
	while( rotation < 0 ) do rotation = rotation + 360 end
	return rotation
end


-- ==
--		pushDisplayDefault() / popDisplayDefault()- 
-- ==
local defaultValues = {}
function misc.pushDisplayDefault( defaultName, newValue )
	if( not defaultValues[defaultName] ) then defaultValues[defaultName] = {} end
	local values = defaultValues[defaultName]
	values[#values+1] = display.getDefault( defaultName )
	display.setDefault( defaultName, newValue )
end

function misc.popDisplayDefault( defaultName )
	if( not defaultValues[defaultName] ) then defaultValues[defaultName] = {} end
	local values = defaultValues[defaultName]
	if(#values == 0) then return end

	local tmp = values[#values]
	values[#values] = nil
	display.setDefault( defaultName, tmp )
end


misc.fitText = function( obj, origText, maxWidth )
	origText = origText or ""
	local textLen = string.len( origText )
	while(obj.contentWidth > maxWidth and textLen > 1 ) do
			textLen = textLen - 1
			obj.text = shortenString( origText, textLen, "..." )
			--if( textLen < 12 ) then
				-- return
			--end
	end	
end

misc.getImageSize = function ( path, basePath )
	basePath = basePath or system.ResourceDirectory
	local tmp = display.newImage( path, basePath, 10000,10000 )
	local sx = tmp.contentWidth
	local sy = tmp.contentHeight
	display.remove(tmp)
	return sx,sy
end


-- Rotate object about point
misc.rotateAbout = function( obj, x, y, params	)	
		
	x = x or display.contentCenterX
	y = y or display.contentCenterY
	params = params or {}
		
	local radius		= params.radius or 50
	obj._pathRot		= params.startA or 0
	local endA			= params.endA or (obj._pathRot + 360 )
	local time			= params.time or 1000
	local delay 		= params.delay or 0
	local myEasing		= params.myEasing or easing.linear
	local debugEn		= params.debugEn

	-- Start at right position
	local vx,vy = angle2Vector( obj._pathRot )
	vx,vy = scaleVec( vx, vy, radius )
	obj.x = x + vx 
	obj.y = y + vy

	-- remove 'enterFrame' listener when we finish the transition.
	obj.onComplete = function( self )
		if(params.onComplete) then 
			params.onComplete( obj )
		end
		Runtime:removeEventListener( "enterFrame", self )
	end

	-- Update position every frame
	obj.enterFrame = function ( self )
		local vx,vy = angle2Vector( self._pathRot )
		vx,vy = scaleVec( vx, vy, radius )
		self.x = x + vx 
		self.y = y + vy

		if( debugEn ) then
			local tmp = display.newCircle( self.parent, self.x, self.y, 1 )
			tmp:toBack()
		end
	end
	Runtime:addEventListener( "enterFrame", obj )

	-- Use transition to change the angle (gives us access to nice effects)
	transition.to( obj, { _pathRot = endA, delay = delay, time = time, transition = myEasing, onComplete = obj } )
end

-- Editing tool to easily position objects
--
misc.addEasyPositioner = function( obj )
	obj.touch = function( self, event )
		local target  = event.target
		local eventID = event.id

		if(event.phase == "began") then
			display.getCurrentStage():setFocus( target, eventID )
			target.isFocus = true
			target._x0 = target.x
			target._y0 = target.y

		elseif(target.isFocus) then
			local dx = event.x - event.xStart
			local dy = event.y - event.yStart
			target.x = target._x0 + dx
			target.y = target._y0 + dy

			if(event.phase == "ended" or event.phase == "cancelled") then
				display.getCurrentStage():setFocus( nil, eventID )
				target.isFocus = false
				print(self.x, self.y)
			end
		end
	end; obj:addEventListener( "touch" )
end


-- Easy Mem/FPS Meter
--
misc.createEasyMeter = function( x , y, width, fontSize )
	x = x or centerX
	y = y or centerY
	width = width or 200
	fontSize = fontSize or 11
	local group = display.newGroup()	

	local hudFrame = display.newRect( group, x, y, width, 30)
	hudFrame:setFillColor(0.2,0.2,0.2)
	hudFrame:setStrokeColor(1,1,0)
	hudFrame.strokeWidth = 2

	local mMemLabel = display.newText( group, "", 40, hudFrame.y, native.systemFont, fontSize )
	mMemLabel:setFillColor(1,0.4,0)
	mMemLabel.anchorX = 1

	local tMemLabel = display.newText( group, "", 40, hudFrame.y, native.systemFont, fontSize )
	tMemLabel:setFillColor(0.2,1,0)
	tMemLabel.anchorX = 0

	hudFrame.touch = function( self, event )
		local target  = event.target
		local eventID = event.id

		if(event.phase == "began") then
			display.getCurrentStage():setFocus( target, eventID )
			target.isFocus = true
			target._x0 = target.x
			target._y0 = target.y

		elseif(target.isFocus) then
			local dx = event.x - event.xStart
			local dy = event.y - event.yStart
			target.x = target._x0 + dx
			target.y = target._y0 + dy

			if(event.phase == "ended" or event.phase == "cancelled") then
				display.getCurrentStage():setFocus( nil, eventID )
				target.isFocus = false
			end
		end
	end; hudFrame:addEventListener( "touch" )
	
	hudFrame.enterFrame = function( self )
		if( group.removeSelf == nil) then
			ignore( "enterFrame", hudFrame )
			return
		end
		-- Fill in current main memory usage
		collectgarbage("collect") -- Collect garbage every frame to get 'true' current memory usage
		local mmem = collectgarbage( "count" ) 
		mMemLabel.text = "M: " .. round(mmem/(1024),4) .. " MB"
		mMemLabel.x = hudFrame.x - 10
		mMemLabel.y = hudFrame.y

		-- Fill in current texture memory usage
		local tmem = system.getInfo( "textureMemoryUsed" )
		tMemLabel.text = "T: " .. round(tmem/(1024 * 1024),4) .. " MB"
		tMemLabel.x = hudFrame.x + 10
		tMemLabel.y = hudFrame.y
		group:toFront()
	end; listen( "enterFrame", hudFrame )
	return group
end

-- Easy Blur
--
misc.easyBlur = function( group, time, color )
	group = group or display.getCurrentStage()
	time = time or 0
	color = color or {0.5,0.5,0.5}
	local blur = display.captureScreen()
	blur.x, blur.y = centerX, centerY
	blur:setFillColor(unpack(color))
	blur.fill.effect = "filter.blur"
	blur.alpha = 0
	group:insert( blur )
	blur:addEventListener("touch", 
		function( event ) 
			if( event.phase == "ended" or event.phase == "cancelled" ) then
				transition.to( blur, { alpha = 0, time = time, onComplete = display.remove } )
			end
			return true 
		end )
	transition.to( blur, { alpha = 1, time = time } )
	return blur
end

-- Easy Shake
--
-- Derived from this: http://forums.coronalabs.com/topic/53736-simple-shake-easing-code-and-demo/
misc.easyShake = function( obj, amplitude, time )
	local shakeEasing = function(currentTime, duration, startValue, targetDelta)
		local shakeAmplitude = amplitude -- maximum shake in pixels, at start of shake
		local timeFactor = (duration-currentTime)/duration -- goes from 1 to 0 during the transition
		local scaledShake =( timeFactor*shakeAmplitude)+1 -- adding 1 prevents scaledShake from being less then 1 which would throw an error in the random code in the next line
		local randomShake = math.random(scaledShake)
		return startValue + randomShake - scaledShake*0.5 -- the last part detracts half the possible max shake value so the shake is "symmetrical" instead of always being added at the same side
	end -- shakeEasing
	transition.to(obj , {time = time, x = obj.x, y = obj.y, transition = shakeEasing} ) -- use the displayObjects current x and y as parameter
end

-- Easy alert popup
--
-- title - Name on popup.
-- msg - message in popup.
-- buttons - table of tables like this:
-- { { "button 1", opt_func1 }, { "button 2", opt_func2 }, ...}
--
misc.easyAlert = function( title, msg, buttons )

	local function onComplete( event )
		local action = event.action
		local index = event.index
		if( action == "clicked" ) then
			local func = buttons[index][2]
			if( func ) then func() end 
	    end
	    --native.cancelAlert()
	end

	local names = {}
	for i = 1, #buttons do
		names[i] = buttons[i][1]
	end
	print( title, msg, names, onComplete )
	local alert = native.showAlert( title, msg, names, onComplete )
end


-- Rudimentary 'is valid format' e-mail check
--
misc.isValidEmail = function( val, debugEn )

	if( debugEn ) then
		print( val, string.len(val), string.match( val, "@" ), #val:split("@") )
	end
	if( not val or string.len(val) == 0 ) then return false end
	if( string.match( val, "@" ) == nil ) then return false end
	val = val:split("@") 
	if(#val<2) then return false end
	return true
end

-- temporarily block touches
--
misc.blockTouchesForDuration = function( duration, subtle )
	local blocker = newRect( nil, centerX, centerY, { w = fullw, h = fullh, fill = _K_, alpha = 0 , isHitTestable = true} )
	local upAlpha = 0.5
	if(subtle) then upAlpha = 0 end
	transition.to(blocker, { alpha = upAlpha, time = 350 } )
	--local loading = makeThrobber( display.currentStage, centerX, centerY )
	--if(subtle) then loading.isVisible = false end

	blocker.enterFrame = function( self )
		if( not self.toFront ) then
			ignore("enterFrame", self)
			return
		end
		self:toFront()
		loading:toFront()
	end
	blocker.touch = function() return true end
	blocker:addEventListener( "touch" )

	blocker.timer = function(self)
		if( not self.removeSelf ) then return end
		local function onComplete()
			if( not self.removeSelf ) then return end
			ignore("enterFrame", blocker)
			blocker:removeEventListener( "touch" )
			display.remove(blocker)
			display.remove(loading)
		end
		transition.to( blocker, { alpha = 0, time = 250, onComplete = onComplete } )		
	end
	timer.performWithDelay( duration, blocker )
end

-- temporarily block touches
--
misc.easyRemoteImage = function( curImg, fileName, imageURL, baseDirectory ) 
	--print(curImg, fileName, imageURL )
	--table.dump(curOrder)

	baseDirectory = baseDirectory or system.TemporaryDirectory

	if( string.match( imageURL, "http" ) == nil ) then
		imageURL =  "http:" .. imageURL
	end

	if( io.exists( fileName, baseDirectory ) ) then
		curImg.fill = { type = "image", baseDir = baseDirectory, filename = fileName }
		return
	end

	local function networkListener( event )
	    if ( event.isError ) then
	        --print( "Network error - download failed" )
	    elseif ( event.phase == "began" ) then
	        --print( "Progress Phase: began" )
	    elseif ( event.phase == "ended" ) then
	        --print( "Displaying response image file" )
	        curImg.fill = { type = "image", baseDir = event.response.baseDirectory, filename = event.response.filename }
	    end
	end

	local params = {}
	params.progress = false

	network.download(
	    imageURL,
	    "GET",
	    networkListener,
	    params,
	    fileName,
	    baseDirectory
	)
end





return misc