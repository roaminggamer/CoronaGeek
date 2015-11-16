-- =============================================================
-- Copyright Roaming Gamer, LLC. 2009-2015 
-- =============================================================
-- This content produced for Corona Geek Hangouts audience.
-- You may use any and all contents in this example to make a game or app.
-- =============================================================
local public = {}

local physics 			   = require "physics"
local common 			   = require "scripts.common"

local info 			= require "images.reiners.arrows"
local sheet 		= info:getSheet()
local imageSheet 	= graphics.newImageSheet("images/reiners/arrows.png", sheet )

local normRot     = common.normRot


function public.angleToDir( angle )	
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

function public.create( group, x, y, angle, scale )

	local arrowIndex = public.angleToDir( normRot( angle ) )
	print('arrowIndex ', arrowIndex)
	local tmp = display.newImageRect( group, imageSheet, 
		                              arrowIndex, 
		                              32, 64 )
	tmp.x = x
	tmp.y = y
	tmp:scale(scale,scale)
	return tmp
end

return public