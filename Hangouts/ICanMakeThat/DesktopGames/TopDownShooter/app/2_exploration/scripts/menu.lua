-- =============================================================
-- Copyright Roaming Gamer, LLC. 2009-2015 
-- =============================================================
-- 
-- =============================================================
local public = {}
local private = {}

----------------------------------------------------------------------
--								REQUIRES							--
----------------------------------------------------------------------
local physics 		= require "physics"
local common 		= require "scripts.common"

----------------------------------------------------------------------
--								DECLARATIONS						--
----------------------------------------------------------------------
-- Variables
local layers

local currentIdea

-- Forward Declarations


-- Useful Localizations
-- SSK
--
local newCircle 		= ssk.display.newCircle
local newRect 			= ssk.display.newRect
local newImageRect 		= ssk.display.newImageRect
local newAngleLine 		= ssk.display.newAngleLine
local easyIFC   		= ssk.easyIFC
local oleft 			= ssk.misc.oleft
local oright 			= ssk.misc.oright
local otop 				= ssk.misc.otop
local obottom			= ssk.misc.obottom
local isInBounds    	= ssk.easyIFC.isInBounds
local secondsToTimer	= ssk.misc.secondsToTimer
local isValid 			= display.isValid

-- Corona & Lua
--
local mAbs              = math.abs
local mRand             = math.random
local mDeg              = math.deg
local mRad              = math.rad
local mCos              = math.cos
local mSin              = math.sin
local mAcos             = math.acos
local mAsin             = math.asin
local mSqrt             = math.sqrt
local mCeil             = math.ceil
local mFloor            = math.floor
local mAtan2            = math.atan2
local mPi               = math.pi

local getInfo           = system.getInfo
local getTimer          = system.getTimer
local strMatch          = string.match
local strFormat         = string.format
local pairs             = pairs

----------------------------------------------------------------------
--								DEFINITIONS							--
----------------------------------------------------------------------

-- 
-- destroy() - Creates a new level.
--
function public.destroy()	
	display.remove(layers)
	layers = nil
end

-- 
-- create() - Creates a new level.
--
local lastGroup
function public.create( group )	
	group = group or lastGroup or display.currentStage
	lastGroup = group

	--
	-- Destroy old level if it exists
	--
	public.destroy()

	--
	-- Create rendering layers for our game with this
	-- final Layer Order (bottom-to-top)
	--
	layers = ssk.display.quickLayers( group, 
		"background",
		"content",
		"interfaces" )

	easyIFC:quickLabel( layers.interfaces, "Corona Geek - Desktop Games Exploration", centerX - 100, top + 60, gameFont, 36, _W_ )

	local function onTouch( event )
		currentIdea = require( "ideas." .. event.target.idea )
		currentIdea.create()
		private.hide()
	end

	local oy = 60
	easyIFC:presetPush( layers.interfaces, "default", left + 225, top + 200 + 0 * oy , 350, 50, "1 - Initial Test + Cameras", onTouch, { idea = "start" } )
	local tmp = easyIFC:presetPush( layers.interfaces, "default", left + 225, top + 200 + 1 * oy , 350, 50, "2 - Basics no Reticle", onTouch, { idea = "basic_noreticle" } )	
	local tmp = easyIFC:presetPush( layers.interfaces, "default", left + 225, top + 200 + 2 * oy , 350, 50, "3 - Basics alt no Reticle", onTouch, { idea = "basic_altnoreticle" } )	
	local tmp = easyIFC:presetPush( layers.interfaces, "default", left + 225, top + 200 + 3 * oy , 350, 50, "4 - Basics w/ Reticle", onTouch, { idea = "basic_reticle" } )	
	local tmp = easyIFC:presetPush( layers.interfaces, "default", left + 225, top + 200 + 4 * oy , 350, 50, "5 - Zombies + Mistake", onTouch, { idea = "zombies" } )	
	local tmp = easyIFC:presetPush( layers.interfaces, "default", left + 225, top + 200 + 5 * oy , 350, 50, "6 - Zombies + Partial Fix", onTouch, { idea = "zombies2" } )	
	local tmp = easyIFC:presetPush( layers.interfaces, "default", left + 225, top + 200 + 5 * oy , 350, 50, "6 - First Game - Another Zombie Shooter (AZS)", onTouch, { idea = "theFirstGame", labelColor = _G_})	
	tmp:toggle()

end

function private.hide()
	if( private.isHidden  ) then return end
	private.isHidden = true
	layers.interfaces.isVisible = false
end

function private.show()
	if( not private.isHidden  ) then return end
	private.isHidden = false
	layers.interfaces.isVisible = true
	if( currentIdea ) then
		currentIdea.destroy()
		currentIdea = nil
	end
	layers:purge( "content" )
end


Runtime:addEventListener( "resize", 
	function( event ) 
		print("Menu - resize Event Listener")
		table.dump(event)
		public.create() -- Redraw menu
		if( private.isHidden ) then 
			layers.interfaces.isVisible = false
		end
	end  )
Runtime:addEventListener( "onEscape", private.show )
Runtime:addEventListener( "onDied", private.show )

return public