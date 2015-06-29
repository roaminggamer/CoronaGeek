-- =============================================================
-- Copyright Roaming Gamer, LLC. 2009-2015
-- =============================================================
-- 
-- =============================================================
-- 
-- =============================================================
local physics 		= require "physics"

local builder = {}



function builder.create( group, x, y )
	local filter 			= { groupIndex = - 1 }
	local leftAxle
	local rightAxle
	local touchJointForce	= 100000

	-- ==
	--   chassis
	-- ==	
	local chassis = display.newRect( group, 0, 0, 160, 60 )
	chassis.x = x
	chassis.y = y
	chassis:setFillColor( 1, 1, 0 )
	physics.addBody( chassis, { density = 0.005, filter = filter } )
	chassis.linearDamping = 0.5
	chassis.angularDamping = 0
	chassis.isSleepingAllowed = false

	-- ==
	--   left wheel
	-- ==
	local wheelX = chassis.x - chassis.contentWidth/2 + 30
	local wheelY = chassis.y + chassis.contentHeight/2

	local leftWheel = display.newImageRect( group, "coronaLogo.png", 48, 48 )
	leftWheel.x = wheelX
	leftWheel.y = wheelY
	
	physics.addBody( leftWheel, { density = 0.05, filter = filter, friction = 100, radius = 24 } )
	
	leftWheel.linearDamping = 0
	leftWheel.angularDamping = 1
	chassis.leftAxle  = physics.newJoint( "pivot", leftWheel, chassis, leftWheel.x, leftWheel.y )	

	-- ==
	--   right wheel
	-- ==	
	local wheelX = chassis.x + chassis.contentWidth/2 - 30
	local wheelY = chassis.y + chassis.contentHeight/2

	local rightWheel = display.newImageRect( group, "coronaLogo.png", 48, 48 )
	rightWheel.x = wheelX
	rightWheel.y = wheelY

	physics.addBody( rightWheel, { density = 0.05, filter = filter, friction = 100, radius = 24 } )

	rightWheel.linearDamping = 0
	rightWheel.angularDamping = 1
	chassis.rightAxle  = physics.newJoint( "pivot", rightWheel, chassis, rightWheel.x, rightWheel.y )


	-- 'Driving' methods
	--
	function chassis.setLeftWheelSpeed( self, wheelSpeed )
		if( wheelSpeed ==  0 ) then
			self.leftAxle.maxMotorTorque = 0			
			self.leftAxle.motorSpeed = wheelSpeed
			self.leftAxle.isMotorEnabled = false
		else
			self.leftAxle.maxMotorTorque = 100000			
			self.leftAxle.motorSpeed = wheelSpeed
			self.leftAxle.isMotorEnabled = true
		end
	end

	function chassis.setRightWheelSpeed( self, wheelSpeed )		
		if( wheelSpeed ==  0 ) then
			self.rightAxle.maxMotorTorque = 0			
			self.rightAxle.motorSpeed = wheelSpeed
			self.rightAxle.isMotorEnabled = false
		else			
			self.rightAxle.maxMotorTorque = 100000			
			self.rightAxle.motorSpeed = wheelSpeed
			self.rightAxle.isMotorEnabled = true
		end
	end

	return chassis
end

return builder