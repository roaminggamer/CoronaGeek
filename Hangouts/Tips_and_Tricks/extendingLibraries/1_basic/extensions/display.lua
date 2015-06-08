-- =============================================================
-- Copyright Roaming Gamer, LLC. 2009-2015
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

-- display.remove( func ) - Replacement that works in tandem with 'isValid'
--
display._remove = display.remove

display.remove = function ( obj )
	if( not obj or  obj.__destroyed ) then return end
	if(obj.__autoClean) then
		obj:__autoClean()
		obj__autoClean = nil
	end
	display._remove( obj )
	obj.__destroyed = true
end

-- display.remove( func ) - Replacement that works in tandem with 'isValid'
--
display.isValid = function ( obj )
	return( obj and 
		    not obj.__destroyed and 
		    obj.removeSelf ~= nil )
end
