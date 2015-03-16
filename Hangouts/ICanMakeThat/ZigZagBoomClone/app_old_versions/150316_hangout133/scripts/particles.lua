-- =============================================================
-- Copyright Roaming Gamer, LLC. 2009-2014 
-- =============================================================
-- 
-- =============================================================
local public = {}

----------------------------------------------------------------------
--								DECLARATIONS						--
----------------------------------------------------------------------
-- Variables
local particlesPerFrame = 2
local particleLife 		= 1500
local startColor 		= { 0xa8/255, 0xcb/255, 0xde/255, 1 }
local endColor 			= { 1, 1, 1, 1 }
--local allParticles = {} -- For debug purposes only (uncomment to get particle count)

-- Forward Declarations

-- LUA/Corona Localizations
local mRand             = math.random
local getTimer          = system.getTimer
local pairs             = pairs

-- SSK Localizations
local angle2VectorFast 	= ssk.math2d.angle2VectorFast
local scaleVectorFast 	= ssk.math2d.scaleFast

----------------------------------------------------------------------
--								DEFINITIONS							--
----------------------------------------------------------------------
-- Draw Particles - Draw a specified number of images per frame at a random radius about the center of the
-- 'sourceObject'.  Then, slowly fade those images out (applying various simple efects) and delete them at the end 
-- of the fade.
--
function public.draw( group, sourceObject, particleRadius )	
	
	-- Create 'particlesPerFrame' paticles every time we call this function
	--
	for i = 1, particlesPerFrame do

		-- A particle is simply an image
		--
		local tmp = display.newImageRect( group, "images/smoke.png", particleRadius, particleRadius )
		--tmp:toBack()			

		-- Calculate a random offset about the position of the 'sourceObject'
		local vx,vy = angle2VectorFast( mRand(0,359) )
		vx,vy = scaleVectorFast( vx, vy, mRand( 0, particleRadius + 2 ) )
		tmp.x = sourceObject.x + vx
		tmp.y = sourceObject.y + vy

		-- Change from one color to another over time
		--
		transition.fromtocolor( tmp, startColor, endColor, particleLife )

		-- Scale up and the scale down over time (also fade alpha)
		--
		tmp:scale(1.5, 1.5)
		transition.to( tmp, { alpha = 0.25, xScale = 0.25, yScale = 0.25, time = particleLife } )
		
		-- Remove the particle after 'particleLife' plus a small extra delay.
		--
		timer.performWithDelay( particleLife + 100, 
			function() 
				display.remove( tmp ) 
				-- If 'debug' code is enabled, remove object from tracking table
				if(allParticles) then allParticles[tmp] = nil end
			end )

		-- If 'debug' code is enabled, add object from tracking table
		if(allParticles) then allParticles[tmp] = allParticles end
		-- If 'debug' code is enabled, print count of particles
		if(allParticles) then print(table.count(allParticles)) end
	end
end

return public