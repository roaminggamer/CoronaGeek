local spriteMaker = require 'scripts.spriteMaker'
local greenArcher = {}

local info 	= require "images.reiners.greenarcher"
local sheet 	= info:getSheet()
local imageSheet 	=  graphics.newImageSheet("images/reiners/greenarcher.png", sheet )

local seqData = {}

local dirs = { "n", "s", "e", "w", "ne", "se", "nw", "sw" }

local anims = {}
anims["walking"] 	= { frames = 8,  time = 800,  loops = 0 }
anims["shooting"] 	= { frames = 13, time = 250,  loops = 1 }
anims["paused"] 	= { frames = 9,  time = 1800, loops = 0 }
anims["been hit"] 	= { frames = 9,  time = 1000, loops = 1 }

for i = 1, #dirs do
	for k, v in pairs( anims ) do
		spriteMaker.generateSequence( seqData, k, dirs[i], info, v )
	end
end

function greenArcher.create( group, x, y, scale )
	local tmp = spriteMaker.create( group, x, y, scale, imageSheet, seqData )
	return tmp
end


return greenArcher