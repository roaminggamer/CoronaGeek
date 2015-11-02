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
local sound 			= require "scripts.sound"
local common 			= require "scripts.common"
local bulletTrails 		= require "scripts.bulletTrails"
local spriteMaker 		= require 'scripts.spriteMaker'
local redZombieMaker 	= require "scripts.redZombieMaker"
local greenZombieMaker 	= require "scripts.greenZombieMaker"
local greenArcherMaker	= require "scripts.greenArcherMaker"
local arrowMaker		= require "scripts.arrowMaker"
local lostGarden		= require "scripts.lostGarden"
local camera 			= require "scripts.camera"

local math2d 			= require "plugin.math2d"


----------------------------------------------------------------------
--								DECLARATIONS						--
----------------------------------------------------------------------
-- Variables
local layers

local arrows = {}

local baseWalkingAngle = {}
baseWalkingAngle["n"] = 0
baseWalkingAngle["ne"] = 45
baseWalkingAngle["e"] = 90
baseWalkingAngle["se"] = 135
baseWalkingAngle["s"] = 180
baseWalkingAngle["sw"] = 225
baseWalkingAngle["w"] = 270
baseWalkingAngle["nw"] = 315


-- Forward Declarations

-- Localizations
local mRand             = math.random
local getTimer          = system.getTimer
local pairs             = pairs

local addVec			= math2d.add
local subVec			= math2d.sub
local diffVec			= math2d.diff
local lenVec			= math2d.length
local len2Vec			= math2d.length2
local normVec			= math2d.normalize
local vector2Angle		= math2d.vector2Angle
local angle2Vector		= math2d.angle2Vector
local scaleVec			= math2d.scale



----------------------------------------------------------------------
--								DEFINITIONS							--
----------------------------------------------------------------------
-- 
-- destroy() - Destroys the current level
--
function public.destroy( )	
	display.remove( layers )
	layers = nil
	arrows = {}

	if( public.isRunning ) then
		physics.pause() -- safer than stopping which might cause errors in future calls that 
	   		            -- come in enterFrame, collisio, or timer listeners
	end

	public.isRunning = false	   
end


-- 
-- create() - Creates a new level.
--
local lastGroup
function public.create( levelNum, group )	
	group = group or lastGroup or display.currentStage
	lastGroup = group
	
	--
	-- Destroy old level if it exists
	--
	public.destroy()

	--
	-- Create rendering layers for our game with this
	-- final Layer Order (bottom-to-top)
	--
	--[[

		display.currentStage\
							|---\background
							|
							|---\world 
							|		|---\underlay
							|		|
							|		|---\content 
							|		|
							|		|---\overlay
							|
							|---\interfaces
							
	--]]
	layers 				= display.newGroup()
	layers.background 	= display.newGroup()
	layers.world 		= display.newGroup()
	layers.underlay 	= display.newGroup()
	layers.content 		= display.newGroup()
	layers.overlay 		= display.newGroup()
	layers.interfaces 	= display.newGroup()

	layers:insert( layers.background )
	layers:insert( layers.world )
	layers:insert( layers.interfaces )

	layers.world:insert( layers.underlay )
	layers.world:insert( layers.content )
	layers.world:insert( layers.overlay )

	group:insert( layers )

	--
	-- Draw Background
	--
	public.createBack()


	--
	-- Draw World Content
	-- 
	local reticle 	= public.createReticle()
	local player 	= public.createPlayer( reticle )


	
	--
	-- Draw HUDS
	--

	-- TBD

	-- 
	-- Start The Camera
	-- 
	--camera.tracking( player, layers.world )
	
	--TBD


	public.isRunning = true
end


-- ==
--		Create Background (so we can see we are moving)
-- ==
function public.createBack()
	--
	-- Draw background grid
	--
	local gridSize 		= common.gridSize / 2 
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
			local tmp = lostGarden.create( layers.underlay, curX, curY, gridSize )
			tmp:setFillColor( unpack( gridColors[gridNum%2+1] ) )
			gridNum = gridNum + 1
			curY = curY + gridSize
		end
		gridNum = gridNum + 1 -- Force checker pattern
		curX = curX + gridSize
	end
end


-- ==
--			Create Reticle
-- ==
function public.createReticle()
	local reticle = display.newImageRect( layers.interfaces, "images/reticle2.png", 80, 80 )
	reticle.x = centerX
	reticle.y = 10000

	reticle.lastMouseFrame = curFrame - 1

	-- Mouse Listener - Reticle tracks position of mouse
	function reticle.mouse( self, event )
		if( self.lastMouseFrame == curFrame ) then return false end
		self.lastMouseFrame = curFrame

		if( not public.isRunning ) then return end

		if( common.autoIgnore( "mouse", self ) ) then  return end
		self.x = event.x
		self.y = event.y
	end
	common.listen( "mouse", reticle )

	return reticle
end


-- ==
--			Create Player
-- ==
function public.createPlayer( reticle )

	-- The Player (archer)
	--
	local player = greenArcherMaker.create( layers.content, centerX, centerY, 1 )
	physics.addBody( player, "dynamic", { radius = 25, filter = common.myCC:getCollisionFilter( "player" ) }  )
	player.colliderName = "player"
	player.myAngle = 0
	player:playAngleAnim( "paused", common.normRot( player.myAngle ) )
	player.baseAnim = "walking"

	player.rate 	= 250
	player.moveX 	= 0
	player.moveY 	= 0	
	player.myAngle 	= 0

	player.lastMouseFrame = curFrame - 1

	player.fired 		= false
	player.isFiring 	= false

	--
	-- Key listener for player (uses SSKs key event, which is a modified version of 'key' )
	--
	function player.key( self, event )
		if( not public.isRunning ) then return end
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
		if( not public.isRunning ) then return end

		if( common.autoIgnore( "enterFrame", self ) ) then return end 

		-- Facing 	
		--	
		if( reticle and common.isValid( reticle ) ) then
			local vec 	= diffVec( centerX, centerY, reticle.x, reticle.y, true )
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


		-- Fire Arrows
		if( self.isFiring ) then
			player.baseAnim = "shooting"
		end


		-- Update Player's Animation
		player:playAngleAnim( self.baseAnim, common.normRot( player.myAngle ) )

	end
	common.listen( "enterFrame", player )
	
	return player
end


return public