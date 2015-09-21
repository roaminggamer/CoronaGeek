-- =============================================================
-- Copyright Roaming Gamer, LLC. 2009-2015 
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


-- Localize math2d functions for an execution speedup
local scaleVec 		= ssk.math2d.scale
local subVec		= ssk.math2d.sub
local normVec		= ssk.math2d.normalize
local vector2Angle	= ssk.math2d.vector2Angle
local angle2Vector	= ssk.math2d.angle2Vector
local normalVecs	= ssk.math2d.normals


-- Load and Config Player Sprite Data
local playerInfo 	= require "images.tmbf_player"
local playerSheet 	= graphics.newImageSheet("images/tmbf_player.png", playerInfo:getSheet() )
local playerSeqData = 
	{
		{ name = "idle", frames = {2}, time = 1000, loopCount = 0, loopDirection = "forward"}, 
		{ name = "jump", frames = {1}, time = 1000, loopCount = 0, loopDirection = "forward"}, 
		{name = "rightwalk", frames = {3,4,5,6,7,8,9,10,11,12,13 }, time = 500, loopCount = 0, loopDirection = "forward"}, 
		{name = "leftwalk", frames = {3,4,5,6,7,8,9,10,11,12,13 }, time = 500, loopCount = 0, loopDirection = "forward"}, 
	}



local builder = {}

-- =============================================
-- The Builder (Create) Function
-- =============================================
function builder.create( layers, data, pieces )
	-- 
	-- Create a circle as our player
	--
	local player = display.newCircle( layers.content, data.x, data.y, common.playerSize/2 )
	player.rotation = data.rotation
	player.strokeWidth = 3
	player:setStrokeColor(0,0,0,0.8)
	player.isVisible = not common.niceGraphics
	player.animState = "idle" -- Starting animation state (used for animation changing logic below)
	player.isJumping = false -- Assume we are not 'jumping' to start

	-- Initialize player's movement++ values (used later to move player)
	player.myAngularVelocity 	= 0
	player.myGravityAngle 		= 0
	player.myGravityMagnitude 	= 0
	player.pieces 				= pieces
	player.layers				= layers

	-- Add a basic 'dynamic' body with no bounce and 100% friction
	local physics = require "physics"
	physics.addBody( player, "dynamic", 
		             { density = 1, bounce = 0, friction = 100, radius = common.playerSize/2,
		               filter = common.myCC:getCollisionFilter( "player" ) } )


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

	-- 
	-- Create a 'foot' for our player to detect when we are jumping or not jumping
	--
	player.foot = display.newCircle( layers.content, data.x, data.y, common.footSize/2 )
	player.foot.alpha = 0	
	if( common.debugEn ) then
		player:toFront()
		player.foot.alpha = 0.8
		player.foot:setFillColor(1,0,1)
	end
	physics.addBody( player.foot, "dynamic", 
		             { density = 0.01,radius = common.footSize/2,
		               filter = common.myCC:getCollisionFilter( "foot" ) } )
	player.foot.isSensor = true -- We do not want any 'collision response'
	
	-- Add a simple collision listener to the foot to detect 'jumping'
	--
	player.foot.collision = function( self, event )
		-- Abort early if player has been removed somehow
		if( player.removeSelf == nil ) then 
			return true 
		end

		-- Detect if we are 'jumping'
		if( event.phase == "began" ) then
			player.isJumping = false
			--print( "NOT JUMPING!" )
		elseif( event.phase == "ended" ) then
			player.isJumping = true
			--print( "JUMPING!" )
		end
		return true		
	end
	player.foot:addEventListener( "collision" )



	-- Nice Looking Player (A sprite)
	--
	if( common.niceGraphics ) then
		player.mySprite = display.newSprite( layers.content, playerSheet, playerSeqData )
		player.mySprite.xScale = 0.55 
		player.mySprite.yScale = 0.55
		player.mySprite:setSequence( "idle" )
		player.mySprite:play()

		-- Player sprite
		player.mySprite.enterFrame = function( self )
			if( self.removeSelf == nil  or 
				player.removeSelf == nil ) then
				Runtime:removeEventListener( "enterFrame", self )
				return
			end
			self.x = player.x
			self.y = player.y
			self.rotation = player.myGravityAngle - 180

			-- Various events will 'request' that the player's animation change
			-- If the 'requested' (animState) does not match the sprites current
			-- sequence, let's change it:
			--
			if( player.animState ~= self.sequence) then
				self:setSequence( player.animState )
				self:play()

				-- Flip srpite on the x-axis if walking
				if( player.animState == "leftwalk" ) then
					self.xScale = -0.55 
				elseif( player.animState == "rightwalk" ) then
					self.xScale = 0.55 
				end
			end
		end
		Runtime:addEventListener( "enterFrame", player.mySprite )
	end


	-- Debug Feature: Add arrow and force label to player
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



