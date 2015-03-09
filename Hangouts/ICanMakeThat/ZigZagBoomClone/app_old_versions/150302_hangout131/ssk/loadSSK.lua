-- =============================================================
-- Copyright Roaming Gamer, LLC. 2009-2015
-- =============================================================
-- SSKCorona Loader 
-- =============================================================
-- =============================================================
local measureSSK = false
local local_require = _G.require
local preMem
local postMem
if( measureSSK ) then
	function string:lpad (len, char)
		local theStr = self
	    if char == nil then char = ' ' end
	    return string.rep(char, len - #theStr) .. theStr
	end
	function string:rpad(len, char)
		local theStr = self
	    if char == nil then char = ' ' end
	    return theStr .. string.rep(char, len - #theStr)
	end
	collectgarbage("collect")
	preMem = collectgarbage( "count" )
	local_require = function( toRequire )		
		collectgarbage("collect")
		local before = collectgarbage( "count" )
		local retVal = require( toRequire )
		collectgarbage("collect")
		local after = collectgarbage( "count" )
		print( string.rpad( toRequire, 35 ) .. " : " .. string.lpad(round( after - before ) .. " KB", 10 ) )
		return retVal
	end
end
if( not _G.ssk ) then
	_G.ssk = {}
end
-- ==
-- TheSSKCorona super object; Most libraries will be attached to this.
-- ==
local_require "ssk.RGGlobals"
local_require "ssk.RGExtensions"
--local_require "ssk.fixes.finalize"
local_require "ssk.RGAndroidButtons" -- Conflicts with CoronaViewer
local_require "ssk.RGCamera"
local_require "ssk.RGCC"
local_require "ssk.RGDisplay"
local_require "ssk.RGEasyBench"
local_require "ssk.RGEasyInterfaces"
local_require "ssk.RGEasyKeys"
local_require "ssk.RGEasyPush"
local_require "ssk.RGInputs"
local_require "ssk.RGMath2D"
local_require "ssk.RGMisc"
local_require "ssk.RGPersist"
local_require "ssk.RGEasySocial"
--local_require "ssk.RGAutoLocalization" -- FOR EXAMPLE ONLY (DO NOT USE)

local_require "ssk.presets.gel.presets"


--
-- External Libs/Modules
--
-- Modified version of GlitchGames' GGFile (adds binary copy and move)
ssk.GGFile = local_require( "ssk.external.GGFile" )

-- Copied from Jason Schroeder work: http://www.jasonschroeder.com
ssk.progressRing 	= local_require( "ssk.external.progressRing" ) -- http://www.jasonschroeder.com/corona/progressRing/progressRing.lua
ssk.colorPicker 	= local_require( "ssk.external.colorPicker" )

-- Adapted from Steven Johnson's work (ggcrunchy) https://github.com/ggcrunchy/samples
--
ssk.wait =  local_require( "ssk.external.wait" ) 

-- Modified version of Bjorn's OOP-ing code
ssk.object = local_require "ssk.external.object"


ssk.randomlua = local_require "ssk.external.randomlua"

ssk.getVersion = function() return "01 MAR 2015" end

if( measureSSK ) then
	collectgarbage("collect")
	postMem = collectgarbage( "count" )
	print("---------------------------------------")
	print(  string.rpad( "SSK Total", 25 ) .. " : " .. string.lpad(round( (postMem - preMem), 2 ) .. " KB", 10) )
	print("---------------------------------------")
end

return ssk