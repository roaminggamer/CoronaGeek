-- =============================================================
-- Copyright Roaming Gamer, LLC. 2009-2015
-- =============================================================
-- 
-- =============================================================
-- 
-- =============================================================
local rootPath 		= _G.sampleRoot or ""

local physics 		= require "physics"
local carBuilder 	= require("carBuilder")
local groundBuilder	= require("groundBuilder")
local easyButton	= require("easyButton")
local helpers		= require("helpers")

physics.start()
physics.setGravity( 0, 0 )
physics.setDrawMode( "hybrid" )
physics.setContinuous( true )

local group = display.newGroup()

-- 1. Create a bridge
local sizeX = 20
local sizeY = 10
local numLinks = 30
local curX = display.contentCenterX - (numLinks * sizeX)/2 + sizeX/2
local curY = display.contentCenterY 
local last
local cur
for i = 1, numLinks do
	if( i == 1 or i == numLinks ) then
	--if( i == 1 ) then
		cur = helpers.createAnchor( group, curX, curY, sizeX, sizeY )
		cur:setFillColor(1,0,0)
	else
		cur = helpers.createBridgeLink( group, curX, curY, sizeX, sizeY )
		cur:setFillColor(0,1,1)
	end
	if( last ) then
		 helpers.connectBridgeParts( cur, last )
	end
	last = cur
	curX = curX + sizeX
end

-- 2. Create the car
local car = carBuilder.create(group, display.contentCenterX, display.contentCenterY - 100 )

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
		car:setLeftWheelSpeed( 1000 )
	elseif( event.phase == "ended" ) then
		car:setLeftWheelSpeed( 0 )
	end	
end

local function onRight( event )
	if( event.phase == "began" ) then
		car:setRightWheelSpeed( -1500 )
	elseif( event.phase == "ended" ) then
		car:setRightWheelSpeed( 0 )
	end	
end


-- 4. Turn the images into buttons
easyButton.easyToggle( gravityB, onGravity )
easyButton.addTouch( leftB, onLeft )
easyButton.addTouch( rightB, onRight )