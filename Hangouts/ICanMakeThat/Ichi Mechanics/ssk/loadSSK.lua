-- =============================================================
-- Copyright Roaming Gamer, LLC. 2009-2015
-- =============================================================
-- SSKCorona Loader 
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
-- Create ssk global if needed
_G.ssk = _G.ssk or {}
ssk.getVersion = function() return "11 MAY 2015" end

local runningCoronaViewer 	= false -- Some features conflict with viewer and must be disabled
local measureSSK			= false -- Show how much memory is used by each module and all of SSK
ssk.__enableExperimental 	= false -- Enable experimental features (only for the brave and/or skilled)
ssk.__desktopMode		 	= true -- Running in a 'desktop' app, not mobile.
ssk.__enableAutoListeners	= true -- Enables automatic attachment of event listeners in extended display library

-- If meaureing, get replacement 'require'
--
local local_require = ( measureSSK ) and require("ssk.extras.measureSSK").measure_require or _G.require

-- ==
-- Load SSK Modules (mostly packaged into SSK super-object)
-- ==
--local_require "ssk.RGAutoclean"
local_require "ssk.RGGlobals"
local_require "ssk.RGExtensions"
--local_require "ssk.fixes.finalize" -- BORKED SOMEHOW (INFINITE LOOP?)
if( not runningCoronaViewer ) then local_require "ssk.RGAndroid" end

local_require "ssk.RGPoints" 
local_require "ssk.RGCC"
local_require "ssk.RGDisplay"
local_require "ssk.RGEasyInterfaces"
local_require "ssk.RGEasyKeys"
local_require "ssk.RGMath2D"
local_require "ssk.RGMisc"
local_require "ssk.RGFiles"
local_require "ssk.RGPersist"
local_require "ssk.RGEasyBench"
local_require "ssk.RGMultiscroller"

--
-- Experimental Code
--
if(ssk.__enableExperimental) then 
	local_require "ssk.extras.lazyRequire" 
end

--
-- External Libs/Modules (Written by others and used with credit.)
--
ssk.GGFile = local_require( "ssk.external.GGFile" ) -- Modified version of GlitchGames' GGFile (added binary copy and move) 
ssk.wait =  local_require( "ssk.external.wait" ) -- Adapted from Steven Johnson's work (ggcrunchy) https://github.com/ggcrunchy/samples
ssk.randomlua = local_require "ssk.external.randomlua" -- Various 'math.random' alternatives

-- Meaure Final Cost of SSK (if enabled)
if( measureSSK ) then require("ssk.extras.measureSSK").summary() end
return ssk