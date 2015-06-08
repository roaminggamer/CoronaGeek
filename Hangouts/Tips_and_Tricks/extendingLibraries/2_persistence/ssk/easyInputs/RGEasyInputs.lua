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
local easyInputs = {}
_G.ssk.easyInputs = easyInputs
easyInputs.joystick 		= require("ssk.easyInputs.joystick")
easyInputs.cornerButtons 	= require("ssk.easyInputs.cornerButtons")
easyInputs.oneTouch 		= require("ssk.easyInputs.oneTouch")
easyInputs.twoTouch 		= require("ssk.easyInputs.twoTouch")
easyInputs.oneStick 		= require("ssk.easyInputs.oneStick")
easyInputs.twoStick 		= require("ssk.easyInputs.twoStick")
easyInputs.oneStickOneTouch = require("ssk.easyInputs.oneStickOneTouch")
--table.dump(easyInputs)
return easyInputs