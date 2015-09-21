-- =============================================================
-- Copyright Roaming Gamer, LLC. 2009-2015 
-- =============================================================
-- 
-- =============================================================
local common 	= require "scripts.common"

local builder = {}

-- =============================================
-- The Builder (Create) Function
-- =============================================
function builder.create( layers, data )
	local aPiece

	-- Create an object (basic or pretty) to represent this world object
	--
	if( common.niceGraphics ) then
		aPiece = display.newImageRect( layers.content, "images/kenney/elementStone004.png", common.blockSize, common.blockSize )
		aPiece.x = data.x
		aPiece.y = data.y
		aPiece.indicator = display.newCircle( layers.content, data.x, data.y-1, common.blockSize/2 - 22 )
		aPiece.indicator:setFillColor(1,0,0)
		aPiece.indicator.strokeWidth = 4
		aPiece.indicator:setStrokeColor(0,0,0,0.5)
		aPiece:toFront()
	else
		aPiece = display.newCircle( layers.content, data.x, data.y, common.blockSize/2 )
		aPiece.strokeWidth = 4
		aPiece:setStrokeColor(0,0,0)
	end

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

	-- This is a platform object, so add it to the 'common.pieces' list.  The player scans this list for nearby 'gravity' objects.
	--
	common.pieces[#common.pieces+1] = aPiece

	-- This piece self-destructs 10 seconds after you jump on it
	--
	aPiece.collision = function( self, event )
		if( event.phase == "began" ) then
			aPiece:removeEventListener( "collision" )
			local function selfDestruct( obj )				
				local index = table.indexOf( common.pieces, self )				
				if( index ) then 
					print("GOODBYE CRUEL WORLD")
					table.remove( common.pieces, index )
					display.remove(self.indicator)
					transition.to( self, { alpha = 0, time = 250, onComplete = display.remove } )					
				end				
			end
			transition.to( aPiece.indicator, { alpha = 0.5,  time = 10000 } )	
			transition.to( aPiece.indicator, { xScale = 0.001,  yScale = 0.001, time = 10000, onComplete = selfDestruct } )	
		end
		return false
	end
	aPiece:addEventListener( "collision" )

	
	-- Return a reference to this object 
	--
	return aPiece
end

return builder