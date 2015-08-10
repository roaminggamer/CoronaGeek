-- =============================================================
-- Copyright Roaming Gamer, LLC. 2009-2014 
-- =============================================================
-- 
-- =============================================================
local common 	= require "scripts.common"

-- Forward Declarations
local caclulateDistanceToPieces
local calculateMyGravity
local onLeft
local onRight
local onJump
local onEnterFrame

local builder = {}

-- =============================================
-- The Builder (Create) Function
-- =============================================
function builder.create( layers, data, pieces )

	-- Create a circle as our player
	--
	local player = display.newCircle( layers.content, data.x, data.y, common.playerSize/2 )
	player.rotation = data.rotation
	player.strokeWidth = 3
	player:setStrokeColor(0,0,0,0.8)

	-- Initialize player's movement++ values (used later to move player)
	player.myAngularVelocity 	= 0
	player.myGravityAngle 		= 0
	player.myGravityMagnitude 	= 0
	player.pieces 				= pieces
	player.layers				= layers

	-- Add a basic 'dynamic' body with no bounce and 100% friction
	local physics = require "physics"
	physics.addBody( player, "dynamic", { density = 1, bounce = 0, friction = 100, radius = common.playerSize/2  } )


	-- Attach various listeners and start listening for these events
	--
	player.onLeft = onLeft -- Left button pushed
	Runtime:addEventListener( "onLeft", player )

	player.onRight = onRight -- Right button pushed
	Runtime:addEventListener( "onRight", player )

	player.onJump = onJump -- Jump button pushed
	Runtime:addEventListener( "onJump", player )

	player.enterFrame = onEnterFrame -- enterFrame event
	Runtime:addEventListener( "enterFrame", player )


	-- Debug Feature: Add arrrow and force label to player
	if( common.debugEn ) then			
		player.myArrow = display.newImageRect( layers.content, "images/up.png", common.playerSize-2, common.playerSize-2 )
		player.myArrow:setFillColor(1,0,0)

		player.debugLabel = display.newText( layers.content, "0", player.x, player.y, native.systemFontBold, 14 )

		-- Debug arrow and myGravity magnitude label
		player.myArrow.enterFrame = function( self )
			if( self.removeSelf == nil  or 
				player.removeSelf == nil or 
				player.debugLabel.removeSelf == nil ) then
				Runtime:removeEventListener( "enterFrame", self )
				return
			end
			self.x = player.x
			self.y = player.y
			player.debugLabel.x = player.x
			player.debugLabel.y = player.y

			self.rotation 			= player.myGravityAngle
			player.debugLabel.text	= round(player.myGravityMagnitude)
		end
		Runtime:addEventListener( "enterFrame", player.myArrow )
	end


	return player
end

-- =============================================
-- Function Definitions
-- =============================================
-- 
-- These helper functions are used to sort the pieces list, by nearest to farthest
-- relative to the player. i.e. pieces[1] is nearest, 2 second nearest, etc.
--
local function compare(a,b) return a.dist2Player < b.dist2Player end
caclulateDistanceToPieces = function( player, pieces )
	local subVec	= ssk.math2d.sub
	local lenVec	= ssk.math2d.length

	-- Cacluate distances
	for k,v in pairs( pieces ) do
		v.dist2Player = subVec( player, v )
		v.dist2Player = lenVec( v.dist2Player )

		-- Update debug label if common.debugEn
		if( common.debugEn ) then
			v.debugLabel.text = round( v.dist2Player )		
			v:setFillColor(1,1,0)
		end
	end

	table.sort( pieces, compare )

	if( common.debugEn ) then
		pieces[1]:setFillColor(0,1,0)
	end
end


--
-- This helper calculates the players current 'myGravity' direction and magnitude
--
calculateMyGravity = function( player, pieces )
	local scaleVec 		= ssk.math2d.scale
	local subVec		= ssk.math2d.sub
	local normVec		= ssk.math2d.normalize
	local vector2Angle	= ssk.math2d.vector2Angle

	-- Get the nearest piece, abort of not found
	local nearest = pieces[1]	
	if( not nearest ) then return end

	-- Calculate force vector (myGravity)
	local dist2Player 			= nearest.dist2Player
	local vec 					= subVec( player, nearest )
	vec 						= normVec( vec )
	local angle 				= vector2Angle( vec )
	local magnitude 			= common.gravityMag * player.mass
	vec 						= scaleVec( vec, magnitude)
	player.myGravityAngle 		= angle
	player.myGravityMagnitude 	= magnitude
	player.myGravity 			= vec
end



-- Listen for input events
--
onLeft = function( self, event )
	if( self.removeSelf == nil ) then
		Runtime:removeEventListener( "onLeft", self )
		return
	end
	if( event.phase == "began" ) then 
		self.myAngularVelocity = self.myAngularVelocity - common.playerSpeed
	
	elseif( event.phase == "ended" ) then 
		self.myAngularVelocity = self.myAngularVelocity + common.playerSpeed
	end
end


onRight = function( self, event )
	if( self.removeSelf == nil ) then
		Runtime:removeEventListener( "onRight", self )
		return
	end
	if( event.phase == "began" ) then 
		self.myAngularVelocity = self.myAngularVelocity  + common.playerSpeed
	
	elseif( event.phase == "ended" ) then 
		self.myAngularVelocity = self.myAngularVelocity - common.playerSpeed
	end
end

onJump = function( self, event )
	if( self.removeSelf == nil ) then
		Runtime:removeEventListener( "onJump", self )
		return
	end
	if( event.phase == "began" ) then 
		local angle2Vector 	= ssk.math2d.angle2Vector
		local scaleVec 		= ssk.math2d.scale

		local impulseVec 	= angle2Vector( self.myGravityAngle, true )
		impulseVec			= scaleVec( impulseVec, -common.jumpMag * self.mass )

		self:applyLinearImpulse( impulseVec.x, impulseVec.y, self.x, self.y )
	
	end
end


-- Every frame:
-- 1. Calculate distance to all game pieces (things we can 'walk' on)
-- 2. Apply a personal force (myGravity) to the player in the direction of the nearest game piece.
-- 3. Orient the player
onEnterFrame = function( self ) 
	if( self.removeSelf == nil ) then
		Runtime:removeEventListener( "enterFrame", self )
		return
	end
	caclulateDistanceToPieces( self, self.pieces )
	calculateMyGravity( self, self.pieces )

	-- Apply 'myGravity'
	self:applyForce( self.myGravity.x, self.myGravity.y, self.x, self.y )

	if( self.myAngularVelocity == 0 ) then
		-- Apply some damping to 'bleed off' linear and angular forces. So, if no external forces are applied, the player should
		-- eventually stop moving and rotating.
		self.linearDamping 	= 1
		self.angluarDamping = 1
	else
		self.linearDamping 	= 0
		self.angluarDamping = 0
		self.angularVelocity = self.myAngularVelocity
	end

	-- Camera Code: Keep scene centered on player at all times
	--
	-- Set last X/Y if not yet set 
	self.lx = self.lx or self.x 	-- 'Last' x-position.  
	self.ly = self.ly or self.y 	-- 'Last' y-position.  
	-- Calculate how far we moved since last frame
	local dx = self.x - self.lx
	local dy = self.y - self.ly
	-- Save our new 'last' position
	--
	self.lx = self.x
	self.ly = self.y
	-- Move the 'world' to keep the self in it's initial (visual) position relative
	--
	self.layers.content.x = self.layers.content.x - dx
	self.layers.content.y = self.layers.content.y - dy
end



return builder