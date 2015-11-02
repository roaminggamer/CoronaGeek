-- =============================================================
-- Copyright Roaming Gamer, LLC. 2009-2015 
-- =============================================================
-- 
-- =============================================================
local public = {}

--
-- The Key Listener - https://docs.coronalabs.com/daily/api/event/key/index.html
--
local function onKey( event ) 

	local key 			= event.keyName
	local device 		= event.device
	local keyCode 		= event.nativeKeyCode
	local isCtrlDown 	= event.isCtrlDown
	local isCommandDown	= event.isCommandDown
	local isAltDown 	= event.isAltDown
	local isShiftDown 	= event.isShiftDown
	local phase 		= event.phase
	--print("\n ---------------------------- onKey() @ ", getTimer() )
	--table.dump(event)

	if( phase == "down" and key == "enter" and isCtrlDown  ) then -- and isAltDown ) then
		print("Toggle screen mode")
		public.toggleFullScreen()
	end

	if( phase == "up" and key == "escape" ) then -- and isAltDown ) then
		print("Escape")
		post("onEscape")		
	end


	if( phase == "down" and key == "f" and isCtrlDown ) then -- and isAltDown ) then
		print("Toggle screen mode")
		native.setProperty( "windowMode", "fullscreen" )  -- fullscreen, maximized, normal
	end

	if( phase == "down" and key == "n" and isCtrlDown  ) then -- and isAltDown ) then
		print("Toggle screen mode")
		native.setProperty( "windowMode", "normal" )  -- fullscreen, maximized, normal
	end

	if( phase == "down" and key == "m" and isCtrlDown  ) then -- and isAltDown ) then
		print("Toggle screen mode")
		native.setProperty( "windowMode", "maximized" )  -- fullscreen, maximized, normal
	end

	if( phase == "down" and key == "l" and isCtrlDown and isShiftDown  ) then 
		local logger 	= require "scripts.logger" -- Requires SSK
		logger.purge()
		print("Cleared Logger ..")
	
	elseif( phase == "down" and key == "l" and isCtrlDown  ) then 
		--print("Showing Logger ..")
		local logger 	= require "scripts.logger" -- Requires SSK
		logger.show()
	end

end
timer.performWithDelay( 100, function()  Runtime:addEventListener( "key", onKey ) end )

local lastMode = "normal"
function public.toggleFullScreen()	
	if( lastMode == "fullscreen" ) then
		print("Toggling from 'fullscreen' mode to '" .. lastMode .. "' mode.")
		native.setProperty( "windowMode", "normal" )  -- fullscreen, maximized, normal	
		lastMode = "normal"	
	else
		print("Toggling from '" .. lastMode .. "' mode to 'fullscreen' mode.")		
		native.setProperty( "windowMode", "fullscreen" )  -- fullscreen, maximized, normal
		lastMode = "fullscreen"
	end
end

return public