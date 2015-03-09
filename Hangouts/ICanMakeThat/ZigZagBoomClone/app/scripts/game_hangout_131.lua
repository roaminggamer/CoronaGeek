-- =============================================================
-- Copyright Roaming Gamer, LLC. 2009-2014 
-- =============================================================
-- 
-- =============================================================
local public = {}

----------------------------------------------------------------------
--								REQUIRES							--
----------------------------------------------------------------------
local physics 	= require "physics"

local layersM 	= require "scripts.layers"
local oneTouchM 	= require "scripts.oneTouch"
local playerM 	= require "scripts.player"
local soundM 	= require "scripts.sound"
local wallM 	= require "scripts.wall"

----------------------------------------------------------------------
--								DECLARATIONS						--
----------------------------------------------------------------------
-- Variables
local layers

-- Forward Declarations
local drawFirstTrackSegment

-- Localizations
local mRand             = math.random
local getTimer          = system.getTimer
local pairs             = pairs

----------------------------------------------------------------------
--								DEFINITIONS							--
----------------------------------------------------------------------
-- Initialize Game
function public.init( parent, params )	
	parent = parent or display.currentStage
	params = params or {}
	print("Initializing game module.")

	-- Create rendering layers for our game
	layers = layersM.create( parent )

	-- Initialize the key game modules
	--oneTouchM.init( layers )
	--playerM.init( layers )	
	wallM.init( layers )	
	--soundM.init()

	-- (FOR DEBUG ONLY) Draw lines as reference for discussion
	--
	--local vLine = display.newLine( layers.content2, centerX, bottom, centerX, top )
	--local hLine = display.newLine( layers.content2, left, centerY, right, centerY )

	-- Draw first track segment
	--
	drawFirstTrackSegment( )

	-- Start Soundtrack
	--soundM.playSoundTrack( "sounds/music/UniqueTracks.com_Loop_10.mp3" )
end

-- Start Game
function public.start( params )	
	params = params or {}
	print("Starting game module.")

	-- Start Player Module
	playerM.start()
end

-- Stop Game
function public.stop( params )	
	params = params or {}
	print("Stopping game module.")

	-- Stop Player Module
	playerM.stop()

end

-- Clean up the game
function public.cleanup( path )	
	print("Cleaning up game module.")

	-- Cleanup the key game modules
	oneTouchM.cleanup( layers )
	playerM.cleanup( layers )	
	wallM.cleanup( layers )

	layersM.cleanup()

	layers = nil	
end


drawFirstTrackSegment = function()
	-- Draw blue background
	local back = display.newRect( layers.underlay, centerX, centerY, fullw, fullh )
	back:setFillColor( 0x01/255, 0x0f/255, 0x2a/255)

	-- Create first segment, centered on screen
	--
	local firstLength = 200 -- 1000
	local pathWidth = 150 --200
	local sqrt2 = math.sqrt(2)
	local x = centerX + (firstLength/2) / sqrt2
	local y = centerY + (firstLength/2) / sqrt2
	x, y = wallM.newSegment( x, y, -45, firstLength, pathWidth )

	-- Create more segments
	x, y = wallM.newSegment( x, y, 45, 120, pathWidth )
	x, y = wallM.newSegment( x, y, -45, 140, pathWidth )
	x, y = wallM.newSegment( x, y, -45, 120, pathWidth )
end

return public