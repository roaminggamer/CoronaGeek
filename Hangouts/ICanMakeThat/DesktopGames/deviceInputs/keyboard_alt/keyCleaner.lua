-- =============================================================
-- Copyright Roaming Gamer, LLC. 2009-2014 
-- =============================================================
-- 
-- =============================================================
-- Note: Modify code below if you put libraries in alternate folder.
-- =============================================================
local getTimer  = system.getTimer

local debugLevel = 0
local onOSX = system.getInfo("platformName") == "Mac OS X"
local onWin = system.getInfo("platformName") == "Win"

local function keyCleaner( event )

	--event = table.shallowCopy( event )
	if( event.phase == "down" ) then event.phase = "began" end
	if( event.phase == "up" ) then event.phase = "ended" end

	if( onWin ) then 
		return event 
 	end

 	local code = event.nativeKeyCode

 	local codes = {}
 	codes[122] = 'f1'
 	codes[120] = 'f2'
 	codes[99] = 'f3'
 	codes[118] = 'f4'
 	codes[96] = 'f5'
 	codes[97] = 'f6'
 	codes[98] = 'f7'
 	codes[100] = 'f8'
 	codes[101] = 'f9'   -- NOT SURE; OFF LIMITS (SPECIAL USE ON OSX)
 	codes[102] = 'f10'  -- NOT SURE; OFF LIMITS (SPECIAL USE ON OSX)
 	codes[103] = 'f11'  -- NOT SURE; OFF LIMITS (SPECIAL USE ON OSX)
 	codes[104] = 'f12'  -- NOT SURE; OFF LIMITS (SPECIAL USE ON OSX)
 	codes[124] = 'right'
 	codes[123] = 'left'
 	codes[126] = 'up'
 	codes[125] = 'down'
 	codes[115] = 'home'
 	codes[116] = 'pageUp'
 	codes[121] = 'pageDown'
 	codes[119] = 'end'
 	codes[114] = 'insert'
 	codes[117] = 'deleteForward'
 	codes[51] = 'deleteBack'
 	codes[48] = 'tab'
 	codes[53] = 'escape'
 	codes[36] = 'enter'
 	codes[76] = 'enter' -- DUPLICATED
 	codes[49] = 'space' 
 	
 	if( codes[code] ) then
 		event.keyName = codes[code]
 	end

	return event 
end

return keyCleaner