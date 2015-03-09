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
local oneTouch 	= require "scripts.oneTouch"
local playerM 	= require "scripts.player"
local soundM 	= require "scripts.sound"
local wallM 	= require "scripts.wall"

----------------------------------------------------------------------
--								DECLARATIONS						--
----------------------------------------------------------------------
-- Variables
local layers

-- Forward Declarations

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

	physics.start()
	physics.setGravity( 0, 10 )
	physics.setDrawMode( "hybrid" )

	-- Create rendering layers for our game
	layers = layersM.create( parent )

	-- Initialize the key game modules
	oneTouch.init( layers )
	playerM.init( layers )	
	wallM.init( layers )
	
	soundM.init()

end

-- Start Game
function public.start( params )	
	params = params or {}
	print("Starting game module.")

	-- Start Soundtrack
	--soundM.playSoundTrack( "sounds/music/UniqueTracks.com_Loop_10.mp3" )

	----[[
	-- Test sound effects
	for i = 1, 5 do
		timer.performWithDelay( 1000 + i * 100,
			function() 
				post( "onSFX", { sfx = "click" } )
			end )
	end
	timer.performWithDelay( 2000,
		function() 
			post( "onSFX", { sfx = "explosion" } )
		end )
	--]]

end

-- Stop Game
function public.stop( params )	
	params = params or {}
	print("Stopping game module.")
end

-- Clean up the game
function public.cleanup( path )	
	print("Cleaning up game module.")

	-- Initialize the key game modules
	oneTouch.cleanup( layers )
	playerM.cleanup( layers )	
	wallM.cleanup( layers )

	layers = nil	
end

return public