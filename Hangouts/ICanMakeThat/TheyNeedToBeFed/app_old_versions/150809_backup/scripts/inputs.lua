-- =============================================================
-- Copyright Roaming Gamer, LLC. 2009-2015 
-- =============================================================
-- 
-- =============================================================
local common 	= require "scripts.common"

local inputs = {}


--
-- Translate the button touch into a globally visible event with the name specified in
-- 'myEvent' field of the button we pressed.
--
local function onTouch( self, event ) 

	if( event.phase == "began" ) then
		-- Grab all future 'moved' inputs and send them here, regardless of whether
		-- they are on the button or not. i.e. swipes that go off the button
		-- will still be sent to the button, till the finger is lifted.
		--
		display.getCurrentStage():setFocus(self,event.id)
		self.isFocus = true		

		-- Highlight button to show it is being touched
		--
		self.indicator:setFillColor( 1, 1, 0 )
		self.indicator.alpha = 0.5

		-- Send out 'global' event to other listeners
		Runtime:dispatchEvent( { name = self.myEvent,  phase = event.phase, time = event.time } )		

		return true
	
	elseif( self.isFocus ) then
		-- Calculations to see if touch is on button or not.
		--
		local bounds = self.stageBounds
		local isWithinBounds = 
			bounds.xMin <= event.x and 
			bounds.xMax >= event.x and 
			bounds.yMin <= event.y and 
			bounds.yMax >= event.y

		-- If touch strays outside of button area, remove highlight.
		--
		if( isWithinBounds ) then
			self.indicator:setFillColor( 1, 1, 0 )
			self.indicator.alpha = 0.5
		else
			self.indicator:setFillColor( 1, 1, 1 )
			self.indicator.alpha = 0.25
		end

		-- If the finger is lifted, clear the focus and remove highlight
		--
		if( event.phase == "ended") then
			display.getCurrentStage():setFocus(self,nil)
			self.isFocus = false		
			self.indicator:setFillColor( 1, 1, 1 )
			self.indicator.alpha = 0.25
		end
		
		-- Send out 'global' event to other listeners
		Runtime:dispatchEvent( { name = self.myEvent,  phase = event.phase, time = event.time } )		
		return true
	end	
	return false
end


function inputs.create( layers, data )

	local size = common.buttonSize

	-- Run Left Button
	--
	local leftButton = display.newRoundedRect( layers.overlay, common.left + size/2 + 20, bottom - size/2 - 20, size, size, 12 )
	leftButton.strokeWidth = 3
	leftButton:setFillColor( 0, 0, 0, 0.1 )
	leftButton.myEvent = "onLeft"
	leftButton.touch = onTouch
	leftButton:addEventListener( "touch" )
	leftButton.indicator = display.newImageRect( layers.overlay, "images/up.png",  size * 0.8, size * 0.8 )
	leftButton.indicator.x = leftButton.x - 5
	leftButton.indicator.y = leftButton.y
	leftButton.indicator.rotation = -90
	leftButton.indicator.alpha = 0.25

	-- Run Right Button
	--
	local rightButton = display.newRoundedRect( layers.overlay, leftButton.x + size + 40, leftButton.y, size, size, 12 )
	rightButton.strokeWidth = 3
	rightButton:setFillColor( 0, 0, 0, 0.1 )
	rightButton.myEvent = "onRight"
	rightButton.touch = onTouch
	rightButton:addEventListener( "touch" )
	rightButton.indicator = display.newImageRect( layers.overlay, "images/up.png",  size * 0.8, size * 0.8 )
	rightButton.indicator.x = rightButton.x + 5
	rightButton.indicator.y = rightButton.y
	rightButton.indicator.rotation = 90
	rightButton.indicator.alpha = 0.25

	-- Jump Button
	--
	local jumpButton = display.newRoundedRect( layers.overlay, common.right - size/2 - 20, leftButton.y, size, size, 12 )
	jumpButton.strokeWidth = 3
	jumpButton:setFillColor( 0, 0, 0, 0.1 )
	jumpButton.myEvent = "onJump"
	jumpButton.touch = onTouch
	jumpButton:addEventListener( "touch" )
	jumpButton.indicator = display.newImageRect( layers.overlay, "images/up.png",  size * 0.8, size * 0.8 )
	jumpButton.indicator.x = jumpButton.x
	jumpButton.indicator.y = jumpButton.y
	jumpButton.indicator.rotation = 0
	jumpButton.indicator.alpha = 0.25
end

return inputs