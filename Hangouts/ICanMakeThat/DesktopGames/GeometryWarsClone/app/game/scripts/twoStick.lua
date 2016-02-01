-- =============================================================
-- Copyright Roaming Gamer, LLC. 2009-2015
-- =============================================================
-- Two Stick - Split-Screen Virtual Joystick Builder (extracted for SSK)
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
local joystick 	= require "scripts.joystick"
local inputs

local function create( group, params )
	group 	= group or display.currentStage
	params 	= params or {}

	system.activate("multitouch")

	local debugEn 			= params.debugEn or false
	local leftFill			= params.leftFill or {0,0,1}
	local rightFill			= params.rightFill or {1,0,0}
	local alpha 			= params.alpha or debugEn and 0.25 or 0
	local leftEventName 	= params.leftEventName or "onLeftJoystick"
	local rightEventName 	= params.rightEventName or "onRightJoystick"
	local leftJoyParams 	= params.leftJoyParams or params.joyParams or {}
	local rightJoyParams 	= params.rightJoyParams or params.joyParams or {}

	leftJoyParams = table.shallowCopy( leftJoyParams )
	rightJoyParams = table.shallowCopy( rightJoyParams )

	inputs = display.newGroup()
	group:insert(inputs)
   
   local leftInputObj = display.newRect( inputs, centerX - fullw/4, centerY, fullw/2, fullh )
   leftInputObj.alpha = alpha
   leftInputObj:setFillColor( unpack( leftFill ) )
   leftInputObj.myEventName = leftEventName
   leftInputObj.isHitTestable = true
   
   local rightInputObj = display.newRect( inputs,  centerX + fullw/4, centerY, fullw/2, fullh )
   rightInputObj.alpha = alpha
   rightInputObj:setFillColor( unpack( rightFill ) )
   rightInputObj.myEventName = leftEventName
   rightInputObj.isHitTestable = true   

	leftJoyParams.inputObj = leftInputObj
	leftJoyParams.eventName = leftEventName
	leftJoyParams.inUseAlpha = fnn( leftJoyParams.inUseAlpha, 1 )
	leftJoyParams.notInUseAlpha = fnn( leftJoyParams.notInUseAlpha, 0.25 )

	rightJoyParams.inputObj = rightInputObj
	rightJoyParams.eventName = rightEventName
	rightJoyParams.inUseAlpha = fnn( rightJoyParams.inUseAlpha, 1 )
	rightJoyParams.notInUseAlpha = fnn( rightJoyParams.notInUseAlpha, 0.25 )

	local sx = centerX - fullw/2 + 60
	local sy = centerY + fullh/2 - 60
	joystick.create( inputs, sx, sy, leftJoyParams )

	sx = centerX + fullw/2 - 60
	joystick.create( inputs, sx, sy, rightJoyParams )	
end
local function destroy()
	display.remove(inputs)
	inputs = nil
end

local public = {}
public.create 	= create
public.destroy 	= destroy
return public