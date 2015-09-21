-- =============================================================
-- Copyright Roaming Gamer, LLC. 2009-2015 
-- =============================================================
-- 
-- =============================================================
local mFloor = math.floor

local math2d	= require "plugin.math2d"


-- Localize math2d functions for an execution speedup
local scaleVec 		= math2d.scale
local subVec		= math2d.diff
local normVec		= math2d.normalize
local vector2Angle	= math2d.vector2Angle
local angle2Vector	= math2d.angle2Vector
local normalVecs	= math2d.normals
local lenVec 		= math2d.length

local utils = {}

utils.calculateDistanceToPlayer = function( turret, player )
	if( not player or player.x == nil ) then return math.huge end
	if( not turret or turret.x == nil ) then return math.huge end


	-- Cacluate distance
	local dist = subVec( player, turret )
	dist = lenVec( dist )

	return dist
end

utils.rocketTrail = function ( rocket, trailStyle )
	if( rocket.trailCount == nil ) then
		rocket.trailCount = 0
	    rocket.lastX = rocket.x
	    rocket.lastY = rocket.y
	end


    -- Fading Squares
    if( trailStyle == 1 ) then
		-- Draw every 3rd frame (uncomment to reduce particles)
		--[[
		if( rocket.trailCount % 3 ~= 0 ) then
			rocket.trailCount = rocket.trailCount + 1
			return
		end
		rocket.trailCount = rocket.trailCount + 1
		--]]

		for i = 1, 3 do
			local tmp = display.newRect( rocket.parent, 
				                         rocket.x + math.random(-2,2), rocket.y + math.random(-2,2), 
				                         rocket.contentWidth/2, rocket.contentHeight/2 )
			tmp.alpha = 0.5
			tmp:setFillColor(0.25,0.25,0.25)
			tmp:toBack()
			transition.to( tmp, { alpha = 0.05, xScale = 0.5, yScale = 0.5, time = 1000, onComplete = display.remove })
		end    		

    -- Fading Circles
    elseif( trailStyle == 2 ) then

		-- Draw every 3rd frame (uncomment to reduce particles)
		--[[
		if( rocket.trailCount % 3 ~= 0 ) then
			rocket.trailCount = rocket.trailCount + 1
			return
		end
		rocket.trailCount = rocket.trailCount + 1
		--]]

		for i = 1, 3 do
			local tmp = display.newCircle( rocket.parent, 
				                         rocket.x + math.random(-1,1), rocket.y + math.random(-1,1), 
				                         rocket.contentWidth/3 )
			tmp.alpha = 0.5
			tmp:setFillColor(0.25,0.25,0.25)
			tmp:toBack()
			transition.to( tmp, { alpha = 0.05, xScale = 0.5, yScale = 0.5, time = 1000, onComplete = display.remove })
		end    		

    -- Lines
    elseif( trailStyle == 3 ) then

		-- Draw every 3rd frame (uncomment to reduce particles)
		----[[
		if( rocket.trailCount % 3 ~= 0 ) then
			rocket.trailCount = rocket.trailCount + 1
			return
		end
		rocket.trailCount = rocket.trailCount + 1
		--]]

		local tmp = display.newLine( rocket.parent, rocket.lastX, rocket.lastY, rocket.x, rocket.y)
		rocket.lastX = rocket.x
		rocket.lastY = rocket.y

		tmp.alpha = 0.8
		tmp:setStrokeColor(0.25,0.25,0.25)
		tmp:toBack()
		tmp.strokeWidth = rocket.contentHeight/2
		transition.to( tmp, { alpha = 0.05, strokeWidth = 1, time = 1000, onComplete = display.remove })


    -- Rainbow Fading Squares
    elseif( trailStyle == 4 ) then
		-- Draw every 3rd frame (uncomment to reduce particles)
		--[[
		if( rocket.trailCount % 3 ~= 0 ) then
			rocket.trailCount = rocket.trailCount + 1
			return
		end
		rocket.trailCount = rocket.trailCount + 1
		--]]

		for i = 1, 3 do
			local tmp = display.newRect( rocket.parent, 
				                         rocket.x + math.random(-1,1), rocket.y + math.random(-1,1), 
				                         rocket.contentWidth/2, rocket.contentHeight/2 )
			tmp.alpha = 0.5
			tmp:setFillColor(math.random(), math.random(), math.random()) 
			tmp:toBack()
			transition.to( tmp, { alpha = 0.05, xScale = 0.5, yScale = 0.5, time = 1000, onComplete = display.remove })
		end    		

    -- Rainbow Fading Circles
    elseif( trailStyle == 5 ) then
		-- Draw every 3rd frame (uncomment to reduce particles)
		--[[
		if( rocket.trailCount % 3 ~= 0 ) then
			rocket.trailCount = rocket.trailCount + 1
			return
		end
		rocket.trailCount = rocket.trailCount + 1
		--]]

		for i = 1, 3 do
			local tmp = display.newCircle( rocket.parent, 
				                         rocket.x + math.random(-2,2), rocket.y + math.random(-2,2), 
				                         rocket.contentWidth/3 )
			tmp.alpha = 0.5
			tmp:setFillColor(math.random(), math.random(), math.random()) 
			tmp:toBack()
			transition.to( tmp, { alpha = 0.05, xScale = 0.5, yScale = 0.5, time = 1000, onComplete = display.remove })
		end    		

    -- Rainbow Lines
    elseif( trailStyle == 6 ) then

		-- Draw every 3rd frame (uncomment to reduce particles)
		----[[
		if( rocket.trailCount % 3 ~= 0 ) then
			rocket.trailCount = rocket.trailCount + 1
			return
		end
		rocket.trailCount = rocket.trailCount + 1
		--]]

		local tmp = display.newLine( rocket.parent, rocket.lastX, rocket.lastY, rocket.x, rocket.y)
		rocket.lastX = rocket.x
		rocket.lastY = rocket.y

		tmp.alpha = 0.8
		tmp:setStrokeColor(math.random(), math.random(), math.random()) 
		tmp:toBack()
		tmp.strokeWidth = rocket.contentHeight/2

		transition.to( tmp, { alpha = 0.05, strokeWidth = 1, time = 1000, onComplete = display.remove })

    end
end

return utils