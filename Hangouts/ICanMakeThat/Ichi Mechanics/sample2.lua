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
local pieceSize 	= 40
local ballSize 		= 20
local ballSpeed 	= 100
local ballSize 		= 20
local ballRadius 	= 0.8 * ballSize/2
local sqrt2 		= math.sqrt(2)
local offset 		= sqrt2/2 * ballRadius
local bumperSize 	= 40 - 2 * offset


function sample.run( noPlayer )
	local layers = ssk.display.quickLayers( nil, "underlay", "content", "overlay")

	if( not noPlayer ) then
		physics.start()
		physics.setGravity(0,0)
		--physics.setDrawMode( "hybrid" )
	end

	local square = newImageRect( layers.content, centerX - 100, centerY + 100, 
		"images/square2.png", 
		{ size = pieceSize, alpha = isSensor and 0.5 or 1,
		  fill = isSensor and _P_ or _W_ },
		{ bodyType = "static", bounce = 1, friction = 0, isSensor = isSensor } )

	local tri2 = sample.drawBumper( layers.content, centerX + 100, centerY + 100 )
	local tri3 = sample.drawBumper( layers.content, centerX + 100, centerY - 100 )
	local tri4 = sample.drawBumper( layers.content, centerX - 100, centerY - 100 )
	
	tri2:setAngle( 270 )
	tri3:setAngle( 180 )
	tri4:setAngle( 90 )

	if( not noPlayer ) then
		newLine( layers.content, square.x, square.y, centerX + 100, centerY + 100, { strokeWidth = 4 } )
		newLine( layers.content, centerX + 100, centerY + 100, centerX + 100, centerY - 100, { strokeWidth = 4 } )
		newLine( layers.content, centerX + 100, centerY - 100, centerX - 100, centerY - 100, { strokeWidth = 4 } )
		newLine( layers.content, centerX - 100, centerY - 100, square.x, square.y, { strokeWidth = 4 } )
	end

	square:toFront()

	if( not noPlayer ) then
		local ball = newImageRect( layers.content, centerX - 100, centerY, "images/yellow_round.png",
				                   { size = ballSize }, 
				                   { radius = ballRadius, isFixedRotation = true, 
				                     bounce = 1, friction = 0, isBullet = true } )

		ball.touch = function( self, event ) 
			if( event.phase == "began" ) then
				ball:setLinearVelocity( 0, ballSpeed )
			end
			return true
		end
		ball:addEventListener( "touch" )
	end
end

-- Unified bumper drawing code w/ 'setAngle' method
--
function sample.drawBumper( group, x, y )

	local shape = 
	{ 
		-bumperSize/2, -bumperSize/2,
		bumperSize/2, bumperSize/2,
		-bumperSize/2, bumperSize/2,
	}

	local bumper = newImageRect( group, x-offset, y+offset, 
		"images/triangle2.png", 
		{ size = bumperSize }, 
		{ bodyType = "static", shape = shape, bounce = 1, friction = 0 } )


	function bumper.setAngle( self, angle ) -- angle == 0, 90, 180, 270 (ONLY!)
		if( angle < 0 ) then
			while( angle < 0 ) do angle = angle + 360 end
		end
		if( angle  >= 360 ) then
			while( angle >= 360 ) do angle = angle - 360 end			
		end

		self.rotation = angle

		if(angle == 0) then
			self.x = x - offset
			self.y = y + offset
		
		elseif(angle == 90) then
			self.x = x - offset
			self.y = y - offset

		elseif(angle == 180) then
			self.x = x + offset
			self.y = y - offset
		
		else
			self.x = x + offset
			self.y = y + offset
		end

	end

	return bumper
end

return sample