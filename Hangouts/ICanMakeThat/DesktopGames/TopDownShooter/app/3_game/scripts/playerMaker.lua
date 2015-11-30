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

local arrows = {}

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
   if( common.isValid( common.player ) ) then
      common.ignore( "enterFrame", common.player )
      common.ignore( "mouse", common.player )
      common.ignore( "key", common.player )
   end
   common.player = nil
   arrows = {}
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
	
   -- Various player flags and values used in animations, walking, firing, etc.
   player.colliderName = "player"
	player.myAngle       = 0	
	player.baseAnim      = "paused"
	player.rate 	      = 250
	player.moveY 	      = 0
	player.myAngle 	   = 0
   player.isFiring      = false

   -- Set player to 'paused' animation to start
	player:playAngleAnim( player.baseAnim, common.normRot( player.myAngle ) )
	
   -- Key listener for player (uses SSKs key event, which is a modified version of 'key' )
	--
	function player.key( self, event )
		if( not common.isRunning ) then return end
      if( not common.isValid( self ) ) then return end

		local descriptor = event.descriptor
		local phase 	= event.phase
      
      if( descriptor == "w" or  descriptor == "up" ) then		
         if( phase == "down" ) then
            self.moveY = -1
         else
            self.moveY = 0
         end
      end
         
		
		return false
	end
	common.listen( "key", player )


	function player.mouse( self, event )
		if( not common.isRunning ) then return end
      if( not common.isValid( self ) ) then return end

		local primary 		= event.isPrimaryButtonDown

		if( self.isFiring == false and primary) then
			self.isFiring = true
			self.lastBaseAnim = self.baseAnim
			self.baseAnim = "shooting"
			timer.performWithDelay( 100,
				function()						
               self:fireArrow( false ) -- true says 'do debug'
					self.fired = true
				end )
			timer.performWithDelay( 250,
				function()												
					self.isFiring = false
				end )
		end

	end
	common.listen( "mouse", player )


	--
	-- enterFrame Listener
	--
	function player.enterFrame( self, event )		
		if( not common.isRunning ) then return end
      if( not common.isValid( self ) ) then return end
      if( not self.x or not self.setLinearVelocity ) then
         print( self.x, self.setLinearVelocity )
      end
      
      -- DEBUG: shows position of player right now
      --print( self.x, self.y )

		-- Facing 	
		--	
		if( reticle and common.isValid( reticle ) ) then
			local vec 	= diffVec( common.centerX, common.centerY, reticle.x, reticle.y, true )
			local angle = vector2Angle( vec )
			self.myAngle = angle 
		end


		-- Movement & Animation
		--
		if( self.moveY < 0 ) then			

			-- Start with a 'clean' angle.
			local walkAngle 	= common.normRot( self.myAngle )
			local angleDir 		= spriteMaker.angleToDir( walkAngle )
			walkAngle = baseWalkingAngle[angleDir]

			-- Normalize the angle. i.e. Bring it back into then range [0,360).
			walkAngle = common.normRot( walkAngle )
			--print("3 - walkAngle", walkAngle, self.myAngle)

			-- Forth, convert walking angle to a vector
			local vec = angle2Vector( walkAngle, true )

			-- Scale the vector
			vec = scaleVec( vec, self.rate )

			-- Set player velocity accordingly
			self:setLinearVelocity( vec.x, vec.y )
			self.baseAnim = "walking"

		else
			self:setLinearVelocity( 0, 0 )
			self.baseAnim = "paused"
		end
      
      -- Firing Arrows
		if( self.isFiring ) then
			self.baseAnim = "shooting"
		end      

		-- Update Player's Animation
		self:playAngleAnim( self.baseAnim, common.normRot( self.myAngle ) )
      
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
      
   -- ==
   --			Create Arrows
   -- ==
   local lastArrowTime = getTimer()

   function player.fireArrow( self, doDebug )

      if( not common.isRunning ) then return end

      -- Are arrow limits enabled?
      --
      if( common.maxArrows > 0 and common.tableCount(arrows) >= common.maxArrows ) then return end

      -- Limit fire rate
      local curTime = getTimer()
      if( curTime - lastArrowTime < common.arrowPeriod ) then return end

      -- Update arrow time
      lastArrowTime = curTime

      -- Create a arrow
      local arrow = arrowMaker.create( layers.content, self.x, self.y, self.myAngle,  1 )
      physics.addBody( arrow, "dynamic", { radius =  10, density = 0.2, filter = common.myCC:getCollisionFilter( "playerarrow" ), isBullet = true }  )
      arrow.colliderName = "playerarrow"

      --arrow.strokeWidth = 3
      
      -- keep track of the arrow so we can count arrows
      --
      arrows[arrow] = arrow

      -- Make the arrow move
      if( doDebug ) then
         
         local vec = angle2Vector( self.myAngle, true ) -- no longer rotating player
         -- DEBUG STEP 1 - BEGIN
         local label = display.newText( self.parent, self.myAngle, self.x, self.y - 50, native.systemFont, 22 )
         local aimVec = scaleVec( vec, 50 )
         aimVec = addVec( self, aimVec )
         local aimLine = display.newLine( self.parent, self.x, self.y, aimVec.x, aimVec.y )
         aimLine.strokeWidth = 3
         aimLine:setStrokeColor(1,1,0)
         -- DEBUG STEP 1 - END
         
         vec = scaleVec( vec, common.arrowSpeed )
         
         nextFrame( 
            function()
               -- DEBUG STEP 2 - BEGIN              
               display.remove( aimLine )
               local aimVec = normVec( vec )
               aimVec = scaleVec( aimVec, common.arrowSpeed ) 
               aimVec = addVec( aimVec, self )
               aimLine = display.newLine( self.parent, self.x, self.y, aimVec.x, aimVec.y )
               aimLine.strokeWidth = 3
               aimLine:setStrokeColor(1,0,0)               
               -- DEBUG STEP 2 - END
            end, 400 )
         
         -- DEBUG STEP 3 - BEGIN
         arrow:setLinearVelocity( vec.x, vec.y )
         -- DEBUG STEP 3 - END
         
         -- DEBUG STEP 4 .. 5 - BEGIN
         timer.performWithDelay( 500, function() 
                  print( arrow.x, arrow.y )
               end )
         timer.performWithDelay( 1000, function() 
                  print( arrow.x, arrow.y ) 
                  display.remove( aimLine )
                  display.remove( label )
               end)
         -- DEBUG STEP 4 .. 5 - END

         -- Auto-destroy arrow after lifetime expires
         arrow.timer = 
            function( self )
               display.remove( self )
               arrows[self] = nil
            end

         timer.performWithDelay( common.arrowLifetime, arrow )
      
      else         
         local vec = angle2Vector( self.myAngle, true ) -- no longer rotating player
         vec = scaleVec( vec, common.arrowSpeed )
         arrow:setLinearVelocity( vec.x, vec.y )

         -- Auto-destroy arrow after lifetime expires
         arrow.timer = 
            function( self )
               display.remove( self )
               arrows[self] = nil
            end

         timer.performWithDelay( common.arrowLifetime, arrow )
      end

      -- Basic collision handler
      --
      arrow.collision = function( self, event )
         local other = event.other
         
         if( other.colliderName ~= "enemy" ) then return false end

         display.remove( self )

         arrows[self] = nil

         -- Stop the enemy
         transition.cancel(other)

         -- Don't allow any more collisions with this enemy
         other:removeEventListener("collision")
         
         -- Mark enemy as destroyed (to stop AI)
         --
         other.isDestroyed = true
         
         -- Play an animation and then remove
         other:playAngleAnim( "disintegrate", common.normRot( other.myAngle ) )
         function other.sprite( self, event )
            --print()
            if( event.phase == "ended" ) then
               --self:selfDestruct()
               self:delayedSelfDestruct( 100000 )
            end
         end
         other:addEventListener( "sprite" )

         return true
      end
      arrow:addEventListener( "collision" )

      -- Add a Cool Trail
      --
      --arrowTrails.addTrail( arrow, 1 )
   end
   
   -- Store reference to player in common
   common.player = player
	
	return player
end


return public