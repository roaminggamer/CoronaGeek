require("mobdebug").start()
display.setStatusBar(display.HiddenStatusBar)  
system.activate("multitouch")
io.output():setvbuf("no") 
math.randomseed(os.time());
local ssk 		= require "ssk.loadSSK"


local common 	= require "scripts.common"

local world   = display.newGroup()
local content = display.newGroup()
world:insert( content )

-- ground
for i = 1, 200 do
   local x = common.centerX + math.random( -200, 200 )
   local y = common.centerY + math.random( -200, 200 )
   local tmp = display.newCircle( content, x, y, math.random( 20, 40 ) )
   tmp:setFillColor( math.random(), math.random(), math.random(), 0.2 )
end


local player = display.newImageRect( content, "images/smiley.png", 40, 40 )
player.x = common.centerX
player.y = common.centerY

-- Initialization
world.lx = player.x
world.ly = player.y


local function onKey( event ) 
	local key 			= event.keyName
	local phase 		= event.phase
   
   if( phase == "up" ) then
      
      -- Move Player
      if( key == "left" ) then
         player.x = player.x - 50
      elseif( key == "right" ) then
         player.x = player.x + 50
      elseif( key == "up" ) then
         player.y = player.y - 50
      elseif( key == "down" ) then
         player.y = player.y + 50
      end
         
      
      
      -- Move World (Camera)
      if( key == "c" ) then
         local dx = world.lx - player.x
         local dy = world.ly - player.y
         
         world.lx = player.x
         world.ly = player.y
         
         world.x = world.x + dx
         world.y = world.y + dy
      end
      
   end 
   return false   
end

Runtime:addEventListener( "key", onKey )
   
   

