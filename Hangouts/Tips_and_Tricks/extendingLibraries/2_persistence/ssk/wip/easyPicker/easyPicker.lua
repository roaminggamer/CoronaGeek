-- =============================================================
-- Copyright Roaming Gamer, LLC. 2009-2015
-- =============================================================
-- WIP
-- =============================================================
-- 								License
-- =============================================================
--[[
	> SSK is free to use.
	> SSK is free to edit.
	> SSK is free to use in a free or commercial game.
	> SSK is free to use in a free or commercial non-game app.
	> SSK is free to use without crediting the author (credits are still appreciated).
	> SSK is free to use without crediting the project (credits are still appreciated).
	> SSK is NOT free to sell for anything.
	> SSK is NOT free to credit yourself with.
]]
-- =============================================================

local easyPicker = {}
_G.ssk.easyPicker = easyPicker


-- Localizations
local mAbs              = math.abs
local mRand             = math.random
local getInfo           = system.getInfo
local getTimer          = system.getTimer
local strFind 			= string.find
local strMatch          = string.match
local strFormat         = string.format
local strGSub 			= string.gsub
local pairs             = pairs

-- Adjust these for proper scroll feel
--
local minDelta 	= 5
local spdBump 	= 500
local maxSpd 	= 3000
local maxDist 	= 15
local minSpeed	= 10

