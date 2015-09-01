-- =============================================================
-- Copyright Roaming Gamer, LLC. 2009-2014 
-- =============================================================
-- 
-- =============================================================
local common 	= require "scripts.common"

local builder = {}

-- =============================================
-- The Builder (Create) Function
-- =============================================
function builder.create( layers, data, pieces )
	local aPiece

	-- Create an object (basic or pretty) to represent this world object
	--
	if( common.niceGraphics ) then
		aPiece = display.newImageRect( layers.content, "images/kenney/coin.png", common.pickupSize, common.pickupSize )
		aPiece.x = data.x
		aPiece.y = data.y
	else
		aPiece = display.newCircle( layers.content, data.x, data.y, common.pickupSize/2 )
		aPiece.strokeWidth = 4
		aPiece:setStrokeColor(0,0,0)
	end

	-- This type of object is not placed on the grid, but at an offset from the grid (up, right, down, or left).
	-- Calculated and apply this offset.
	--
	local base = common.blockSize -- + common.pickupSize
	local offset = {}
	offset[1] = { 0, -base}
	offset[2] = { base, 0}
	offset[3] = { 0, base}
	offset[4] = { -base, 0}
	aPiece.x = aPiece.x + offset[data.subtype][1]
	aPiece.y = aPiece.y + offset[data.subtype][2]


	-- Add a physics body to our world object and use the appropriate filter from the 'collision calculator'
	--
	local physics = require "physics"
	physics.addBody( aPiece, "static", 
		             { density = 1, bounce = 0, friction = 1, radius = 3*common.pickupSize/4,
		               filter = common.myCC:getCollisionFilter( "pickup" ) } )

	-- Tip: This object collides with player, but does not 'respond' to that collision, so it is a sensor.
	--
	aPiece.isSensor = true

	-- Add a basic collision listener and dispatch and event when it occurs, then remove this object from the world
	--
	aPiece.collision = function( self, event )
		print("CHA-CHING!")
		post( "onSFX", { sfx = "coin1" } )
		-- Tip: We're only handling the first phase of the collision, so remove listener right away.
		self:removeEventListener( "collision" )
		Runtime:dispatchEvent( { name = "onPickup" } )
		timer.performWithDelay(1, function() display.remove(self) end ) -- Remove the object
		return true
	end
	aPiece:addEventListener( "collision" )

	-- Return a reference to this object 
	--
	return aPiece
end

return builder