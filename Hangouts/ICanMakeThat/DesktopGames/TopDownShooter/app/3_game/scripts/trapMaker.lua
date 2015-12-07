local spriteMaker = require 'scripts.spriteMaker'

local trapMaker = {}

local info 	= require "images.reiners.trap"
local sheet 	= info:getSheet()
local imageSheet 	=  graphics.newImageSheet("images/reiners/trap.png", sheet )

local seqData = {}

local anims = {}
anims["stachelkopf"]		= { frames = 16,  time = 1600,  loops = 0 }


for k, v in pairs( anims ) do
	spriteMaker.generateSequence2( seqData, k, info, v )
end

function trapMaker.create( group, x, y, scale )
	local tmp = display.newImageRect( group, imageSheet, 
		                              1, 
		                              128, 128 )
	tmp.x = x
	tmp.y = y
	tmp:scale( scale, scale )


	local tmp2 = display.newSprite( imageSheet, seqData )
	tmp2.x = x
	tmp2.y = y
	group:insert( tmp2 )
	tmp2:setSequence( "stachelkopf" )
	tmp2:play()
	tmp2:scale(scale,scale)

	tmp.arm = tmp2

	return tmp
	--]]
end

return trapMaker