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
local redZombieMaker 	= require "scripts.redZombieMaker"
local greenZombieMaker 	= require "scripts.greenZombieMaker"
local bowSkelMaker 		= require "scripts.bowSkelMaker"
local arrowMaker		   = require "scripts.arrowMaker"
local math2d 			   = require "plugin.math2d"

-- Variables
local enemies = {}


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
   enemies = {}
end

-- 
--	 create()
-- 
function public.create( reticle )
   public.destroy()   
end

-- 
--	 count()
-- 
function public.getCount()
   return common.tableCount( enemies )
end

-- 
--	 generate()
-- 
function public.generate( )
	if( not common.isRunning ) then return end
	if( not common.isValid( common.player ) ) then return end
   
   print("Enemy count: ", common.tableCount( enemies ) )   
   if( common.tableCount( enemies )  >= common.maxEnemies ) then 
      timer.performWithDelay( common.enemyTweenTime, public.generate  )	
      return 
   end 
      
   local layers   = layersMaker.get()   
   local player   = common.player
   local myCC     = common.myCC
   
	local buffer 	= 50
	local size 		= 40
	local x, y

	local from = math.random(1,4)

	local left 		= player.x - common.fullw/2
	local right 	= player.x + common.fullw/2
	local top 		= player.y - common.fullh/2
	local bottom 	= player.y + common.fullh/2

	if( from == 1 ) then
		-- left
		x = left - buffer
		y = math.random( top - buffer, bottom + buffer )

	elseif( from == 2 ) then
		-- right
		x = right + buffer
		y = math.random( top - buffer, bottom + buffer )

	elseif( from == 3 ) then
		-- top
		x = math.random( left - buffer, right + buffer )
		y = top - buffer

	else
		-- bottom
		x = math.random( left - buffer, right + buffer )
		y = bottom + buffer
	end

	-- Create a basic enemy
	local enemy 
	if( mRand(1,100) > 66 ) then
		enemy = bowSkelMaker.create( layers.content, x, y, 1 )
	elseif( mRand(1,100) > 33 ) then
		enemy = greenZombieMaker.create( layers.content, x, y, 1 )
	else
		enemy = redZombieMaker.create( layers.content, x, y, 1 )
	end
	physics.addBody( enemy, "dynamic", { radius = size/2, density = 1, filter = myCC:getCollisionFilter( "enemy" ) }  )
	enemy.colliderName = "enemy"


	-- track the enemy so we can count enemies
	--
	enemies[enemy] = enemy
	if( enemyHUD ) then
		enemyHUD:update()
	end



	-- Basic collision handler
	--
	enemy.collision = function( self, event )
		local other = event.other
		if( other.colliderName ~= "player" ) then return false end
      
      post( "onPlayerDied" )
		return true
	end
	enemy:addEventListener( "collision" )

   --
   -- selfDestruct() - Clean up details about this enemy then destroy it.
   --
   function enemy.selfDestruct( self )
      transition.cancel( self )
      self:removeEventListener( "collision" )
      enemies[self] = nil      
      display.remove(self)
   end
   
   
   -- Simple movement to last player position
   --
   function enemy.moveToPlayer( self ) 
      if( not common.isRunning ) then return end 
      if( not common.isValid( self ) ) then return end
      local vec = diffVec( self, player )
      local angle = vector2Angle( vec ) 
      self.myAngle = angle
      local len = lenVec(vec)
      local speed = self.speed or math.random( 75, 150 )
      self.speed = speed
      local time = 1000 * len / speed 
      --print( angle, len, speed, time )
      
      self:playAngleAnim( "walking", common.normRot( angle ) )      
      
      transition.to( self, { x = player.x, y = player.y, time = time , onComplete = self } )
   end


   -- Use selfDestruct as onComplete
   -- OR keep going after player
   --enemy.onComplete = enemy.selfDestruct
   enemy.onComplete =  enemy.moveToPlayer

   enemy:moveToPlayer()

	-- Make another enemy in a little while
	--	
	timer.performWithDelay( common.enemyTweenTime, public.generate  )	
end





return public