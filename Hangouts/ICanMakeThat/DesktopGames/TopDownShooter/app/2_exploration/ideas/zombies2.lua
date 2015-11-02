-- =============================================================
-- Copyright Roaming Gamer, LLC. 2009-2015 
-- =============================================================
-- 
-- =============================================================
local curFrame = 0
listen( "enterFrame", function() curFrame = curFrame + 1 end )

local public = {}


----------------------------------------------------------------------
--								REQUIRES							--
----------------------------------------------------------------------
local physics 			= require "physics"
local common 			= require "scripts.common"
local bulletTrails 		= require "scripts.bulletTrails"
local spriteMaker 		= require 'scripts.spriteMaker'
local redZombieMaker 	= require "scripts.redZombieMaker"
local greenZombieMaker 	= require "scripts.greenZombieMaker"
local greenArcherMaker	= require "scripts.greenArcherMaker"

----------------------------------------------------------------------
--								DECLARATIONS						--
----------------------------------------------------------------------
-- Variables
local layers
local myCC

local enemies = {}
local bullets = {}

local maxBullets = -1

local tweenHUD
local scoreHUD 
local enemyHUD
local bulletHUD

local currentScore = 0

local enemyTweenTime 	= 2000
local deltaTween 		= 25
local minTween 			= 500

-- Forward Declarations


-- Useful Localizations
-- SSK
--
local newCircle 		= ssk.display.newCircle
local newRect 			= ssk.display.newRect
local newImageRect 		= ssk.display.newImageRect
local newAngleLine 		= ssk.display.newAngleLine
local easyIFC   		= ssk.easyIFC
local oleft 			= ssk.misc.oleft
local oright 			= ssk.misc.oright
local otop 				= ssk.misc.otop
local obottom			= ssk.misc.obottom
local isInBounds    	= ssk.easyIFC.isInBounds
local secondsToTimer	= ssk.misc.secondsToTimer
local isValid 			= display.isValid

local normRot			= ssk.misc.normRot

local addVec			= ssk.math2d.add
local subVec			= ssk.math2d.sub
local diffVec			= ssk.math2d.diff
local lenVec			= ssk.math2d.length
local len2Vec			= ssk.math2d.length2
local normVec			= ssk.math2d.normalize
local vector2Angle		= ssk.math2d.vector2Angle
local angle2Vector		= ssk.math2d.angle2Vector
local scaleVec			= ssk.math2d.scale


-- Corona & Lua
--
local mAbs              = math.abs
local mRand             = math.random
local mDeg              = math.deg
local mRad              = math.rad
local mCos              = math.cos
local mSin              = math.sin
local mAcos             = math.acos
local mAsin             = math.asin
local mSqrt             = math.sqrt
local mCeil             = math.ceil
local mFloor            = math.floor
local mAtan2            = math.atan2
local mPi               = math.pi

local getInfo           = system.getInfo
local getTimer          = system.getTimer
local strMatch          = string.match
local strFormat         = string.format
local pairs             = pairs

----------------------------------------------------------------------
--								DEFINITIONS							--
----------------------------------------------------------------------

-- 
-- destroy() - Creates a new level.
--
function public.destroy()	
	local physics = require "physics"	
	display.remove(layers)
	
	layers = nil
	tweenHUD = nil
	scoreHUD = nil
	enemyHUD = nil
	bulletHUD = nil
	enemies = {}
	bullets = {}
	currentScore = 0
	
	if( public.isRunning ) then
		physics.pause() -- safer than stopping which might cause errors in future calls that 
	   		            -- come in enterFrame, collisio, or timer listeners
	end

	-- reset tween time
	enemyTweenTime = 2000

	public.isRunning = false	                
end

-- 
-- create() - Creates a new level.
--
local lastGroup
function public.create( group )	
	group = group or lastGroup or display.currentStage
	lastGroup = group

	--
	-- Destroy old level if it exists
	--
	public.destroy()

	--
	-- Initialize Physics
	--
	local physics = require "physics"	
	physics.start()
	--physics.setDrawMode( "hybrid" )
	print("started physics")
	physics.setGravity(0,0)

	--
	-- Create rendering layers for our game with this
	-- final Layer Order (bottom-to-top)
	--
	layers = ssk.display.quickLayers( group, 
		"background",
		"world",
			{
				"underlay",
				"content",
				"overlay"
			} , 
		"interfaces" )

	--
	-- Set up collision calculator
	--
	myCC = ssk.ccmgr:newCalculator()
	myCC:addNames( "player", "enemy", "playerbullet", "enemybullet", "other" )
	myCC:collidesWith( "player", { "enemy", "enemybullet" } )
	myCC:collidesWith( "enemy", { "player", "playerbullet" } )
	myCC:collidesWith( "other", { "player", "playerbullet", "enemybullet" } )

	--
	-- Call various builders
	--	
	public.createBack()
	local reticle 	= public.createReticle()
	local player 	= public.createPlayer( reticle )
	
	timer.performWithDelay( 150, function() public.createEnemies( player )  end  )
	public.createOther()

	public.createHUDs()
	--
	-- Attach a camera to the player	
	--
	ssk.camera.tracking( player, layers.world )

	--
	-- Mark idea as running
	--
	public.isRunning = true


