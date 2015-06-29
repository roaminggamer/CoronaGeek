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


-- 1. A function to build pulley joint examples
createPulley = function( pulleyGroup, x, y, oy )	

	-- Optional y offset for anchorB
	oy = oy or 0

	-- Create markers for the pulley anchors
	local anchorA = display.newCircle( pulleyGroup, x - 150, y + oy, 2 )
	local anchorB = display.newCircle( pulleyGroup, x + 150, y + oy, 2 )

	-- Create a block with a dynamic body
	--
	local blockA = display.newRect( pulleyGroup, 0, 0, 80, 80 )
	blockA.x = anchorA.x
	blockA.y = anchorB.y + 150
	blockA :setFillColor( 1, 1, 0 )
	physics.addBody( blockA , "dynamic", { density = 1, friction = 0.5 } )
	blockA.linearDamping = 1
	blockA.angularDamping = 1
	blockA.isSleepingAllowed = false


	-- Create a block with a dynamic body
	--
	local blockB = display.newRect( pulleyGroup, 0, 0, 60, 60 )
	blockB.x = anchorB.x
	blockB.y = anchorB.y + 150
	blockB :setFillColor( 1, 1, 0 )
	physics.addBody( blockB , "dynamic", { density = 1, friction = 0.5 } )
	blockB.linearDamping = 1
	blockB.angularDamping = 1
	blockB.isSleepingAllowed = false

	-- Mount the objects to each other with a distance joint
	--
	local pulleyJoint = physics.newJoint( "pulley", blockA, blockB,
		                                  anchorA.x, anchorA.y,
		                                  anchorB.x, anchorB.y,
		                                  blockA.x, blockA.y,
		                                  blockB.x, blockB.y )
	pulleyJoint.ratio = 1


	-- Attach a label that will follow the objects
	--
	helpers.addNameLabel( pulleyGroup, blockA, "Pulley A")
	helpers.addNameLabel( pulleyGroup, blockB, "Pulley B")

	return blockA, blockB
end


-- 2. Create Some Pivot Examples
local blockA, blockB = createPulley( group, display.contentCenterX, display.contentCenterY, -200 )


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

