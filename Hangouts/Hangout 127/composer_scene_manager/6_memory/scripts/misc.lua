-- =============================================================
-- Copyright Roaming Gamer, LLC. 2009-2014 
-- =============================================================
-- 
-- =============================================================
local getTimer = system.getTimer

local misc = {}

-- ==
--    round(val, n) - Rounds a number to the nearest decimal places. (http://lua-users.org/wiki/FormattingNumbers)
--    val - The value to round.
--    n - Number of decimal places to round to.
-- ==
function _G.round(val, n)
  if (n) then
    return math.floor( (val * 10^n) + 0.5) / (10^n)
  else
    return math.floor(val+0.5)
  end
end


-- Shorthand for Runtime:*() functions
--
local pairs = _G.pairs
_G.listen = function( name, listener ) Runtime:addEventListener( name, listener ) end
_G.ignore = function( name, listener ) Runtime:removeEventListener( name, listener ) end
_G.post = function( name, params, debuglvl )
   local params = params or {}
   local event = { name = name }
   for k,v in pairs( params ) do event[k] = v end
   if( not event.time ) then event.time = getTimer() end
   if( debuglvl and debuglvl >= 2 ) then table.dump(event) end
   Runtime:dispatchEvent( event )
   if( debuglvl and debuglvl >= 1 ) then print("post( '" .. name .. "' )" ) end   
end
-- Handy listener clearer
_G.removeListeners = function( obj )
  if(obj) then
    obj._functionListeners = nil --this will remove all functions listeners
    obj._tableListeners = nil --this will remove all table listeners
  else
    _G.Runtime._functionListeners = nil --this will remove all functions listeners
    _G.Runtime._tableListeners = nil --this will remove all table listeners
  end
end

-- Easy Mem Meter
--
misc.createEasyMeter = function( x , y, width, fontSize )
	x = x or centerX
	y = y or centerY
	width = width or 200
	fontSize = fontSize or 11
	local group = display.newGroup()	

	local hudFrame = display.newRect( group, x, y, width, 30)
	hudFrame:setFillColor(0.2,0.2,0.2)
	hudFrame:setStrokeColor(1,1,0)
	hudFrame.strokeWidth = 2

	local mMemLabel = display.newText( group, "", 40, hudFrame.y, native.systemFont, fontSize )
	mMemLabel:setFillColor(1,0.4,0)
	mMemLabel.anchorX = 1

	local tMemLabel = display.newText( group, "", 40, hudFrame.y, native.systemFont, fontSize )
	tMemLabel:setFillColor(0.2,1,0)
	tMemLabel.anchorX = 0

	hudFrame.touch = function( self, event )
		local target  = event.target
		local eventID = event.id

		if(event.phase == "began") then
			display.getCurrentStage():setFocus( target, eventID )
			target.isFocus = true
			target._x0 = target.x
			target._y0 = target.y

		elseif(target.isFocus) then
			local dx = event.x - event.xStart
			local dy = event.y - event.yStart
			target.x = target._x0 + dx
			target.y = target._y0 + dy

			if(event.phase == "ended" or event.phase == "cancelled") then
				display.getCurrentStage():setFocus( nil, eventID )
				target.isFocus = false
			end
		end
	end; hudFrame:addEventListener( "touch" )
	
	hudFrame.enterFrame = function( self )
		if( group.removeSelf == nil) then
			ignore( "enterFrame", hudFrame )
			return
		end
		-- Fill in current main memory usage
		collectgarbage("collect") -- Collect garbage every frame to get 'true' current memory usage
		local mmem = collectgarbage( "count" ) 
		mMemLabel.text = "M: " .. round(mmem/(1024),2) .. " MB"
		mMemLabel.x = hudFrame.x - 10
		mMemLabel.y = hudFrame.y

		-- Fill in current texture memory usage
		local tmem = system.getInfo( "textureMemoryUsed" )
		tMemLabel.text = "T: " .. round(tmem/(1024 * 1024),2) .. " MB"
		tMemLabel.x = hudFrame.x + 10
		tMemLabel.y = hudFrame.y
		group:toFront()
	end; listen( "enterFrame", hudFrame )
	return group
end



return misc