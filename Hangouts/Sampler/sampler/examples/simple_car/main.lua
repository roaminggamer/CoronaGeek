-- =============================================================
-- Copyright Roaming Gamer, LLC. 2009-2015
-- =============================================================
-- 
-- =============================================================
-- 
-- =============================================================
local physics 		= require "physics"
local carBuilder 	= require("carBuilder")
local groundBuilder	= require("groundBuilder")
local easyButton	= require("easyButton")

physics.start()
physics.setGravity( 0, 0 )
--physics.setDrawMode( "hybrid" )

local group = display.newGroup()

-- 1. Create the ground
groundBuilder.create( group )

-- 2. Create the car
local car = carBuilder.create( group, display.contentCenterX, display.contentCenterY - 100 )

-- 3. Create three images to use as buttons
local gravityB = display.newImageRect( group, "up.png", 64, 64 )
gravityB.x = display.contentWidth - 48
gravityB.y = display.contentHeight - 128
gravityB.rotation = 180

local leftB = display.newImageRect( group, "up.png", 64, 64 )
leftB.x = display.contentWidth - 160
leftB.y = display.contentHeight - 32
leftB.rotation = -90

local rightB = display.newImageRect( group, "up.png", 64, 64 )
rightB.x = display.contentWidth - 64
rightB.y = display.contentHeight - 32
rightB.rotation = 90	

-- 4. Three functions to call when the buttons are touched
local function onGravity( event )
	local gx,gy = physics.getGravity()
	if( gy == 0 ) then
		physics.setGravity( 0, 10 )
	else
		physics.setGravity( 0, 0 )
	end
end

local function onLeft( event )
	if( event.phase == "began" ) then
		car:setLeftWheelSpeed( 500 )
	elseif( event.phase == "ended" ) then
		car:setLeftWheelSpeed( 0 )
	end	
end

local function onRight( event )
	if( event.phase == "began" ) then
		car:setRightWheelSpeed( -750 )
	elseif( event.phase == "ended" ) then
		car:setRightWheelSpeed( 0 )
	end	
end


-- 5. Turn the images into buttons
easyButton.easyToggle( gravityB, onGravity )
easyButton.addTouch( leftB, onLeft )
easyButton.addTouch( rightB, onRight )