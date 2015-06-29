-- =============================================================
-- Copyright Roaming Gamer, LLC. 2009-2015
-- =============================================================
-- 
-- =============================================================
-- 
-- =============================================================
local rootPath 		= _G.sampleRoot or ""

local touchJointForce = 20

local filter = { groupIndex = -1 }


local helpers = {}

function helpers.setTouchJointForce( force )
	touchJointForce = force
end

function helpers.addNameLabel( group, obj, text )
	local label = display.newText( group, text, obj.x, obj.y, native.systemFont , 16  )
	label:setFillColor(0,0,0)
	label.enterFrame = function( self, event ) 
	    if( self.removeSelf == nil ) then
	    	ignore( "enterFrame", self )
	    	return
	    end
	    self.x = obj.x
	    self.y = obj.y
	    self.rotation = obj.rotation
	end; Runtime:addEventListener( "enterFrame", label )
end

local function dragListener( self, event )
	local phase = event.phase
 
    if( phase == "began" ) then
	    display.getCurrentStage():setFocus(self,event.id)
		self.isFocus = true
		-- Use this code to set joint in middle of object
		--self.tempJoint = physics.newJoint( "touch", self, self.x, self.y )

		-- Use this code to set joint at touch point
		self.tempJoint = physics.newJoint( "touch", self, event.x, event.y )

		self.tempJoint.maxForce = touchJointForce
	
	elseif( self.isFocus ) then

		if( phase == "moved" ) then
			self.tempJoint:setTarget( event.x, event.y )

		elseif( phase == "ended" ) then
			display.getCurrentStage():setFocus( self, nil )
			self.isFocus = false

			display.remove( self.tempJoint ) 
		end			
    end 
    return true
end

function helpers.addDragger( obj )
	obj.touch = dragListener
	obj:addEventListener( "touch", obj )
	obj:setFillColor(0,1,0)
	obj.strokeWidth = 1	
	obj:setStrokeColor(1,0,1)
end


function helpers.createAnchor( group, x, y, sizeX, sizeY )
	local block = display.newRect( group, x, y, sizeX, sizeY )
	physics.addBody( block, "static", { filter = filter, radius = 0.05 } )

	return block
end


function helpers.createBridgeLink( group, x, y, sizeX, sizeY )
	local block = display.newRect( group, x, y, sizeX, sizeY )
	--physics.addBody( block, "dynamic", { filter = filter, radius = 0.05, density = 1, bounce = 0 } )
	physics.addBody( block, "dynamic", { radius = 0.05, density = 1, bounce = 0 } )
	block.isSleepingAllowed = false
	block.linearDamping = 1
	block.angularDamping = 1
	return block
end

function helpers.connectBridgeParts( cur, last )
	local theJoint = physics.newJoint( "distance", last, cur, last.x, last.y, cur.x, cur.y )	
	theJoint.dampingRatio = 1
	theJoint.frequency = 10000
	print(theJoint.length)
end




return helpers