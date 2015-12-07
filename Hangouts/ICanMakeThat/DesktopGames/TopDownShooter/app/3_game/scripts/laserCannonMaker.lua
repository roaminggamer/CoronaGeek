local spriteMaker = require 'scripts.spriteMaker'

local laserCannon = {}

local info 	= require "images.reiners.lasercannon"
local sheet 	= info:getSheet()
local imageSheet 	=  graphics.newImageSheet("images/reiners/lasercannon.png", sheet )

local seqData = {}

local dirs = { "lasercannon", }

local anims = {}
anims["white"]		= { frames = 31,  time = 3100,  loops = 0 }

for i = 1, #dirs do
	for k, v in pairs( anims ) do
		spriteMaker.generateSequence( seqData, k, dirs[i], info, v )
	end
end

function laserCannon.create( group, x, y, scale )
	local tmp = display.newSprite( imageSheet, seqData )
	tmp.x = x
	tmp.y = y
	group:insert( tmp )
	tmp:play()
	tmp:scale(scale,scale)

	tmp:setSequence( "white" )
	tmp:pause()

	return tmp
end

return laserCannon