-- =============================================================
-- Copyright Roaming Gamer, LLC. 2009-2014 
-- =============================================================
-- 
-- =============================================================
local public = {}

----------------------------------------------------------------------
--								REQUIRES							--
----------------------------------------------------------------------
local physics 		= require "physics"

local layersM 		= require "scripts.layers"
local oneTouchM 	= require "scripts.oneTouch"
local playerM 		= require "scripts.player"
local soundM 		= require "scripts.sound"
local wallM 		= require "scripts.wall"

----------------------------------------------------------------------
--								DECLARATIONS						--
----------------------------------------------------------------------
-- Variables
local layers

-- Forward Declarations
local enterFrame

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
	oneTouchM.init( layers )
	playerM.init( layers )	
	wallM.init( layers )	
	--soundM.init()

	-- (FOR DEBUG ONLY) Draw lines as reference for discussion
	--
	--local vLine = display.newLine( layers.content2, centerX, bottom, centerX, top )
	--local hLine = display.newLine( layers.content2, left, centerY, right, centerY )

	-- Draw blue background
	--
	local back = display.newRect( layers.underlay, centerX, centerY, fullw, fullh )
	back:setFillColor( 0x01/255, 0x0f/255, 0x2a/255)

	-- Draw first track segments
	--
	wallM.newSegment( 100 ) -- Passing length tells module this is first segment 
	wallM.newSegment() 
	wallM.newSegment() 
	wallM.newSegment() 
	wallM.newSegment() 

	-- Start listening for 'enterFrame'
	--
	--listen( "enterFrame", enterFrame )

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

	-- Stop listening for 'enterFrame'
	--
	--ignore( "enterFrame", enterFrame )

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

-- 'enterFrame' listener
--
enterFrame = function()
	wallM.removeSegmentsIfNeeded()
	wallM.drawSegmentIfNeeded()
end


return public