-- =============================================================
-- Copyright Roaming Gamer, LLC. 2009-2015 
-- =============================================================
-- This content produced for Corona Geek Hangouts audience.
-- You may use any and all contents in this example to make a game or app.
-- =============================================================
local public = {}

local physics 			   = require "physics"
local common 			   = require "scripts.common"
local layersMaker		   = require "scripts.layersMaker"
local spriteMaker 		= require 'scripts.spriteMaker'
local greenArcherMaker	= require "scripts.greenArcherMaker"
local arrowMaker		   = require "scripts.arrowMaker"
local math2d 			   = require "plugin.math2d"

-- Variables
local baseWalkingAngle = {}
baseWalkingAngle["n"] = 0
baseWalkingAngle["ne"] = 45
baseWalkingAngle["e"] = 90
baseWalkingAngle["se"] = 135
baseWalkingAngle["s"] = 180
baseWalkingAngle["sw"] = 225
baseWalkingAngle["w"] = 270
baseWalkingAngle["nw"] = 315


-- Localizations
local mRand             = math.random
local getTimer          = system.getTimer
local pairs             = pairs

local addVec			   = math2d.add
local subVec			   = math2d.sub
local diffVec			   = math2d.diff
local lenVec			   = math2d.length
local len2Vec			   = math2d.length2
local normVec			   = math2d.normalize
local vector2Angle		= math2d.vector2Angle
local angle2Vector		= math2d.angle2Vector
local scaleVec			   = math2d.scale

-- 
--	 destroy()
-- 
function public.destroy()
end

-- 
--	 create()
-- 
function public.create( reticle )

   public.destroy()
   
   local layers = layersMaker.get()


	-- The Player (archer)
	--
	local player = greenArcherMaker.create( layers.content, common.centerX, common.centerY, 1 )
	physics.addBody( player, "dynamic", { radius = 25, filter = common.myCC:getCollisionFilter( "player" ) }  )
	player.colliderName = "player"
	player.myAngle = 0
	player:playAngleAnim( "paused", common.normRot( player.myAngle ) )
	player.baseAnim = "walking"

	player.rate 	= 250
	player.moveX 	= 0
	player.moveY 	= 0	
	player.myAngle 	= 0

	--
	-- Key listener for player (uses SSKs key event, which is a modified version of 'key' )
	--
	function player.key( self, event )
		if( not common.isRunning ) then return end
		if( common.autoIgnore( "key", self ) ) then  return end

		local descriptor = event.descriptor
		local phase 	= event.phase
		
		if( descriptor == "a" or  descriptor == "left" ) then
			self.moveX = self.moveX + ( (phase == "down" ) and -1 or 1 )
		
		elseif( descriptor == "d" or  descriptor == "right" ) then
			self.moveX = self.moveX + ( (phase == "down" ) and 1 or -1 )

		elseif( descriptor == "w" or  descriptor == "up" ) then
			self.moveY = self.moveY + ( (phase == "down" ) and -1 or 1 )
		
		elseif( descriptor == "s" or  descriptor == "down" ) then
			self.moveY = self.moveY + ( (phase == "down" ) and 1 or -1 )
		end	
		return false
	end
	common.listen( "key", player )

	--
	-- enterFrame Listener
	--
	function player.enterFrame( self, event )		
		if( not common.isRunning ) then return end

		if( common.autoIgnore( "enterFrame", self ) ) then return end 
      
      print( self.x, self.y )

		-- Facing 	
		--	
		if( reticle and common.isValid( reticle ) ) then
			local vec 	= diffVec( common.centerX, common.centerY, reticle.x, reticle.y, true )
			local angle = vector2Angle( vec )
			player.myAngle = angle 
		end


		-- Movement & Animation
		--
		if( self.moveY < 0 ) then			

			-- Start with a 'clean' angle.
			local walkAngle 	= common.normRot( self.myAngle )
			local angleDir 		= spriteMaker.angleToDir( walkAngle )
			walkAngle = baseWalkingAngle[angleDir]

			-- Modify the 'clean' angle based on touch inputs
			--
			-- Only allow forward motion and motion at a forward angle (left or right)
			--
			if( self.moveX > 0 ) then -- right
				walkAngle = walkAngle + 45
			
			elseif( self.moveX < 0 ) then -- left
				walkAngle = walkAngle - 45

			else -- neither left nor right
				-- No change
			end

			-- Normalize the angle. i.e. Bring it back into then range [0,360).
			walkAngle = common.normRot( walkAngle )
			--print("3 - walkAngle", walkAngle, self.myAngle)

			-- Forth, convert walking angle to a vector
			local vec = angle2Vector( walkAngle, true )

			-- Scale the vector
			vec = scaleVec( vec, self.rate )

			-- Set player velocity accordingly
			self:setLinearVelocity( vec.x, vec.y )
			player.baseAnim = "walking"

		else
			self:setLinearVelocity( 0, 0 )
			player.baseAnim = "paused"
		end

		-- Update Player's Animation
		player:playAngleAnim( self.baseAnim, common.normRot( player.myAngle ) )
      
      -- Limit Player's Movement
      if( self.x < common.leftLimit ) then 
         self.x = common.leftLimit 
      elseif( self.x > common.rightLimit ) then 
         self.x = common.rightLimit 
         end 
      if( self.y < common.upLimit ) then 
         self.y = common.upLimit 
      elseif( self.y > common.downLimit ) then 
         self.y = common.downLimit 
      end 

	end
	common.listen( "enterFrame", player )
	
	return player
end


return public