local function canMove( self )
	local objs = self.objs
	if( objs[1].y >= self.maxDist ) then return false end
	if( objs[#objs].y <= -self.maxDist ) then return false end
	return true
end

local function rebound( self )
	local maxDist = math.huge
	local nObj
	local objs = self.objs
	for k,v in pairs( objs ) do
		--local dy = mAbs(v.y-self.y)
		local dy = mAbs(v.y)
		if( dy < maxDist ) then
			maxDist = dy
			nObj = v
		end
	end

	local dy = -nObj.y	
	
	local onComplete = function( )
		self:scrollCB()
	end
	for i = 1, #objs do
		local obj = objs[i]
		transition.cancel(obj)

		if( i == #objs and self.scrollCB ) then
			transition.to( obj, { y = obj.y + dy, time = 250, transition = easing.outCirc, onComplete = onComplete })
		else
			transition.to( obj, { y = obj.y + dy, time = 250, transition = easing.outCirc } )
		end
	end		
end

local function autoScroll(self)
	if( self.removeSelf == nil ) then
		Runtime:removeEventListener( "enterFrame", self )
		return 
	end
	if( not self.scrolling ) then return end
	local time = getTimer()
	local dt = time - self.lastTime
	local spd = self.spd 
	self.spd = spd * 0.9
	self.lastTime = time

	local dy = (spd * dt)/1000
	--print(time, dt, round(spd,3), round(dy,6))

	local objs = self.objs
	for k,v in pairs( objs ) do
		v.y = v.y + dy
	end

	if( mAbs(self.spd) < self.minSpeed or not canMove( self ) ) then 
		self.spd = 0
		self.scrolling = false
		rebound(self)
		return 
	end
end


local onTouch = function( self, event )
	local phase 	= event.phase
	local id 		= event.id
	local yStart 	= event.yStart
	local time 		= getTimer() -- event.time
	if(phase == "began") then
		self.isFocus = true
		display.currentStage:setFocus( self, id )
		self.lastTime = time
		self.y0 = event.y
		self.dy = 0
		self.dt = 0
		self.spd = 0
		self.scrolling = false

	elseif( self.isFocus ) then
		if( phase == "moved" ) then
			if(time > self.lastTime) then
				self.dy = event.y - self.y0
				self.dt = time - self.lastTime			
				self.spd = self.dy/self.dt				
				self.lastTime = time
				self.y0 = event.y

				if( canMove( self ) ) then
					local objs = self.objs
					for k,v in pairs( objs ) do
						v.y = v.y + self.dy
					end
				end

			end
		elseif( phase == "ended" or phase == "cancelled" ) then
			self.isFocus = false
			display.currentStage:setFocus( self, nil )
			

			self.spd = self.spd * self.spdBump
			if(mAbs(self.spd) > self.maxSpd) then
				if(self.spd > 0) then
					self.spd = self.maxSpd
				else
					self.spd = -self.maxSpd
				end
			end

			--if(time - self.lastTime > 100 ) then
				--self.spd = 0
				--rebound(self)
			--else
				self.scrolling = true
			--end


			--print(math.abs(round(self.spd,3)), event.time, getTimer())
			--print("---------------------\n")
		end
	end

	return true
end

local function getValue( self )
	local objs = self.objs
	for k,v in pairs( objs ) do
		if(mAbs(v.y) <= self.minDelta) then 
			self.lastValue = v.myValue 
			self.lastIndex = v.index 
			return v.myValue,v.index 
		end
	end
	return self.lastValue, self.lastIndex
end

local function setValue( self, value )
	value = tostring(value)
	local target
	local objs = self.objs
	for k,v in pairs( objs ) do
		if(string.lower(tostring(value)) == string.lower(tostring(v.myValue))) then
			target = v 
		end
	end
	if( not target ) then return false end	
	local dy = -target.y

	for k,v in pairs( objs ) do
		v.y = v.y + dy
	end
	self.lastValue = target.myValue
	if( self.scrollCB ) then self:scrollCB() end
	return true
end

local function setIndex( self, index )
	local objs = self.objs
	--print(index,#objs)
	if( index > #objs ) then return false end
	local target = objs[index]
	if( not target ) then return false end	
	local dy = -target.y
	for k,v in pairs( objs ) do
		v.y = v.y + dy
	end
	self.lastValue = target.myValue
	if( self.scrollCB ) then self:scrollCB() end
	return true
end

local function init( self, params )
	self.group = display.newGroup()
	self.parent:insert( self.group )
	self.objs = {}
	local fontSize = params.fontSize or 10
	local fontColor = params.fontColor or _K_
	local entrySpacing = params.entrySpacing or 30
	local font = params.font or native.systemFont 
	self.curEntry = params.curEntry or 1
	for i = 1, #self.entries do

		local tmp
		if( params.entriesAreImages ) then
			tmp = display.newImageRect( self.group, self.entries[i], params.imgW or 40, params.imgH or 40 )
			tmp.x = 0
			tmp.y = (i-1) * (entrySpacing + tmp.contentHeight)
		else
			tmp = display.newText( self.group, self.entries[i], 0, (i-1) * entrySpacing, font, fontSize )
			tmp:setFillColor( unpack( fontColor ) )
		end
		self.objs[i] = tmp	
		tmp.myValue = self.entries[i]
		tmp.index = i			
	end
	self.group.x = self.x
	self.group.y = self.y

	local mask = graphics.newMask( params.maskImg or "ssk/wip/easyPicker/mask.png" )
	self.group:setMask( mask )
	if( params.maskImg ) then
		self.group.maskScaleX = self.contentWidth/params.maskW
		self.group.maskScaleY = self.contentHeight/params.maskH
	else
		self.group.maskScaleX = self.contentWidth/128
		self.group.maskScaleY = self.contentHeight/(32 - 4)
	end

	self.minDelta 	= params.minDelta or minDelta
	self.spdBump 	= params.spdBump or spdBump
	self.maxSpd 	= params.maxSpd or maxSpd
	self.maxDist 	= params.maxDist or maxDist
	self.minSpeed 	= params.minSpeed or minSpeed

	self.getValue 	= getValue
	self.setValue 	= setValue
	self.setIndex 	= setIndex
	self.lastValue 	= self:getValue()
	self.scrollCB 	= params.onSpin


	self.touch = onTouch
	self:addEventListener( "touch" )

	self.enterFrame = autoScroll
	Runtime:addEventListener("enterFrame", self)
end

easyPicker.create = function( group, obj, params )
	params = params or {}	
	local entries = params.entries or { 1,2,3,4,5,6,7,8,9,10,11,12 }
	obj.entries = entries
	obj.init = init
	obj:init( params )
end



return easyPicker