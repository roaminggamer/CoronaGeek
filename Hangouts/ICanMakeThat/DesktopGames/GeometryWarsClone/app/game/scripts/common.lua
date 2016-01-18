-- =============================================================
-- Copyright Roaming Gamer, LLC. 2009-2015 
-- =============================================================
-- This content produced for Corona Geek Hangouts audience.
-- You may use any and all contents in this example to make a game or app.
-- =============================================================

local common = {}

common.meterEn = true

common.enemies = {}

--common.enemyDebugSpeed = 1

common.nextLife      = 10000
common.nextMine      = 15000

common.showSpawnGrid = true

common.particleStyle = 1

common.msPerLevel       = 1000
common.difficultyStart  = 0
common.maxEnemies       = 1
common.maxEnemiesCap    = 100

common.startLives    = 3
common.startMines    = 3
common.curLives      = common.startLives
common.curMines      = common.startMines

--
-- Input Control
--
common.forceMode     = "auto"
--common.forceMode     = "mobile"
if( onMobile or common.forceMode == "mobile" ) then
   print("MOBILE MODE")
   common.inputStyle    = "mobile"
else
   print("DESKTOP MODE")
   common.inputStyle    = "desktop"
end

--
-- Game Variables
--
common.debugEn		= false

common.startLevel    = 1
common.currentLevel  = common.startLevel 


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

--
-- Player Settings
--
common.playerSize = 50

--
-- Enemy Settings
--
common.enemySize        = 40
common.enemyTweenTime   = 500
common.enemySpawnOffset = 150

--
-- Current Frame Tracker
--
common.curFrame = 0
listen( "enterFrame", function() common.curFrame = common.curFrame + 1 end )


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