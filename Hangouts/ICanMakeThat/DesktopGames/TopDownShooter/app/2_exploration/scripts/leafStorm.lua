local spriteMaker = require 'scripts.spriteMaker'

local leafStorm = {}

local info 	= require "images.reiners.leafstorm"
local sheet 	= info:getSheet()
local imageSheet 	=  graphics.newImageSheet("images/reiners/leafstorm.png", sheet )

local seqData = {}

local anims = {}
anims["appearing"]		= { frames = 24,  time = 1200,  loops = 0 }
anims["disappearing"]	= { frames = 24,  time = 1200,  loops = 0 }
anims["rotating"]		= { frames = 24,  time = 1200,  loops = 0 }


for k, v in pairs( anims ) do
	spriteMaker.generateSequence2( seqData, k, info, v )
end

function leafStorm.create( group, x, y, scale )
	local tmp = display.newSprite( imageSheet, seqData )
	tmp.x = x
	tmp.y = y
	group:insert( tmp )
	tmp:play()
	tmp:scale(scale,scale)

	tmp:setSequence( "appearing" )
	tmp:pause()

	return tmp
end

return leafStorm