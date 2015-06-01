local lastFrame = 0
Runtime:addEventListener( "enterFrame", function() lastFrame = lastFrame + 1; end )
-- Touch listener that does lots of work w/o coalescing
--

local com 		= require "common"
local fakeWork 	= require "fakeWork"
local meter 	= require "meter"

local mRand 	= math.random
local getTimer 	= system.getTimer

local lastTime 	= getTimer()


local function onTouch( self, event )
	if(event.phase == "began" ) then
	   self.__lastFrame = lastFrame -- Grab frame count as touch starts
		lastTime = getTimer()
	
	elseif( event.phase == "moved" and lastFrame > self.__lastFrame ) then
		self.__lastFrame = lastFrame -- Grab new frame count

		fakeWork.run2(5 * 1e4)
		local r = mRand(10,500)/1000
		local g = mRand(10,500)/1000
		local b = mRand(10,500)/1000
		self:setFillColor( r,g,b )
		print(getTimer() - lastTime)
		lastTime 	= getTimer()

	elseif(event.phase == "ended") then
		self:setFillColor( 0, 0, 0 )

	end

	return false
end

local touchObj = display.newImageRect( "fillW.png", com.fullw, com.fullh )
touchObj.x = com.centerX
touchObj.y = com.centerY
touchObj:setFillColor(0,0,0)
touchObj:toBack()
touchObj.touch = onTouch
touchObj:addEventListener( "touch" )

