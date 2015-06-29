-- =============================================================
-- Copyright Roaming Gamer, LLC. 2009-2015
-- =============================================================
-- 
-- =============================================================
-- 
-- =============================================================
local rootPath 		= _G.sampleRoot or ""

local physics 		= require "physics"

local builder = {}

function builder.create( group )
	local tmp = display.newRect( group, 0, 0, 500, 40 )
	tmp.x = display.contentCenterX
	tmp.y = display.contentCenterY
	tmp:setFillColor( 0.2, 0.2, 0.2 )
	physics.addBody( tmp, "static", { friction = 1 } )

	local tmp = display.newRect( group, 0, 0, 200, 40 )
	tmp.x = display.contentCenterX - 305
	tmp.y = display.contentCenterY - 25
	tmp.rotation = 15
	tmp:setFillColor( 0.2, 0.2, 0.2 )
	physics.addBody( tmp, "static", { friction = 1 } )

	local tmp = display.newRect( group, 0, 0, 200, 40 )
	tmp.x = display.contentCenterX + 305
	tmp.y = display.contentCenterY - 25
	tmp.rotation = -15
	tmp:setFillColor( 0.2, 0.2, 0.2 )
	physics.addBody( tmp, "static", { friction = 1 } )

end

return builder