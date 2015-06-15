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
ssk.getVersion = function() return "22 MAY 2015" end

local runningCoronaViewer 	= false 	-- Some features conflict with viewer and must be disabled
ssk.__measureSSK			= false		-- Show how much memory is used by each module and all of SSK

ssk.__enableAutoListeners	= true 		-- Enables automatic attachment of event listeners in extended display library

ssk.__desktopMode		 	= false 	-- Running in a 'desktop' app, not mobile.

ssk.__enableExperimental 	= false 	-- Enable experimental features (only for the brave and/or skilled)
ssk.__loadWIP 				= false 	-- Only for experts and SSK developer(s).

-- If measuring, get replacement 'require'
--
local local_require = ( ssk.__measureSSK ) and require("ssk.extras.measureSSK").measure_require or _G.require

-- ==
-- Load SSK Modules (mostly packaged into SSK super-object)
-- ==
--local_require "ssk.RGAutoclean"
local_require "ssk.RGGlobals"
local_require "ssk.RGExtensions"
--local_require "ssk.fixes.finalize" -- BORKED SOMEHOW (INFINITE LOOP?) EFM - Must resolve before re-enabling
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
local_require "ssk.RGCamera"
local_require "ssk.easyInputs.RGEasyInputs"
local_require "ssk.actions.RGActions"
local_require "ssk.RGMultiscroller"

--
-- Experimental Code
--
if(ssk.__enableExperimental) then 
	local_require "ssk.extras.lazyRequire" 
end

--
-- Works In Progress
--
if(ssk.__loadWIP) then
	local_require "ssk.wip.viewportCloner"
	local_require "ssk.wip.intersectFixer"
	local_require "ssk.wip.easyPositioner"
	local_require "ssk.wip.easyPicker.easyPicker"
	local_require "ssk.wip.colorPicker"
	local_require "ssk.wip.RGShader"
end	

--
-- External Libs/Modules (Written by others and used with credit.)
--
ssk.GGFile = local_require( "ssk.external.GGFile" ) -- Modified version of GlitchGames' GGFile (added binary copy and move) 
ssk.wait =  local_require( "ssk.external.wait" ) -- Adapted from Steven Johnson's work (ggcrunchy) https://github.com/ggcrunchy/samples
ssk.randomlua = local_require "ssk.external.randomlua" -- Various 'math.random' alternatives

-- Meaure Final Cost of SSK (if enabled)
if( ssk.__measureSSK ) then require("ssk.extras.measureSSK").summary() end

-- Frame counter (used for touch coalescing)
ssk.__lfc = 0
ssk.enterFrame = function( self ) self.__lfc = self.__lfc + 1; end; listen("enterFrame",ssk)
return ssk