end

-- ==
--			Create Player
-- ==
function public.createPlayer( reticle )
	----[[
	local player = greenArcherMaker.create( layers.content, centerX, centerY, 1 )
	physics.addBody( player, "dynamic", { radius = 25, filter = myCC:getCollisionFilter( "player" ) }  )
	player.colliderName = "player"
	player.myAngle = 0
	player:playAngleAnim( "paused", normRot( player.myAngle ) )
	player.baseAnim = "walking"
	--]]
	--[[
	local player = newImageRect( layers.content, centerX, centerY, "images/up.png",
		{ size = 50 }, 
		{ radius = 25, bodyType = "dynamic", calculator = myCC, colliderName = "player" } )

	--]]


	player.rate 	= 250
	player.moveX 	= 0
	player.moveY 	= 0	

	player.lastMouseFrame = curFrame - 1

	player.isFiring 	= false
	player.autoFire 	= true
	player.fired 		= false

	--
	-- Key listener for player (uses SSKs key event, which is a modified version of 'key' )
	--
	function player.key( self, event )
		if( not public.isRunning ) then return end
		if( autoIgnore( "key", self ) ) then  return end

		local descriptor = event.descriptor
		local phase = event.phase
		
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
	end; listen( "key", player )


	function player.mouse( self, event )
		local isCtrlDown 	= event.isCtrlDown
		local isCommandDown	= event.isCommandDown
		local isAltDown 	= event.isAltDown
		local isShiftDown 	= event.isShiftDown
		
		local primary 		= event.isPrimaryButtonDown
		local secondary 	= event.isSecondaryButtonDown
		local middle 		= event.isMiddleButtonDown
		local time 			= event.time

		if( not public.isRunning ) then return end
		if( autoIgnore( "mouse", self ) ) then  return end
		--self.x = event.x
		--self.y = event.y
		self.isFiring = (primary and self.autoFire)

		if( not self.autoFire ) then
			if( self.fired and not primary ) then
				self.fired = false
			end
			if( not self.fired and primary ) then
				self.fired = true
				public.createBullet( self )
			end
		end

	end
	listen( "mouse", player )


	--
	-- enterFrame Listener
	--
	function player.enterFrame( self, event )		
		if( not public.isRunning ) then return end
		if( autoIgnore( "enterFrame", self ) ) then return end 
		--local logger = require "scripts.logger"
		--logger._print(public.isRunning, self.moveX, self.moveY)
		--print(public.isRunning, self.moveX, self.moveY)

		-- Movement
		if( self.moveX ~= 0 or self.moveY ~= 0 ) then			
			local vec = { x = self.moveX, y = self.moveY }			
			vec = scaleVec( vec, self.rate )
			self:setLinearVelocity( vec.x, vec.y )
			player.baseAnim = "walking"
		else
			self:setLinearVelocity( 0, 0 )
			player.baseAnim = "paused"
		end

		-- Facing 		
		if( reticle and isValid( reticle ) ) then
			local vec 	= diffVec( centerX, centerY, reticle.x, reticle.y, true )
			local angle = vector2Angle( vec )
			player.myAngle = angle 
		end

		-- Fire Bullets
		if( self.isFiring ) then
			public.createBullet( player )
			player.baseAnim = "shooting"
		end

		-- Update Player's Animation
		player:playAngleAnim( self.baseAnim, normRot( player.myAngle ) )

	end; listen( "enterFrame", player )
	
	return player
end

-- ==
--			Create Enemies
-- ==

