-- =============================================================
-- Copyright Roaming Gamer, LLC. 2009-2015
-- =============================================================
--  ** RGCamera
-- =============================================================
-- 								License
-- =============================================================
--[[
	> SSK is free to use.
	> SSK is free to edit.
	> SSK is free to use in a free or commercial game.
	> SSK is free to use in a free or commercial non-game app.
	> SSK is free to use without crediting the author (credits are still appreciated).
	> SSK is free to use without crediting the project (credits are still appreciated).
	> SSK is NOT free to sell for anything.
	> SSK is NOT free to credit yourself with.
]]
-- =============================================================
local camera = {}

local centerX 	= display.contentCenterX
local centerY 	= display.contentCenterY

local isValid = isValid or function( obj ) 
	return obj.removeSelf ~= nil 
end

local fnn = fnn or function( ... ) 
	for i = 1, #arg do
		local theArg = arg[i]
		if(theArg ~= nil) then return theArg end
	end
	return nil
end


-- ==
--		tracking() - Follows target exactly.
-- ==
function camera.tracking( trackObj, world, params )	

	if( not isValid( world ) ) then return end
	
	params = params or {}	
	local lockX = params.lockX 
	local lockY = params.lockY
	local centered = fnn( params.centered, false)

	local lx = 0
	local ly = 0

	if( centered ) then
		if( lockX ) then
			lx = trackObj.x
		else
			lx = centerX
		end

		if( lockY ) then
			ly = trackObj.y
		else
			ly = centerY
		end
	else
		lx = trackObj.x
		ly = trackObj.y
	end

	world.enterFrame = function( event )
		if( not isValid( world ) ) then 
			ignore( "enterFrame", world )
			return 
		end
		if( not isValid( trackObj ) ) then 
			return 
		end
		local dx = 0
		local dy = 0
		if(not lockX) then dx = trackObj.x - lx end		
		if(not lockY) then dy = trackObj.y - ly end
		if(dx or dy) then	
			world:translate(-dx,-dy)
			lx = trackObj.x
			ly = trackObj.y
		end
		return false
	end
	Runtime:addEventListener( "enterFrame", world )
end


return camera