local spriteMaker = require 'scripts.spriteMaker'

local chests = {}

local info 	= require "images.reiners.chests"
local sheet 	= info:getSheet()
local imageSheet 	=  graphics.newImageSheet("images/reiners/chests.png", sheet )

local seqData = {}

local dirs = { "front", "iso left", "iso right" }

local anims = {}
anims["blue chest"]		= { frames = 9,  time = 900,  loops = 1 }

for i = 1, #dirs do
	for k, v in pairs( anims ) do
		spriteMaker.generateSequence( seqData, k, dirs[i], info, v )
	end
end

function chests.create( group, x, y, scale )
	local tmp = display.newSprite( imageSheet, seqData )
	tmp.x = x
	tmp.y = y
	group:insert( tmp )
	tmp:play()
	tmp:scale(scale,scale)

	tmp:setSequence( "front" )
	tmp:pause()

	return tmp
end

return chests