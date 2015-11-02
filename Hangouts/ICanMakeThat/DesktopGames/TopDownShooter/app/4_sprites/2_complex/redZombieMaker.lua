local spriteMaker = require 'spriteMaker'

local redZombie = {}

local info 	= require "redzombie"
local sheet 	= info:getSheet()
local imageSheet 	=  graphics.newImageSheet("redzombie.png", sheet )

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

function redZombie.create( group, x, y, scale )
	local tmp = spriteMaker.create( group, x, y, scale, imageSheet, seqData )
	return tmp
end

return redZombie