-- =============================================================
-- Copyright Roaming Gamer, LLC. 2009-2015
-- =============================================================
--                              License
-- =============================================================
--[[
    > This example is free to use.
    > This example is free to edit.
    > This example is free to use as the basis for a free or commercial game.
    > This example is free to use as the basis for a free or commercial non-game app.
    > This example is free to use without crediting the author (credits are still appreciated).
    > This example is NOT free to sell as a tutorial, or example of making jig saw puzzles.
    > This example is NOT free to credit yourself with.
]]
-- =============================================================
local sample = {}

local physics 		= require "physics"

-- Localizations
--
local newCircle 	= ssk.display.newCircle
local newRect 		= ssk.display.newRect
local newImageRect 	= ssk.display.newImageRect
local easyIFC   	= ssk.easyIFC
local mRand 		= math.random
local isValid 		= display.isValid
local newAngleLine 	= ssk.display.newAngleLine
local newLine 		= ssk.display.newLine
local mAbs 			= math.abs

-- Locals
--
local pieceSize = 40
local ballSize 	= 20
local ballSpeed = 100


function sample.run( isSensor )
	local layers = ssk.display.quickLayers( nil, "underlay", "content", "overlay")

	physics.start()
	physics.setGravity(0,0)
	--physics.setDrawMode( "hybrid" )

	local square = newImageRect( layers.content, centerX - 100, centerY + 100, 
		"images/square2.png", 
		{ size = pieceSize, alpha = isSensor and 0.5 or 1,
		  fill = isSensor and _P_ or _W_ },
		{ bodyType = "static", bounce = 1, friction = 0, isSensor = isSensor } )

	local tri2 = newImageRect( layers.content, centerX + 100, centerY + 100, 
		"images/triangle2.png", 
		{ rotation = 270, size = pieceSize, alpha = isSensor and 0.5 or 1,
		  fill = isSensor and _P_ or _W_ },
		{ bodyType = "static", useOutline = true, bounce = 1, friction = 0, isSensor = isSensor } )

	local tri3 = newImageRect( layers.content, centerX + 100, centerY - 100, 
		"images/triangle2.png", 
		{ rotation = 180, size = pieceSize, alpha = isSensor and 0.5 or 1,
		  fill = isSensor and _P_ or _W_ },
		{ bodyType = "static", useOutline = true, bounce = 1, friction = 0, isSensor = isSensor } )

	local tri4 = newImageRect( layers.content, centerX - 100, centerY - 100, 
		"images/triangle2.png",
		{ rotation = 90, size = pieceSize, alpha = isSensor and 0.5 or 1,
		  fill = isSensor and _P_ or _W_ },
		{ bodyType = "static", useOutline = true, bounce = 1, friction = 0, isSensor = isSensor } )

	newLine( layers.content, square.x, square.y, tri2.x, tri2.y, { strokeWidth = 4 } )
	newLine( layers.content, tri2.x, tri2.y, tri3.x, tri3.y, { strokeWidth = 4 } )
	newLine( layers.content, tri3.x, tri3.y, tri4.x, tri4.y, { strokeWidth = 4 } )
	newLine( layers.content, tri4.x, tri4.y, square.x, square.y, { strokeWidth = 4 } )

	square:toFront()

	local ball = newImageRect( layers.content, centerX - 100, centerY, "images/yellow_round.png",
			                   { size = ballSize }, 
			                   { radius = ballSize/2, isFixedRotation = true, 
			                     bounce = 1, friction = 0, isBullet = true } )

	ball.touch = function( self, event ) 
		if( event.phase == "began" ) then
			ball:setLinearVelocity( 0, ballSpeed )
		end
		return true
	end
	ball:addEventListener( "touch" )
end

return sample