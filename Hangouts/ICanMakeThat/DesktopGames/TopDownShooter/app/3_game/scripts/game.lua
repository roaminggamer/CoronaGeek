-- =============================================================
-- Copyright Roaming Gamer, LLC. 2009-2015 
-- =============================================================
-- This content produced for Corona Geek Hangouts audience.
-- You may use any and all contents in this example to make a game or app.
-- =============================================================
local curFrame = 0
listen( "enterFrame", function() curFrame = curFrame + 1 end )

local public = {}

----------------------------------------------------------------------
--								REQUIRES							--
----------------------------------------------------------------------
local physics 			   = require "physics"
local common 			   = require "scripts.common"

-- Makers (builder)
local layersMaker		   = require "scripts.layersMaker"
local debugMaker 		   = require "scripts.debugMaker"

local groundMaker 		= require "scripts.groundMaker"
local reticleMaker 		= require "scripts.reticleMaker"
local playerMaker 		= require "scripts.playerMaker"
local enemyManager 		= require "scripts.enemyManager"

-- Managers
local cameraMgr 			= require "scripts.cameraMgr"

----------------------------------------------------------------------
--								DECLARATIONS						--
----------------------------------------------------------------------
-- Variables

-- Forward Declarations

-- Localizations
local mRand             = math.random
local getTimer          = system.getTimer
local pairs             = pairs

----------------------------------------------------------------------
--								DEFINITIONS							--
----------------------------------------------------------------------

-- 
-- destroy() - Destroys the current level
--
function public.destroy( )	
	if( common.isRunning ) then
		--physics.pause() -- safer than stopping which might cause errors in future calls that 
	   		            -- come in enterFrame, collisio, or timer listeners
	end
   
   common.isRunning = false	 
   
	
   enemyManager.destroy()
   cameraMgr.detach()
   playerMaker.destroy()
   reticleMaker.destroy()
   layersMaker.destroy()	  
end


-- 
-- create() - Creates a new level.
--
function public.create( group )	
	--
	-- Destroy old level if it exists
	--
	public.destroy()
   
   -- Start Physics
   --
   --physics.start() 
   
   --
   -- Set up rendering layers for this 'game'
   --
   local layers = layersMaker.create( group )
   
	--
	-- Draw Background
	--
	groundMaker.create()

   --
	-- Draw World Content
	-- 
	local reticle 	= reticleMaker.create()
	local player 	= playerMaker.create( reticle )
   enemyManager.create()

   debugMaker.showPlayerMovementLimit()

	-- 
	-- Start The Camera
	-- 
	cameraMgr.attach( player )
   --cameraMgr.detach()
	 
	common.isRunning = true
   
   enemyManager.generate()
end

--
-- Temporary listener to catch 'onDied' event and restart game.
--
-- We'll handle this better later, but for now, this gives us a 
-- reasonable response to getting hit by enemies.
--
local function onPlayerDied( )
   -- Wait till the next frame, then restart (let's this frame's work complete)
   timer.performWithDelay( 1, function ()  public.create() end )
   --print("BOB")
end
listen( "onPlayerDied", onPlayerDied )


return public