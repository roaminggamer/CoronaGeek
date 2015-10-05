-- =============================================================
-- Copyright Roaming Gamer, LLC. 2009-2015 
-- =============================================================
-- 
-- =============================================================
local common 	= require "scripts.common"

local inputs = {}

local leftButton
local rightButton
local jumpButton
local fireButton


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
		--Runtime:dispatchEvent( { name = self.myEvent,  phase = event.phase, time = event.time } )		
		post( self.myEvent, {  phase = event.phase, time = event.time } )

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
		--Runtime:dispatchEvent( { name = self.myEvent,  phase = event.phase, time = event.time } )
		post( self.myEvent, {  phase = event.phase, time = event.time } )
		return true
	end	
	return false
end

--
-- Create and Initialize Input Objects (touch & key for debug)
--
function inputs.create( layers, data )

	local size = common.buttonSize

	-- Run Left Button
	--
	leftButton = display.newRoundedRect( layers.overlay, common.left + size/2 + 20, bottom - size/2 - 20, size, size, 12 )
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
	rightButton = display.newRoundedRect( layers.overlay, leftButton.x + size + 40, leftButton.y, size, size, 12 )
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
	jumpButton = display.newRoundedRect( layers.overlay, common.right - size/2 - 20, leftButton.y, size, size, 12 )
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


	-- Fire Button
	--
	fireButton = display.newRoundedRect( layers.overlay, common.right - 1.5 * size - 60, leftButton.y, size, size, 12 )
	fireButton.strokeWidth = 3
	fireButton:setFillColor( 0, 0, 0, 0.1 )
	fireButton.myEvent = "onFire"
	fireButton.touch = onTouch
	fireButton:addEventListener( "touch" )
	fireButton.indicator = display.newImageRect( layers.overlay, "images/kenney/particle.png",  size * 0.8, size * 0.8 )
	fireButton.indicator.x = fireButton.x
	fireButton.indicator.y = fireButton.y
	fireButton.indicator.rotation = 0
	fireButton.indicator.alpha = 0.25

end

--
-- Clear button references.
--
function inputs.destroy()
	-- Clear these references so garbage collection can clean them up when
	-- they are deleted.  

	-- Note: These are automatically deleted when game.lua removes top display group 'layers'.  However,
	-- we still need to clear the local variables
	leftButton = nil
	rightButton = nil
	jumpButton = nil
	fireButton = nil
end

-- Set up keyboard inputs to trigger buttons (for debug only)
--
-- This works as follows:
--   1. I listen for 'key' events on these keys: a,d,w,left,right,up,space
--   2. I ignore all other key inputs.
--   3. I convert the 'event' record for key inputs into an acceptable touch event.
--   4. I call the touch method on leftButton, rightButton, jumpButton, or fireButton depending on the key touched.
--   5. I pass the modified event into the touch method I'm calling.
--   6. The touch code does the rest of the lifting.  Done!
--
-- This table will be used to convert key phases to touch phases
local phaseConvert = {}
phaseConvert.down = "began"
phaseConvert.up   = "ended"

local function onLeftKey( event )
	if( not (event.descriptor == "a" or event.descriptor == "left" ) ) then
		return false
	end

	-- Verify button is still valid
	if( leftButton and leftButton.removeSelf ~= nil and leftButton.touch ) then
		-- Convert this key event into a useable touch event
		event.target = leftButton
		event.x = leftButton.x
		event.y = leftButton.y
		event.phase = phaseConvert[event.phase]
		leftButton:touch( event )
	end
	return true
end
Runtime:addEventListener( "key", onLeftKey )


local function onRight( event )
	if( not (event.descriptor == "d" or event.descriptor == "right" ) ) then
		return false
	end

	-- Verify button is still valid
	if( rightButton and rightButton.removeSelf ~= nil and rightButton.touch ) then
		-- Convert this key event into a useable touch event
		event.target = rightButton
		event.x = rightButton.x
		event.y = rightButton.y
		event.phase = phaseConvert[event.phase]
		rightButton:touch( event )
	end
	return true
end
Runtime:addEventListener( "key", onRight )

local function onJump( event )
	if( not (event.descriptor == "w" or event.descriptor == "up"  ) ) then
		return false
	end

	-- Verify button is still valid
	if( jumpButton and jumpButton.removeSelf ~= nil and jumpButton.touch ) then
		-- Convert this key event into a useable touch event
		event.target = jumpButton
		event.x = jumpButton.x
		event.y = jumpButton.y
		event.phase = phaseConvert[event.phase]
		jumpButton:touch( event )
	end
	return true
end
Runtime:addEventListener( "key", onJump )

local function onFire( event )
	if( event.descriptor ~= "space" ) then
		return false
	end

	-- Verify button is still valid
	if( fireButton and fireButton.removeSelf ~= nil and fireButton.touch ) then
		-- Convert this key event into a useable touch event
		event.target = fireButton
		event.x = fireButton.x
		event.y = fireButton.y
		event.phase = phaseConvert[event.phase]
		fireButton:touch( event )
	end
	return true
end
Runtime:addEventListener( "key", onFire )


return inputs