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



function builder.create( group, x, y )
	local filter 			= { groupIndex = - 1 }
	local wheelSpeed 		= 600
	local leftAxle
	local rightAxle
	local touchJointForce	= 100000

	-- ==
	--   chassis
	-- ==	
	local chassis = display.newRect( group, 0, 0, 80, 30 )
	chassis.x = x
	chassis.y = y
	chassis:setFillColor( 1, 1, 0 )
	physics.addBody( chassis, { density = 0.2, filter = filter } )
	chassis.linearDamping = 0.5
	chassis.angularDamping = 0
	chassis.isSleepingAllowed = false

	-- ==
	--   left wheel
	-- ==
	local wheelX = chassis.x - chassis.contentWidth/2 + 15
	local wheelY = chassis.y + chassis.contentHeight/2

	local leftWheel = display.newCircle( group, wheelX, wheelY, 12 )
	leftWheel.fill = { type = "image", filename = rootPath .."coronaLogo.png" }
	
	physics.addBody( leftWheel, { density = 0.05, filter = filter, friction = 100, radius = 12 } )
	
	leftWheel.linearDamping = 0
	leftWheel.angularDamping = 1
	chassis.leftAxle  = physics.newJoint( "pivot", leftWheel, chassis, leftWheel.x, leftWheel.y )	

	-- ==
	--   right wheel
	-- ==	
	local wheelX = chassis.x + chassis.contentWidth/2 - 15
	local wheelY = chassis.y + chassis.contentHeight/2

	local rightWheel = display.newCircle( group, wheelX, wheelY, 12 )	
	rightWheel.fill = { type = "image", filename = rootPath .."coronaLogo.png" }

	physics.addBody( rightWheel, { density = 0.05, filter = filter, friction = 100, radius = 12 } )

	rightWheel.linearDamping = 0
	rightWheel.angularDamping = 1
	chassis.rightAxle  = physics.newJoint( "pivot", rightWheel, chassis, rightWheel.x, rightWheel.y )


	-- 'Driving' methods
	--
	function chassis.setLeftWheelSpeed( self, wheelSpeed )
		if( wheelSpeed ==  0 ) then
			self.leftAxle.maxMotorTorque = 0
			self.leftAxle.isMotorEnabled = false
			self.leftAxle.motorSpeed = wheelSpeed
		else
			self.leftAxle.maxMotorTorque = 100000
			self.leftAxle.isMotorEnabled = true
			self.leftAxle.motorSpeed = wheelSpeed
		end
	end

	function chassis.setRightWheelSpeed( self, wheelSpeed )		
		if( wheelSpeed ==  0 ) then
			self.rightAxle.maxMotorTorque = 0
			self.rightAxle.isMotorEnabled = false
			self.rightAxle.motorSpeed = wheelSpeed
		else			
			self.rightAxle.maxMotorTorque = 100000
			self.rightAxle.isMotorEnabled = true
			self.rightAxle.motorSpeed = wheelSpeed
		end
	end

	return chassis
end

return builder