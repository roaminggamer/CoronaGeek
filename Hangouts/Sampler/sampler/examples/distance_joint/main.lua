-- =============================================================
-- Copyright Roaming Gamer, LLC. 2009-2015
-- =============================================================
-- 
-- =============================================================
-- 
-- =============================================================
local physics 		= require "physics"
local easyButton	= require("easyButton")
local helpers 		= require "helpers"

physics.start()
physics.setGravity( 0, 0 )
--physics.setDrawMode( "hybrid" )


local group = display.newGroup()


-- 1. A function to build rope joint examples
createDistance = function( distanceGroup, x, y )	
	-- Create a block with a dynamic body
	--
	local blockA = display.newRect( distanceGroup, 0, 0, 120, 80 )
	blockA.x = x
	blockA.y = y
	blockA :setFillColor( 1, 1, 0 )
	physics.addBody( blockA , "dynamic", { density = 1, friction = 0.5 } )
	blockA.linearDamping = 1
	blockA.angularDamping = 1
	blockA.isSleepingAllowed = false


	-- Create a block with a dynamic body
	--
	local blockB = display.newRect( distanceGroup, 0, 0, 120, 80 )
	blockB.x = x
	blockB.y = y + 300
	blockB :setFillColor( 1, 1, 0 )
	physics.addBody( blockB , "dynamic", { density = 1, friction = 0.5 } )
	blockB.linearDamping = 1
	blockB.angularDamping = 1
	blockB.isSleepingAllowed = false

	-- Mount the objects to each other with a distance joint
	--
	physics.newJoint( "distance", blockA, blockB, blockA.x, blockA.y, blockB.x, blockB.y )

	-- Attach a label that will follow the objects
	--
	helpers.addNameLabel( distanceGroup, blockA, "Distance A")
	helpers.addNameLabel( distanceGroup, blockB, "Distance B")

	return blockA, blockB
end


-- 2. Create Some Pivot Examples
local blockA, blockB = createDistance( group, display.contentCenterX, display.contentCenterY)


-- 3. Add dragger touch handler
helpers.addDragger( blockA )
helpers.addDragger( blockB )
helpers.setTouchJointForce( 1000 )

-- 4. Create three images to use as buttons
local gravityB = display.newImageRect( group, "up.png", 64, 64 )
gravityB.x = display.contentWidth - 48
gravityB.y = display.contentHeight - 128
gravityB.rotation = 180
	

-- 5. Three functions to call when the buttons are touched
local function onGravity( event )
	local gx,gy = physics.getGravity()
	if( gy == 0 ) then
		physics.setGravity( 0, 10 )
	else
		physics.setGravity( 0, 0 )
	end
end

-- 4. Turn the images into buttons
easyButton.easyToggle( gravityB, onGravity )

