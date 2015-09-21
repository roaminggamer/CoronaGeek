local math2d = require "plugin.math2d"

local physics = require "physics"
physics.start()
physics.setGravity(0,0)


local cx = display.contentCenterX
local cy = display.contentCenterY


local moveTargetLeft
local moveTargetRight
local shoot


local target = display.newCircle( cx + 200, cy - 100, 15)
target:setFillColor(0,1,0)

moveTargetLeft = function( obj ) 
	transition.to( obj, { x = cx - 200, time = 8000, onComplete = moveTargetRight } )
end

moveTargetRight = function( obj )
	transition.to( obj, { x = cx + 200, time = 8000, onComplete = moveTargetLeft } )
end
moveTargetLeft( target )


-- Create some objects to visually represent out turret
--
local turret = display.newCircle( cx, cy + 100, 20 )
turret:setFillColor(0,0,0,0)
turret:setStrokeColor(1,1,0)
turret.strokeWidth = 2

local barrel = display.newRect( turret.x, turret.y, 20, 50 )
barrel:setFillColor(0,0,0,0)
barrel:setStrokeColor(0,1,1)
barrel.strokeWidth = 2
barrel.anchorY = 0.75


-- Barrel Logic (enterFrame Listener)
--
barrel.enterFrame = function( self )

	-- 1. Always face the target by calculating angle to target then adjusting to
	--    that angle
	local vec   = math2d.diff( self, target ) 
	local angle = math2d.vector2Angle( vec )
	self.rotation = angle

	-- 2. Debug Code To Show aim
	--
	display.remove( self.lastLine )
	self.lastLine = display.newLine( self.x, self.y, vec.x + self.x, vec.y + self.y )
end
Runtime:addEventListener( "enterFrame", barrel )


-- Shoot at target every second
timer.performWithDelay( 3000, function() shoot( barrel ) end, -1 )


local steer
-- Shooting Logic
--
shoot = function( obj )
	local tmp = display.newCircle( obj.x, obj.y, 10)
	tmp:setFillColor( 1, 0, 0 )
	physics.addBody( tmp )

	local vec = math2d.diff( obj, target ) 

	vec = math2d.normalize( vec )

	vec = math2d.scale( vec, 150 )

	tmp:setLinearVelocity( vec.x, vec.y )

	tmp.enterFrame = steer
	Runtime:addEventListener( "enterFrame", tmp ) 

end

steer = function( self )
	local vec = math2d.diff( self, target ) 
	vec = math2d.normalize( vec )
	vec = math2d.scale( vec, 150 )
	self:setLinearVelocity( vec.x, vec.y )

end

