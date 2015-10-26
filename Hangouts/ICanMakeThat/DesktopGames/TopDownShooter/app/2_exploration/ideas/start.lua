-- =============================================================
-- Copyright Roaming Gamer, LLC. 2009-2015 
-- =============================================================
-- 
-- =============================================================
local public = {}

----------------------------------------------------------------------
--								REQUIRES							--
----------------------------------------------------------------------
local physics 		= require "physics"
local common 		= require "scripts.common"

----------------------------------------------------------------------
--								DECLARATIONS						--
----------------------------------------------------------------------
-- Variables
local layers
local myCC

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
	physics.pause() -- safer than stopping which might cause errors in future calls that 
	                -- come in enterFrame, collisio, or timer listeners

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
	local player = public.createPlayer()
	public.createEnemies()
	public.createOther()

	--
	-- Attach a camera to the player	
	--
	ssk.camera.tracking( player, layers.world, { debugEn = true } )
	--ssk.camera.trackingLooseSquare( player, layers.world, { debugEn = true } )
	--ssk.camera.trackingLooseCircle( player, layers.world, { debugEn = true } )

	--
	-- Mark idea as running
	--
	public.isRunning = true
end


-- ==
--			Create Player
-- ==
function public.createPlayer()
	local player = newImageRect( layers.content, centerX, centerY, "images/smiley.png",
		{ size = 50 }, 
		{ bodyType = "dynamic", calculator = myCC, colliderName = "player" } )

	player.rate 	= 250
	player.moveX 	= 0
	player.moveY 	= 0	

	--
	-- Key listener for player (uses SSKs key event, which is a modified version of 'key' )
	--
	function player.ON_KEY( self, event )
		if( not public.isRunning ) then return end
		if( autoIgnore( "ON_KEY", self ) ) then  return end

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
	end; listen( "ON_KEY", player )


	--
	-- enterFrame Listener
	--
	function player.enterFrame( self, event )		
		if( not public.isRunning ) then return end
		if( autoIgnore( "enterFrame", self ) ) then return end 
		--local logger = require "scripts.logger"
		--logger._print(public.isRunning, self.moveX, self.moveY)
		--print(public.isRunning, self.moveX, self.moveY)
		if( self.moveX ~= 0 or self.moveY ~= 0 ) then			
			local vec = { x = self.moveX, y = self.moveY }			
			vec = scaleVec( vec, self.rate )
			self:setLinearVelocity( vec.x, vec.y )
		else
			self:setLinearVelocity( 0, 0 )
		end
	end; listen( "enterFrame", player )
	
	return player
end


-- ==
--			Create Enemies
-- ==
function public.createEnemies()
end

-- ==
--			Create Other World Stuff
-- ==
function public.createOther()
end

-- ==
--			Create Background
-- ==
function public.createBack()
	--
	-- Draw background grid
	--
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

end

return public