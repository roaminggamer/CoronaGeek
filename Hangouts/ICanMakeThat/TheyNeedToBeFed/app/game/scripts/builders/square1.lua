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
	local aPiece = display.newRect( layers.content, data.x, data.y, common.blockSize, common.blockSize  )
	aPiece.rotation = data.rotation
	aPiece.strokeWidth = 4
	aPiece:setStrokeColor(0,0,0)

	if( common.debugEn ) then	
		-- debug label to show distance to player
		aPiece.debugLabel = display.newText( layers.content, "TBD", data.x, data.y + common.blockSize/3, native.systemFontBold, 16 )
		aPiece.debugLabel:setFillColor(1,0,0)
	end

	local physics = require "physics"
	physics.addBody( aPiece, "static", { density = 1, bounce = 0, friction = 1 } )

	pieces[#pieces+1] = aPiece

	return aPiece
end

return builder