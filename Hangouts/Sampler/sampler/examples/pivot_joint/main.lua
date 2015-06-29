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


-- 1. A function to build pivot joint examples
-- ==
--		createPivot () - Pivot joint sample
-- ==
createPivot = function( pivotGroup, x, y )
	-- Create a static object to anchor to
	--
	local anchor = display.newCircle( pivotGroup, x, y, 10 )
	anchor.isVisible = false
	physics.addBody( anchor, "static", { filter = filter, radius = 0.05 } )
	
	-- Create a block with a dynamic body
	--
	local block  = display.newRect( pivotGroup, 0, 0, 80, 80 )
	block.x = x
	block.y = y
	block :setFillColor( 1, 1, 0 )
	
	physics.addBody( block , "dynamic", { density = 1, friction = 0.5 } )
	
	block.linearDamping = 1
	block.angularDamping = 1
	block.isSleepingAllowed = false

	-- Mount the 'block' to the anchor
	--
	physics.newJoint( "pivot", anchor, block, x, y )

	-- Attach a label that will follow the object
	--
	helpers.addNameLabel( pivotGroup, block, "Pivot")

	return block
end

-- 2. Create Some Pivot Examples
local example = createPivot( group, display.contentCenterX, display.contentCenterY)


-- 3. Add dragger touch handler
helpers.addDragger( example )
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

