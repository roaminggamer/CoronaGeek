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
		aPiece = display.newImageRect( layers.content, "images/kenney/elementMetal001.png", common.blockSize, common.blockSize )
		aPiece.x = data.x
		aPiece.y = data.y
	else
		aPiece = display.newCircle( layers.content, data.x, data.y, common.blockSize/2 )
		aPiece.strokeWidth = 4
		aPiece:setStrokeColor(0,0,0)
	end

	-- Make it invisible
	aPiece.alpha = 0

	-- If debug mode is enabled, add a label for showing 'distance to'
	--
	if( common.debugEn ) then	
		-- debug label to show distance to player
		aPiece.debugLabel = display.newText( layers.content, "TBD", data.x, data.y + common.blockSize/3, native.systemFontBold, 18 )
		aPiece.debugLabel:setFillColor(1,0,0)
	end

	-- Add a physics body to our world object and use the appropriate filter from the 'collision calculator'
	--
	local physics = require "physics"
	physics.addBody( aPiece, "static", 
		             { density = 1, bounce = 0, friction = 1, radius = common.blockSize/2,
		               filter = common.myCC:getCollisionFilter( "platform" ) } )


	aPiece.collision = function( self, event )
		if( event.phase == "began" and self.alpha == 0 ) then
			transition.to( self, { alpha = 1, time = 750, transition = easing.outBounce })
		end
		return false
	end

	aPiece:addEventListener( "collision" )


	-- This is a platform object, so add it to the 'pieces' list.  The player scans this list for nearby 'gravity' objects.
	--
	pieces[#pieces+1] = aPiece

	-- Return a reference to this object 
	--
	return aPiece
end

return builder