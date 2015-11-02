local spriteMaker = {}

local normRot		= ssk.misc.normRot

local info 			= require "images.reiners.arrows"
local sheet 		= info:getSheet()
local imageSheet 	=  graphics.newImageSheet("images/reiners/arrows.png", sheet )

function spriteMaker.angleToDir( angle )	
	local subAngle = 360/32
	--if( angle < subAngle ) then return 1 end
	for i = 1, 32 do
		--print( i * subAngle, angle )
		if( i * subAngle > angle ) then
			return i
		end
	end
	return 1
end

function spriteMaker.create( group, x, y, angle, scale )

	local arrowIndex = spriteMaker.angleToDir( normRot( angle ) )
	print('arrowIndex ', arrowIndex)
	local tmp = display.newImageRect( group, imageSheet, 
		                              arrowIndex, 
		                              32, 64 )
	tmp.x = x
	tmp.y = y
	tmp:scale(scale,scale)
	return tmp
end

return spriteMaker