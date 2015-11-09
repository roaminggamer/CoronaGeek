-- =============================================================
-- Copyright Roaming Gamer, LLC. 2009-2015 
-- =============================================================
-- This content produced for Corona Geek Hangouts audience.
-- You may use any and all contents in this example to make a game or app.
-- =============================================================
local public = {}

-- Variables
local layers

-- Localizations
local mRand             = math.random
local getTimer          = system.getTimer
local pairs             = pairs

-- 
-- get() 
--
function public.get()
   return layers
end

-- 
-- destroy() 
--
function public.destroy( )	
	display.remove( layers )
	layers = nil
end


-- 
-- create() 
--
function public.create( group )	
	group = group or display.currentStage
	
	--
	-- Destroy old level if it exists
	--
	--public.destroy()

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
	layers 				   = display.newGroup()
	layers.background 	= display.newGroup()
	layers.world 		   = display.newGroup()
	layers.underlay 	   = display.newGroup()
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

   return layers
end

return public