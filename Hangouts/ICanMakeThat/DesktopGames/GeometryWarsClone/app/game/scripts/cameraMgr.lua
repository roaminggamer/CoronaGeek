-- =============================================================
-- Copyright Roaming Gamer, LLC. 2009-2015 
-- =============================================================
-- This content produced for Corona Geek Hangouts audience.
-- You may use any and all contents in this example to make a game or app.
-- =============================================================
local public = {}

local common 			   = require "scripts.common"
local layersMaker		   = require "scripts.layersMaker"

local isValid           = display.isValid

-- 
--	 detach()
-- 
function public.detach()
   local layers = layersMaker.get()
   if( not isValid(layers) ) then return end
   local world = layers.world
   Runtime:removeEventListener( "enterFrame", world )
end

-- 
--	 attach()
-- 
function public.attach( trackObj )	
   local layers = layersMaker.get()
   local world = layers.world
   
   local lx = trackObj.x
	local ly = trackObj.y

	world.enterFrame = function( event )
		local dx = 0
		local dy = 0
		dx = trackObj.x - lx
		dy = trackObj.y - ly
    
      
		if( dx ~= 0 or dy ~= 0 ) then	
			world:translate(-dx,-dy)
			lx = trackObj.x
			ly = trackObj.y
		end
		return false
	end
	Runtime:addEventListener( "enterFrame", world )
end


return public