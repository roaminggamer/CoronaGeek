-- =============================================================
-- Copyright Roaming Gamer, LLC. 2009-2015 
-- =============================================================
-- 
-- =============================================================
local common 	= require "scripts.common"
local utils 	= require "scripts.builders.builder_utils"




-- Localize math2d functions for an execution speedup
local scaleVec 		= ssk.math2d.scale
local subVec		= ssk.math2d.sub
local normVec		= ssk.math2d.normalize
local vector2Angle	= ssk.math2d.vector2Angle
local angle2Vector	= ssk.math2d.angle2Vector
local normalVecs	= ssk.math2d.normals

local builder = {}

-- =============================================
-- The Builder (Create) Function
-- =============================================
function builder.create( layers, data, pieces )
	local aPiece

	-- Create an object (basic or pretty) to represent this world object
	--
	if( common.niceGraphics ) then
		aPiece = display.newImageRect( layers.content, "images/kenney/elementMetal001.png", common.turretSize, common.turretSize )
		aPiece.x = data.x
		aPiece.y = data.y
	else
		aPiece = display.newCircle( layers.content, data.x, data.y, common.turretSize/2 )
		aPiece.strokeWidth = 4
		aPiece:setStrokeColor(0,0,0)
	end

	-- If debug mode is enabled, add a label for showing 'distance to'
	--
	if( common.debugEn ) then	
		-- debug label to show distance to player
		aPiece.debugLabel = display.newText( layers.content, "TBD", data.x, data.y + common.blockSize/3, native.systemFontBold, 18 )
		aPiece.debugLabel:setFillColor(1,0,0)
	end

	-- Add a physics body to our world object and use the appropriate filter from the 'collision calculator'
	--
	local physics = require "physics"
	physics.addBody( aPiece, "static", 
		             { density = 1, bounce = 0, friction = 1, radius = common.turretSize/2,
		               filter = common.myCC:getCollisionFilter( "platform" ) } )

	-- This is a platform object, so add it to the 'pieces' list.  The player scans this list for nearby 'gravity' objects.
	--
	pieces[#pieces+1] = aPiece


	-- Create an object to act as our turret
	--
	local turret = display.newImageRect( layers.content, "images/kenney/turret.png", common.blockSize, common.blockSize )
	turret.x = data.x
	turret.y = data.y
	aPiece.turret = turret

	-- Orient based on subtype
	if( data.subtype == 1 ) then
		turret.rotation = 0
	elseif( data.subtype == 2 ) then
		turret.rotation = 90
	elseif( data.subtype == 3 ) then
		turret.rotation = 180
	elseif( data.subtype == 4 ) then
		turret.rotation = 270
	elseif( data.subtype == 5 ) then
		turret.rotation = 45
	elseif( data.subtype == 6 ) then
		turret.rotation = 135
	elseif( data.subtype == 7 ) then
		turret.rotation = 225
	elseif( data.subtype == 8 ) then
		turret.rotation = 315
	end


	-- Add 'timed' code to fire lasers in facing direction
	turret.timer = function( self )
		if( self.removeSelf == nil ) then			
			return
		end

		-- Create new 'laser'
		local laser = display.newRect( self.parent, self.x, self.y, common.laserWidth/2, common.laserWidth )
		laser.rotation = self.rotation
		laser:setFillColor(1,0,0)
		laser:setStrokeColor(1,1,0,0.35)
		laser.strokeWidth = 4
		laser:toBack()

		-- Add body to laser so we can move it with physics and detect collisions
		physics.addBody( laser, "dynamic", 
			             { density = 1, bounce = 0, friction = 1, 
			               filter = common.myCC:getCollisionFilter( "bullet" ) } )
		laser.isSensor = true
		laser.isBullet = true

		-- Set velocity of laser object
		local vec = angle2Vector( laser.rotation, true )
		vec = scaleVec( vec, common.laserSpeed )
		laser:setLinearVelocity( vec.x, vec.y )


		-- Add a basic collision listener and dispatch and event when it occurs, then remove this object from the world
		--
		laser.ignorePlatforms = true  -- Initially, ignore collisions with platforms
		laser.collision = function( self, event )
			local other = event.other
			if( other.isPlayer ) then
				print("GOTCHA!")
				post( "onSFX", { sfx = "bad" } )
				-- Tip: We're only handling the first phase of the collision, so remove listener right away.
				self:removeEventListener( "collision" )
				timer.performWithDelay( 100, function()  Runtime:dispatchEvent( { name = "onReloadLevel" } )  end )
			elseif( not self.ignorePlatforms ) then
				display.remove( self )
			end
			return true
		end
		laser:addEventListener( "collision" )

		
		timer.performWithDelay( 10000, function() display.remove( laser )  end )
		timer.performWithDelay( 500, function()   laser.ignorePlatforms = false	end )
		timer.performWithDelay( common.turretFireTime, self )
	end
	--turret:timer()  
	timer.performWithDelay( 500, turret )


	-- Return a reference to this object 
	--
	return aPiece
end

return builder