function public.createEnemies( player )
	if( not public.isRunning ) then return end
	if( not isValid( player ) ) then return end

	local buffer 	= 50
	local size 		= 40
	local x, y

	local from = math.random(1,4)

	local left 		= player.x - fullw/2
	local right 	= player.x + fullw/2
	local top 		= player.y - fullh/2
	local bottom 	= player.y + fullh/2

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
	if( mRand(1,100) > 50 ) then
		enemy = greenZombieMaker.create( layers.content, x, y, 1 )
	else
		enemy = redZombieMaker.create( layers.content, x, y, 1 )
	end
	physics.addBody( enemy, "dynamic", { radius = size/2, filter = myCC:getCollisionFilter( "enemy" ) }  )
	enemy.colliderName = "enemy"


	-- track the enemy so we can count enemies
	--
	enemies[enemy] = enemy
	if( enemyHUD ) then
		enemyHUD:update()
	end

	-- Simple movement to last player position
	--
	local vec = { x = x,  y = y }
	vec = diffVec( player, vec )
	local rotation = vector2Angle( vec )
	local len = lenVec(vec)
	local speed = math.random( 50, 200 )
	local time = 1500 * len / speed

	local angle = vector2Angle( -vec.x, -vec.y )
	enemy:playAngleAnim( "walking", normRot( angle ) )
	enemy.myAngle = angle


	-- Basic collision handler
	--
	enemy.collision = function( self, event )
		local other = event.other
		if( other.colliderName ~= "player" ) then return false end
		post( "onDied" )
		return true
	end
	enemy:addEventListener( "collision" )


	-- do a little clean up when done moving, including removing enemy, stopping tracking, and updating counter
	enemy.onComplete =
		function( self ) 
			display.remove( self )
			enemies[self] = nil
			if( enemyHUD ) then
				enemyHUD:update()
			end
		end
	transition.to( enemy, { x = player.x, y = player.y, time = time , onComplete = enemy } )

	-- Make another enemy in a little while
	--	
	timer.performWithDelay( enemyTweenTime, function() public.createEnemies( player )  end  )	

	-- Make appearances gradually more frequent
	--
	enemyTweenTime = enemyTweenTime - deltaTween
	if( enemyTweenTime < minTween ) then enemyTweenTime = minTween end

	-- If the HUD exists, update its value
	if( tweenHUD ) then
		tweenHUD:update()
	end
end


-- ==
--			Create Bullets
-- ==
local bulletsPerSecond 		= 5
local bulletPeriod 			= 1000/bulletsPerSecond
local bulletLifetime 		= 2000
local bulletSpeed 			= 500 -- pixels per seconbd
local lastBulletTime 	= getTimer()

function public.createBullet( barrel )

	-- Are bullet limits enabled?
	--
	if( maxBullets > 0 and table.count(bullets) >= maxBullets ) then return end


	-- Limit fire rate
	local curTime = getTimer()
	if( curTime - lastBulletTime < bulletPeriod ) then return end

	-- Update bullet time
	lastBulletTime = curTime

	-- Create a bullet
	local bullet = newCircle( barrel.parent, barrel.x, barrel.y, 
			{ radius = 5, fill = _G_ }, 
			{ bodyType = "dynamic", calculator = myCC, colliderName = "playerbullet", 
			  isBullet = true, isSensor = true } )	
	bullet:toBack() -- start underneath player
	
	-- keep track of the bullet so we can count bullets
	--
	bullets[bullet] = bullet
	if( bulletHUD ) then
		bulletHUD:update()
	end

	-- Make the bullet move
	local vec = angle2Vector( barrel.myAngle, true ) -- no longer rotating player
	vec = scaleVec( vec, bulletSpeed )
	bullet:setLinearVelocity( vec.x, vec.y )

	-- Auto-destroy bullet after lifetime expires
	bullet.timer = 
		function( self )
			display.remove( self )
			bullets[self] = nil
			if( bulletHUD ) then
				bulletHUD:update()
			end
		end

	timer.performWithDelay( bulletLifetime, bullet )

	-- Basic collision handler
	--
	bullet.collision = function( self, event )
		local other = event.other

		if( other.colliderName ~= "enemy" ) then return false end

		display.remove( self )
		bullets[self] = nil
		if( bulletHUD ) then
			bulletHUD:update()
		end


		-- Stop the enemy
		transition.cancel(other)

		-- Don't allow any more collisions with this enemy
		other:removeEventListener("collision")
		
		-- Play an animation and then remove
		other:playAngleAnim( "disintegrate", normRot( other.myAngle ) )
		function other.sprite( self, event )
			--print()
			if( event.phase == "ended" ) then
				display.remove( self )
				enemies[self] = nil -- For now, we know ONLY enemies are being hit
				if( enemyHUD ) then
					enemyHUD:update()
				end
				currentScore = currentScore  + 10
				if( scoreHUD ) then
					scoreHUD:update()
				end
			end
		end
		other:addEventListener( "sprite" )

		return true
	end
	bullet:addEventListener( "collision" )

	-- Add a Cool Trail
	--
	bulletTrails.addTrail( bullet, 1 )
end

-- ==
--			Create Other World Stuff
-- ==
function public.createOther()
end

