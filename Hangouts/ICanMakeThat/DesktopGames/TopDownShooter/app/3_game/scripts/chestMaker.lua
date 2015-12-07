local spriteMaker = require 'scripts.spriteMaker'

local chests = {}

local info 	= require "images.reiners.chests"
local sheet 	= info:getSheet()
local imageSheet 	=  graphics.newImageSheet("images/reiners/chests.png", sheet )

local seqData = {}

local dirs = { "front" }

local anims = {}
anims["blue chest"]		= { frames = 9,  time = 900,  loops = 1 }
anims["chest white"]		= { frames = 9,  time = 900,  loops = 1 }
anims["chest red"]		= { frames = 9,  time = 900,  loops = 1 }

for i = 1, #dirs do
	for k, v in pairs( anims ) do
		spriteMaker.generateSequence( seqData, k, dirs[i], info, v )
	end
end



function chests.create( group, x, y, color, scale )
   color = color or "blue"
   scale = scale or 1
	local tmp = display.newSprite( imageSheet, seqData )
	tmp.x = x
	tmp.y = y
	group:insert( tmp )
	tmp:play()
	tmp:scale(scale,scale)
   
   --table.print_r( seqData )

   if( color == "blue" ) then
      tmp:setSequence( "blue chest_front" )
   else
      local chestSeq = "chest " .. color .. "_front"
      tmp:setSequence( chestSeq )
   end
	
	tmp:pause()
	return tmp
end

return chests