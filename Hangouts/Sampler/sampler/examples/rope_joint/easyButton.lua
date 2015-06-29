-- =============================================================
-- Copyright Roaming Gamer, LLC. 2009-2015
-- =============================================================
-- 
-- =============================================================
-- 
-- =============================================================
local builder = {}

function builder.addTouch( object, callback )	
	object.touch = function( self, event )
		if( event.phase == "began" ) then
			object:setFillColor(0,1,0)
			callback( event )
		
		elseif( event.phase == "ended" ) then
			object:setFillColor(1,1,1)
			callback( event )
		end
		return true
	end
	object:addEventListener( "touch" )
end

function builder.easyPush( object, callback )	
	object.touch = function( self, event )
		if( event.phase == "began" ) then
			object:setFillColor(0,1,0)
		elseif( event.phase == "ended" ) then
			object:setFillColor(1,1,1)
			callback( event )
		end
		return true
	end
	object:addEventListener( "touch" )
end

function builder.easyToggle( object, callback )	
	object.touch = function( self, event )
		if( event.phase == "began" ) then
			if(not object.__isToggled) then
				object.__isToggled = true
				object:setFillColor(0,1,0)
				callback( event )
			else
				object.__isToggled = false
				object:setFillColor(1,1,1)
				callback( event )
			end
		end
		return true
	end
	object:addEventListener( "touch" )
end


return builder