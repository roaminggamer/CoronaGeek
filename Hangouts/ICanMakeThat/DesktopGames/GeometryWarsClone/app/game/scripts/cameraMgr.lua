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
--	 detach() -- Stop the enterFrame listener 
-- 
function public.detach()
   local layers = layersMaker.get()
   if( not isValid(layers) ) then return end
   Runtime:removeEventListener( "enterFrame", layers.world )
end

-- 
--	 attach()
-- 
function public.attach( trackObj )	
   local layers = layersMaker.get()
   local world = layers.world
   
   -- Store 'initial' position of track object
   local lx = trackObj.x
	local ly = trackObj.y

   -- Every frame, calculated delta x/y of track objects and apply inverse to world group to 
   -- keep player locked to original screen position.
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