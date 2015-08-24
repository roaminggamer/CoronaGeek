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
		aPiece = display.newImageRect( layers.content, "images/kenney/spikes.png", common.dangersSize, common.dangersSize/2 )
		aPiece.x = data.x
		aPiece.y = data.y		
		aPiece:setFillColor(1,0.25,0.25)
	else
		aPiece = display.newCircle( layers.content, data.x, data.y, common.dangersSize/2 )
		aPiece.strokeWidth = 4
		aPiece:setStrokeColor(0,0,0)
		aPiece:setFillColor(1,0,0)
	end

	-- This type of object is not placed on the grid, but at an offset from the grid (up, right, down, or left).
	-- Calculated and apply this offset and rotation.
	--
	local base = common.blockSize/2 + common.dangersSize/4 - 5
	local offset = {}
	offset[1] = { 0, -base, 0 }
	offset[2] = { base, 0, 90 }
	offset[3] = { 0, base, 180}
	offset[4] = { -base, 0, 270 }
	aPiece.x = aPiece.x + offset[data.subtype][1]
	aPiece.y = aPiece.y + offset[data.subtype][2]
	aPiece.rotation = offset[data.subtype][3]


	-- Add a physics body to our world object and use the appropriate filter from the 'collision calculator'
	--
	local physics = require "physics"
	physics.addBody( aPiece, "static", 
		             { density = 1, bounce = 0, friction = 1, --radius = common.dangersSize/2,
		               filter = common.myCC:getCollisionFilter( "dangers" ) } )

	-- Tip: Make sure dangers never overlay's platforms by pusing it to the back of the render layer it is in.
	aPiece:toBack()

	-- Tip: This object collides with player, but does not 'respond' to that collision, so it is a sensor.
	--
	aPiece.isSensor = true

	-- Add a basic collision listener and dispatch and event when it occurs, then remove this object from the world
	--
	aPiece.collision = function( self, event )
		print("NOM NOM!")
		-- Tip: We're only handling the first phase of the collision, so remove listener right away.
		self:removeEventListener( "collision" )
		timer.performWithDelay( 100, function()  Runtime:dispatchEvent( { name = "onReloadLevel" } )  end )
		return true
	end
	aPiece:addEventListener( "collision" )

	-- Return a reference to this object 
	--
	return aPiece
end

return builder