local composer 		= require( "composer" )

require "scripts.fromForums" -- Some new transition definitions, found in the forums

-- ==
--    table.deepCopy( src [ , dst ]) - Copies multi-level tables; handles non-integer indexes; does not copy metatable
-- ==
function table.deepCopy( src, dst )
	local dst = dst or {}
	for k,v in pairs(src) do 
		if( type(v) == "table" ) then
			dst[k] = table.deepCopy( v, nil )
		else
			dst[k] = v
		end		
	end
	return dst
end

local function dumpTransitionEffect( name )
	for k,v in pairs( composer.effectList[name] ) do
		print(k,v)
	end
end

--[[ Current Corona Transitions :	
	"fade",
	"crossFade",
	"zoomOutIn",
	"zoomOutInFade",
	"zoomInOut",
	"zoomInOutFade",
	"flip",
	"flipFadeOutIn",
	"zoomOutInRotate",
	"zoomOutInFadeRotate",
	"zoomInOutRotate",
	"zoomInOutFadeRotate",
	"fromRight",
	"fromLeft",
	"fromTop",
	"fromBottom",
	"slideLeft",
	"slideRight" ,
	"slideDown",
	"slideUp",
--]]

-- 1. Print out fields and values in original
--
print("\n\n\n ORIGINAL =========================================")
dumpTransitionEffect( "fromBottom" )

-- 2. Clone (deep copy) the existing transition effect
--
composer.effectList["myEffect"] = table.deepCopy( composer.effectList["fromBottom"] )

-- 3. Modify the new transition effect
--
--composer.effectList["myEffect"].sceneAbove = false -- New scene is on top of old scene?
--composer.effectList["myEffect"].concurrent = false -- Create while transitioning?

-- 4. Print out fields and values in original
--
print("\n\n\n NEW =========================================")
dumpTransitionEffect( "myEffect" )



