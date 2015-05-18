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
local newCircle 	= ssk.display.newCircle
local newRect 		= ssk.display.newRect
local newImageRect 	= ssk.display.newImageRect
local easyIFC   	= ssk.easyIFC
local mRand 		= math.random
local isValid 		= display.isValid
local newAngleLine 	= ssk.display.newAngleLine
local newLine 		= ssk.display.newLine

local mAbs 			= math.abs


function sample.run( step, showHyrbrid )
	step = step or 1

	layers = ssk.display.quickLayers( nil, "underlay", "content", "overlay")

	physics.start()
	physics.setGravity(0,0)

	if( showHyrbrid ) then
		physics.setDrawMode( "hybrid" )
	end

	local bumperSize 		= 80
	local ballSize 			= 40

	if( step > 4 ) then
		ballSize = 25
	end

	local ballSpeed 		= 50
	local ballRadius 		= ballSize/2

	if( step > 4 ) then
		ballRadius = ballRadius * 0.6
	end
	
	local sqrt2 			= math.sqrt(2)
	
	local offset 			= sqrt2/2 * ballRadius

	local square = newImageRect( layers.content, centerX, centerY, "images/square2.png",
		                         { size = bumperSize, alpha = (step > 1) and 0.25 or 1 }, 
		                         (step == 1) and { bodyType = "static" } or nil  ) 

	if( step > 5 ) then 
		square.alpha = 0 
	end

	local bigTri	
	if( step > 1 and step < 6 ) then
		bigTri = newImageRect( layers.content, centerX, centerY, "images/triangle2.png",
			                         { size = bumperSize, alpha = ( step < 4 ) and 1 or 0.25, 
			                           fill = ( step < 4 ) and _W_ or _R_ },
			                           (step < 4) and { bodyType = "static", useOutline = true } or nil  )
	end

	local wrongCollide
	local rightCollide
	if( step == 3 ) then
		wrongCollide = newCircle( layers.overlay, square.x + offset, square.y + offset, { radius = 4, fill = _R_ } )
		rightCollide = newCircle( layers.overlay, square.x, square.y, { radius = 4, fill = _G_ } )
	elseif( step > 3 ) then
		wrongCollide = newCircle( layers.overlay, square.x, square.y, { radius = 4, fill = _B_ } )
		rightCollide = newCircle( layers.overlay, square.x - offset, square.y + offset, { radius = 4, fill = _G_ } )
	end

	local smallTri	
	if( step > 3  ) then
		local correctSize = bumperSize - 2 * offset
		local shape = 
		{ 
			-correctSize/2, -correctSize/2,
			correctSize/2, correctSize/2,
			-correctSize/2, correctSize/2,
		}

		local function onTouch( self, event ) 
			if( event.phase == "ended" ) then
				self:setAngle( self.rotation + 90 )
			end
			return true
		end


		smallTri = newImageRect( layers.content, square.x - offset, square.y + offset,
			                         "images/triangle2.png",
			                         { size = correctSize, touch = onTouch }, 
			                         { bodyType = "static",  shape = shape  } )

		function smallTri.setAngle( self, angle ) -- angle == 0, 90, 180, 270 (ONLY!)

			local function onComplete( self )
				-- Fix rotation to and beyond 360 after done rotating
				-- Otherwise transitions will act 'weird'
				ssk.misc.normRot( self )
			end

			self.rotation = transition.to(self, { rotation = angle, time = 250, onComplete = self} )

			if( angle < 0 ) then
				while( angle < 0 ) do angle = angle + 360 end
			end
			if( angle  >= 360 ) then
				while( angle >= 360 ) do angle = angle - 360 end			
			end

			if(angle == 0) then
				self.x = square.x - offset
				self.y = square.y + offset
			
			elseif(angle == 90) then
				self.x = square.x - offset
				self.y = square.y - offset

			elseif(angle == 180) then
				self.x = square.x + offset
				self.y = square.y - offset
			
			else
				self.x = square.x + offset
				self.y = square.y + offset
			end

		end

	end

	if( step == 1  ) then
		newLine( layers.content, centerX + bumperSize/2, centerY, centerX + 150, centerY, { strokeWidth = 4 } )
	elseif( step > 1 and step < 7 ) then
		newLine( layers.content, centerX, centerY - 100, centerX, centerY, { strokeWidth = 4 } )
		newLine( layers.content, centerX, centerY, centerX + 150, centerY, { strokeWidth = 4 } )
	end

	local function onTouch( self, event ) 
		if( event.phase == "ended" ) then
			if( not self.timer ) then
				self:setLinearVelocity( -ballSpeed,0 )
				self.timer = function( self )
					if( step < 7 ) then
						newRect( self.parent, self.x, self.y, { size = 3, fill = _R_ } )
						self:toFront()
					end
				end
				timer.performWithDelay( 100, self, -1 )
			end
		end
		return true
	end

	local ball = newImageRect( layers.content, centerX + 150, centerY, "images/yellow_round.png",
			                   { size = ballSize, touch = onTouch }, 
			                   { radius = ballRadius, friction = 1, isFixedRotation = true, 
			                     bounce = 1, friction = 0, isBullet = true } )


	if( step > 5 ) then
		wrongCollide.isVisible = false
		rightCollide.isVisible = false
		local throb
		throb = function( self )
			transition.to( self, { xScale = 1.1, yScale = 1.1, time = 500 } )
			transition.to( self, { xScale = 1, yScale = 1, delay = 500, time = 500, onComplete = throb } )
		end
		throb( smallTri)
	end

end

return sample