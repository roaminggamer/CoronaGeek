local spriteMaker = require 'scripts.spriteMaker'

local bowSkel = {}

local info 	= require "images.reiners.bowskel"
local sheet 	= info:getSheet()
local imageSheet 	=  graphics.newImageSheet("images/reiners/bowskel.png", sheet )

local seqData = {}

local dirs = { "n", "s", "e", "w", "ne", "se", "nw", "sw" }

local anims = {}
anims["walking"] 		= { frames = 8,  time = 800,  loops = 0 }
anims["been hit"] 		= { frames = 7,  time = 700,  loops = 1 }
anims["disintegrate"] 	= { frames = 9,  time = 900,  loops = 1 }
anims["shooting"] 		= { frames = 13,  time = 250,  loops = 1 }

for i = 1, #dirs do
	for k, v in pairs( anims ) do
		spriteMaker.generateSequence( seqData, k, dirs[i], info, v )
	end
end

function bowSkel.create( group, x, y, scale )
	local tmp = spriteMaker.create( group, x, y, scale, imageSheet, seqData )
	return tmp
end

return bowSkel