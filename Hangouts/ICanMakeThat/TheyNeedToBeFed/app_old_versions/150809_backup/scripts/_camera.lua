-- =============================================================
-- Copyright Roaming Gamer, LLC. 2009-2014 
-- =============================================================
-- 
-- =============================================================
local public = {}

-- Initialize trackObj starting position
function public.init( trackObj )	
	-- Start tracking the players last X and Y positions.
	--
	trackObj.lx = trackObj.x 	-- 'Last' x-position.  
	trackObj.ly = trackObj.y 	-- 'Last' y-position.  
end

-- The simplest of 'cameras', this code merely moves the world the exact opposite distance
-- the trackObj did, every frame.  This keeps the trackObj in its initial position and makes it
-- look like the world is moving around the trackObj.
--
function public.update( trackObj, world )	
	-- Calculate how far we moved last frame
	local dx = trackObj.x - trackObj.lx
	local dy = trackObj.y - trackObj.ly

	-- Save our new 'last' position
	--
	trackObj.lx = trackObj.x
	trackObj.ly = trackObj.y

	-- Move the world to keep the trackObj in it's initial (visual) position relative
	--
	world.x = world.x - dx
	world.y = world.y - dy
end

return public