--
-- 'Move Left' Button Press Event Listener
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


--
-- 'Move Right' Button Press Event Listener
--
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

--
-- 'Jump' Button Press Event Listener
--
onJump = function( self, event )
	if( self.removeSelf == nil ) then
		Runtime:removeEventListener( "onJump", self )
		return
	end
	-- Can't jump if we are already jumping
	if( event.phase == "began" and not self.isJumping ) then 
		local angle2Vector 	= ssk.math2d.angle2Vector
		local scaleVec 		= ssk.math2d.scale

		local impulseVec 	= angle2Vector( self.myGravityAngle, true )
		impulseVec			= scaleVec( impulseVec, -common.jumpMag * self.mass )

		self:applyLinearImpulse( impulseVec.x, impulseVec.y, self.x, self.y )
	
	end
end

--
-- 'enterFrame' Listener (for player)
-- 
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
		self.linearDamping 	= 3
		self.angluarDamping = 1
	else
		self.linearDamping 	= 0
		self.angluarDamping = 0
		self.angularVelocity = self.myAngularVelocity
	end


	if( self.isJumping ) then
		
	end


	-- Request a change to players sprite animation (does nothing if we aren't showing 'niceGraphics')
	--
	local minWalkingAV = 15 -- Considered to be walking if -minWalkingAV < angularVelocity < minWalkingAV
	if( self.isJumping ) then
		self.animState = "jump"
		
		-- Air Control Code
		--
		if( math.abs(self.angularVelocity) < minWalkingAV ) then
			-- Just Jumping
		elseif( self.angularVelocity > minWalkingAV ) then
			-- Rotate about our current gravity object a little
			--print( 'AIR CONTROL RIGHT')
			local vec = angle2Vector( self.myGravityAngle, true )
			local n1, n2 = normalVecs( vec )
			local airVec = scaleVec( n2, common.airForce )
			self:applyForce( airVec.x, airVec.y, self.x, self.y )

		else
			-- Rotate about our current gravity object a little
			--print( 'AIR CONTROL LEFT')
			local vec = angle2Vector( self.myGravityAngle, true )
			local n1, n2 = normalVecs( vec )
			local airVec = scaleVec( n1, common.airForce )
			self:applyForce( airVec.x, airVec.y, self.x, self.y )
		end

	elseif( math.abs(self.angularVelocity) < minWalkingAV ) then
		self.animState = "idle"
	elseif( self.angularVelocity > minWalkingAV ) then		
		self.animState = "rightwalk"
	else
		self.animState = "leftwalk"
	end

	-- Update 'foot' position
	--
	self.foot.x = self.x
	self.foot.y = self.y

	if( common.debugEn ) then
		-- Show normal vectors
		--
		if( self.myNormals ) then
			for k,v in pairs( self.myNormals ) do
				display.remove( v )
			end
		end
		local vec = ssk.math2d.angle2Vector( self.myGravityAngle, true )
		self.myNormals = {}
		local n1, n2 = normalVecs( vec )
		self.myNormals[1] = display.newLine( self.parent, self.x, self.y, self.x + n1.x * common.blockSize/2, self.y + n1.y * common.blockSize/2 )
		self.myNormals[1].strokeWidth = 4
		self.myNormals[1]:setStrokeColor(1,0,0)
		self.myNormals[2] = display.newLine( self.parent, self.x, self.y, self.x + n2.x * common.blockSize/2, self.y + n2.y * common.blockSize/2 )
		self.myNormals[2].strokeWidth = 4
		self.myNormals[2]:setStrokeColor(0,1,0)
		self.myArrow:toFront()
		self.debugLabel:toFront()
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