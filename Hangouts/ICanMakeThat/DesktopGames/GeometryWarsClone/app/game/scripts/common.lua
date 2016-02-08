-- =============================================================
-- Copyright Roaming Gamer, LLC. 2009-2015 
-- =============================================================
-- This content produced for Corona Geek Hangouts audience.
-- You may use any and all contents in this example to make a game or app.
-- =============================================================

local common = {}

-- Debug Features
common.meterEn       = false
common.showSpawnGrid = false
common.showCounts    = false

-- Optimizations
common.particleStyle = 1 -- 1 discrete lines; 2 discrete circles 

--
-- World Settings
--
common.gridSize 	   = 30 --36 -- set to 40 for debugging and demo 80 otherwise
common.worldWidth 	= 45 --25-- # gridSize units wide
common.worldHeight   = 35 --15 -- # gridSize units tall

common.leftBorder    = centerX - common.gridSize * common.worldWidth/2 
common.rightBorder   = centerX + common.gridSize * common.worldWidth/2
common.upBorder      = centerY - common.gridSize * common.worldHeight/2
common.downBorder    = centerY + common.gridSize * common.worldHeight/2

common.leftLimit     = common.leftBorder + common.gridSize/2
common.rightLimit    = common.rightBorder - common.gridSize/2
common.upLimit       = common.upBorder + common.gridSize/2
common.downLimit     = common.downBorder - common.gridSize/2


-- Player
common.playerSize    = 50
common.nextLife      = 10000 -- Get new life every 10K points
common.nextMine      = 15000 -- Get new mine every 15K points
common.startLives    = 3 -- Number of lives to start with on fresh game
common.startMines    = 3 -- Number of mines to start with on fresh game
common.curLives      = common.startLives
common.curMines      = common.startMines

-- Enemies
common.enemySize        = 40
common.enemyTweenTime   = 500
common.enemySpawnOffset = 150
common.enemies          = {}
--common.enemyDebugSpeed = 1 -- uncomment and set to some pixels-per-second value while debbugging
common.maxEnemies       = 1      -- (starting) Max Enemies
common.maxEnemiesCap    = 100    -- (all time) Max Enemies


-- Difficulty
common.msPerLevel       = 1000   -- Increase difficulty one level per second
common.difficultyStart  = 0      -- Start at 0 difficulty


--
-- Input Control Selection
--
common.forceMode     = "auto" -- "auto" - Select using game logic; 
                              -- "mobile"/"desktop" - Force to one of these modes for testing

if( onMobile or common.forceMode == "mobile" ) then
   common.inputStyle    = "mobile" 
else
   common.inputStyle    = "desktop"
end


-- HANGOUT 179 / 180+ - This code sets up the collision 'filters' for our game using names instead of math.. :)
--
-- Collision Calculator For Easy Collision Calculations
--
local ccmgr = require "plugin.cc"

common.myCC = ccmgr:newCalculator()
common.myCC:addNames( "player", "enemy", "playerbullet", "enemybullet", "wall", "blackhole", "pickup", "spawnSensor"  )
common.myCC:collidesWith( "player", { "enemy", "enemybullet", "wall", "blackhole", "pickup", "spawnSensor" } )
common.myCC:collidesWith( "enemy", { "player", "playerbullet", "wall", "blackhole" } )


--
-- Helper Functions
--

-- Normalize Rotations - Force rotation (number of object.rotation ) to be in range [ 0, 360 )
--
function common.normRot( toNorm )
	if( type(toNorm) == "table" ) then
		while( toNorm.rotation >= 360 ) do toNorm.rotation = toNorm.rotation - 360 end		
		while( toNorm.rotation < 0 ) do toNorm.rotation = toNorm.rotation + 360 end
		return 
	else
		while( toNorm >= 360 ) do toNorm = toNorm - 360 end
		while( toNorm < 0 ) do toNorm = toNorm + 360 end
	end
	return toNorm
end


return common