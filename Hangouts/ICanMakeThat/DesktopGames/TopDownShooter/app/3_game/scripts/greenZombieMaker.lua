-- =============================================================
-- Copyright Roaming Gamer, LLC. 2009-2015 
-- =============================================================
-- This content produced for Corona Geek Hangouts audience.
-- You may use any and all contents in this example to make a game or app.
-- =============================================================
local spriteMaker = require 'scripts.spriteMaker'

local public = {}

local info 	= require "images.reiners.greenzombie"
local sheet 	= info:getSheet()
local imageSheet 	=  graphics.newImageSheet("images/reiners/greenzombie.png", sheet )

local seqData = {}

local dirs = { "n", "s", "e", "w", "ne", "se", "nw", "sw" }

local anims = {}
anims["walking"] 		= { frames = 8,  time = 800,  loops = 0 }
anims["disintegrate"] 	= { frames = 9,  time = 900,  loops = 1 }
anims["attack"] 		= { frames = 11, time = 1100, loops = 0 }
anims["been hit"] 		= { frames = 9,  time = 900,  loops = 1 }

for i = 1, #dirs do
	for k, v in pairs( anims ) do
		spriteMaker.generateSequence( seqData, k, dirs[i], info, v )
	end
end

function public.create( group, x, y, scale )
	local tmp = spriteMaker.create( group, x, y, scale, imageSheet, seqData )
	return tmp
end

return public