-- =============================================================
-- Copyright Roaming Gamer, LLC. 2009-2015
-- =============================================================
-- WIP
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
----------------------------------------------------------------------
--	1. Requires
----------------------------------------------------------------------
-- none.

----------------------------------------------------------------------
-- 2. Declarations
----------------------------------------------------------------------

----------------------------------------------------------------------
--	3. Initialization
----------------------------------------------------------------------
-- none.

----------------------------------------------------------------------
-- 4. Definitions
----------------------------------------------------------------------
local rgShader = {}
_G.ssk.rgShader = rgShader
		
local mRand = math.random
local mSqrt = math.sqrt


function rgShader.measurePerf()
	local perfStart = system.getTimer()
	for i = 1, 100000 do
		local x = mSqrt(mRand(1,10000) * mRand(1,10000))
	end
	local perfStop = system.getTimer()
	rgShader.perfScore = round(perfStop - perfStart)

	rgShader.isHighPerf = (rgShader.perfScore < 100)
end
--timer.performWithDelay(1, rgShader.measurePerf )

local canHighP = system.getInfo( "gpuSupportsHighPrecisionFragmentShaders" )
rgShader.highp = canHighP

rgShader.enableHighhP = function( en )	
	if(en == nil) then en = true end
	rgShader.highp = en
end

rgShader.isHighP = function()
	return highp
end

rgShader.canHighP = function()
	return canHighP
end

rgShader.setFilter = function( obj, effectName )
	if( not isDisplayObject( obj) ) then return end
	if( not obj.fill ) then return end

	if( not effectName or effectName == "none") then
		obj.fill.effect = nil

	elseif( effectName == "blur" ) then
		obj.fill.effect = "filter.shader1" -- Graphics 2.0
		obj.fill.effect.horizontal.blurSize = 1
		obj.fill.effect.vertical.blurSize = 1	
	
	elseif( effectName == "gausian" ) then
		obj.fill.effect = "filter.blurGaussian" -- Graphics 2.0
		obj.fill.effect.horizontal = 2
		obj.fill.effect.vertical = 2
	
	elseif( effectName == "polkadots1" ) then
		obj.fill.effect = "filter.polkaDots" -- Graphics 2.0 ***
	
	elseif( effectName == "polkadots2" ) then
		obj.fill.effect = "filter.polkaDots" -- Graphics 2.0 
		obj.fill.effect.dotRadius = 0.5
		obj.fill.effect.numPixels = 16

	elseif( effectName == "depolka" ) then
		obj.fill.effect = "filter.polkaDots" -- Graphics 2.0 
		obj.fill.effect.dotRadius = 0.5
		obj.fill.effect.numPixels = 16
		transition.to( obj.fill.effect, { delay = 0, time = 1000, dotRadius = 0.5, numPixels = 2 } )

	elseif( effectName == "crystal" ) then
		obj.fill.effect = "filter.crystallize" -- Graphics 2.0 **********
		obj.fill.effect.numTiles = 6
		transition.to( obj.fill.effect, { delay = 3000, time = 2000, numTiles = 64 } )

	elseif( effectName == "crystal2" ) then
		obj.fill.effect = "filter.crystallize" -- Graphics 2.0 **********
		obj.fill.effect.numTiles = 16

	elseif( effectName == "emboss" ) then
		obj.fill.effect = "filter.emboss" -- Graphics 2.0 ***
	
	elseif( effectName == "frosted" ) then
		obj.fill.effect = "filter.frostedGlass" -- Graphics 2.0 ***
		obj.fill.effect.scale = 140

		--transition.to( obj.fill.effect, { delay = 1000, time = 2000, scale = 64 } )

	elseif( effectName == "sobel" ) then
		obj.fill.effect = "filter.sobel" -- Graphics 2.0 **

	elseif( effectName == "grayscale" ) then
		obj.fill.effect = "filter.grayscale" -- Graphics 2.0 **

	elseif( effectName == "posterize" ) then
		obj.fill.effect = "filter.posterize" -- Graphics 2.0 **
		obj.fill.effect.colorsPerChannel = 3

	elseif( effectName == "pixelate" ) then
		obj.fill.effect = "filter.pixelate" -- Graphics 2.0 **
		obj.fill.effect.numPixels = 3

	elseif( effectName == "saturate" ) then
		obj.fill.effect = "filter.saturate" -- Graphics 2.0 **
		obj.fill.effect.intensity = 0.01

	elseif( effectName == "wobble" ) then
		obj.fill.effect = "filter.wobble" -- Graphics 2.0 **
		obj.fill.effect.amplitude = 25

	elseif( effectName == "scatter" ) then
		obj.fill.effect = "filter.scatter" -- Graphics 2.0 **
		obj.fill.effect.intensity = 0.05

	elseif( effectName == "brightness" ) then
		obj.fill.effect = "filter.brightness" -- Graphics 2.0 **
		obj.fill.effect.intensity = 0.1

	elseif( effectName == "crosshatch" ) then
		obj.fill.effect = "filter.crosshatch"
		obj.fill.effect.grain = 4					

	elseif( effectName == "vignette" ) then
		obj.fill.effect = "filter.vignette" -- Graphics 2.0
		obj.fill.effect.radius = 0.6

	elseif( effectName == "swirl" ) then
		obj.fill.effect = "filter.swirl" -- Graphics 2.0 *****
		obj.fill.effect.intensity = 1
		transition.to( obj.fill.effect, { delay = 1000, time = 1000, intensity = 0 } )
	end

end


return rgShader
