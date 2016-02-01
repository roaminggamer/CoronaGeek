-- =============================================================
-- Copyright Roaming Gamer, LLC. 2009-2015 
-- =============================================================
-- This content produced for Corona Geek Hangouts audience.
-- You may use any and all contents in this example to make a game or app.
-- =============================================================
local public = {}

local common 			   = require "scripts.common"

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
							|		|---\spawnGrid
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
   layers.spawnGrid 	   = display.newGroup()
	layers.content 		= display.newGroup()
	layers.overlay 		= display.newGroup()
	layers.interfaces 	= display.newGroup()

	layers:insert( layers.background )
	layers:insert( layers.world )
	layers:insert( layers.interfaces )

	layers.world:insert( layers.underlay )
   layers.world:insert( layers.spawnGrid )
	layers.world:insert( layers.content )
	layers.world:insert( layers.overlay )

	group:insert( layers )
   
   -- For demonstrating extra terrain fill
   --transition.to( layers, { xScale = 0.5, yScale = 0.5, x = common.w/4, y = common.h/4, time = 2000, delay = 1000 } )

   return layers
end

return public