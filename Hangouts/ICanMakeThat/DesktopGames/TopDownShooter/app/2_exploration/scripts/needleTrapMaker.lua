local spriteMaker = require 'scripts.spriteMaker'

local needleTrapMaker = {}

local info 	= require "images.reiners.trap2"
local sheet 	= info:getSheet()
local imageSheet 	=  graphics.newImageSheet("images/reiners/trap2.png", sheet )

local seqData = {}

local dirs = { "front close", "front open", "iso close", "iso open " }

local anims = {}
anims["single steelneedle"]	= { frames = 9,  time = 900,  loops = 0 }

for i = 1, #dirs do
	for k, v in pairs( anims ) do
		spriteMaker.generateSequence( seqData, k, dirs[i], info, v )
	end
end

local dirs = { "front close", "front open", "iso left close", "iso left open", "iso right close", "iso right open" }

local anims = {}
anims["steel needles"]		= { frames = 9,  time = 900,  loops = 0 }

for i = 1, #dirs do
	for k, v in pairs( anims ) do
		spriteMaker.generateSequence( seqData, k, dirs[i], info, v )
	end
end


function needleTrapMaker.create( group, x, y, scale )
	local tmp = display.newSprite( imageSheet, seqData )
	tmp.x = x
	tmp.y = y
	group:insert( tmp )
	tmp:setSequence( "single steelneedle" )
	tmp:play()
	tmp:scale(scale,scale)

	
	--tmp:pause()

	return tmp
end

return needleTrapMaker