-- ==
--			Create Reticle
-- ==
function public.createReticle()
	local reticle = newImageRect( layers.interfaces, 10000, 10000, "images/reticle2.png", { size = 80 } )

	reticle.lastMouseFrame = curFrame - 1

	function reticle.mouse( self, event )
		if( self.lastMouseFrame == curFrame ) then return false end
		self.lastMouseFrame = curFrame

		local isCtrlDown 	= event.isCtrlDown
		local isCommandDown	= event.isCommandDown
		local isAltDown 	= event.isAltDown
		local isShiftDown 	= event.isShiftDown
		
		local primary 		= event.isPrimaryButtonDown
		local secondary 	= event.isSecondaryButtonDown
		local middle 		= event.isMiddleButtonDown
		local time 			= event.time

		if( not public.isRunning ) then return end
		if( autoIgnore( "mouse", self ) ) then  return end
		self.x = event.x
		self.y = event.y
	end
	listen( "mouse", reticle )

	return reticle
end

-- ==
--		Create Background (so we can see we are moving)
-- ==
function public.createBack()
	--
	-- Draw background grid
	--
	--[[
	local gridSize 		= common.gridSize
	local worldSize 	= common.worldSize
	local startX 		= centerX - (worldSize * gridSize)/2 - gridSize/2
	local startY 		= centerY - (worldSize * gridSize)/2 - gridSize/2
	local gridColors 	= common.gridColors
	local curX			= startX
	local curY			= startY
	local gridNum 		= 0

	for col = 1, worldSize do
		curY = startY
		for row = 1, worldSize do
			local tmp = display.newRect( layers.underlay, curX, curY, gridSize, gridSize )
			tmp:setFillColor( unpack( gridColors[gridNum%2+1]))
			gridNum = gridNum + 1
			curY = curY + gridSize
		end
		gridNum = gridNum + 1 -- Force checker pattern
		curX = curX + gridSize
	end
	--]]


	local w = 570 * 2
	local h = 380 * 2
	newImageRect( layers.underlay, centerX, centerY, "images/LostGardenBack.png", { w = w, h = h } )
	newImageRect( layers.underlay, centerX - w, centerY, "images/LostGardenBack.png", { w = w, h = h } )
	newImageRect( layers.underlay, centerX + w, centerY, "images/LostGardenBack.png", { w = w, h = h } )

	newImageRect( layers.underlay, centerX, centerY - h, "images/LostGardenBack.png", { w = w, h = h } )
	newImageRect( layers.underlay, centerX - w, centerY - h, "images/LostGardenBack.png", { w = w, h = h } )
	newImageRect( layers.underlay, centerX + w, centerY - h, "images/LostGardenBack.png", { w = w, h = h } )

	newImageRect( layers.underlay, centerX, centerY + h, "images/LostGardenBack.png", { w = w, h = h } )
	newImageRect( layers.underlay, centerX - w, centerY + h, "images/LostGardenBack.png", { w = w, h = h } )
	newImageRect( layers.underlay, centerX + w, centerY + h, "images/LostGardenBack.png", { w = w, h = h } )


end

-- ==
--		Create Basic Metric Huds
-- ==
function public.createHUDs()

	easyIFC:quickLabel( layers.interfaces, "Zombies + Partial Fix", left + 10, top + 50, gameFont, 24, _W_, 0)

	-- Time till next enemy
	tweenHUD = easyIFC:quickLabel( layers.interfaces, "", centerX - 200, top + 30, gameFont, 24, _W_, 0)
	tweenHUD.update = function( self )
		self.text = "Next Enemy in " .. string.format("%2.3f", round( enemyTweenTime/ 1000, 4 )) .. " seconds"
	end
	tweenHUD:update()

	-- Our Score
	scoreHUD = easyIFC:quickLabel( layers.interfaces, "", centerX - 200, top + 60, gameFont, 24, _W_, 0 )
	scoreHUD.update = function( self )
		self.text = "Score: " .. tostring( currentScore )
	end
	scoreHUD:update()

	-- Enemies out there
	enemyHUD = easyIFC:quickLabel( layers.interfaces, "", centerX - 200, bottom - 60, gameFont, 24, _W_, 0 )
	enemyHUD.update = function( self )
		self.text = "Enemies: " .. tostring( table.count( enemies ) )
	end
	enemyHUD:update()

	-- Bullets out there
	bulletHUD = easyIFC:quickLabel( layers.interfaces, "", centerX - 200, bottom - 30, gameFont, 24, _W_, 0 )
	bulletHUD.update = function( self )
		if( maxBullets > 0 ) then
			self.text = "Bullets: " .. tostring( table.count( bullets ) ) .. " Max: ( " .. tostring(maxBullets) .. " )"
		else
			self.text = "Bullets: " .. tostring( table.count( bullets ) )
		end
		
	end
	bulletHUD:update()


end



return public