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
-- Usage:
-- =============================================================
--[[
1. (Optionally) Configure Keys below with correct values for provider you will use.

2. Call init().  Note: If you did not set up keys in step 1, pass in the right key here.

ssk.analytics.init( "flurry" )
--ssk.analytics.init( "flurry", "Android" )
--ssk.analytics.init( "flurry", "Universal" )
--ssk.analytics.init( "flurry", "iPad" )
--ssk.analytics.init( "flurry", "Android", "ABCDEFG" )


3. (Optional) Enable crash logging:
ssk.analytics.logCrashes()



4. Elswhere in your code, log events:

ssk.analytics.logEvent( "GameStarted" )
ssk.analytics.logEvent( "LevelReached", { level = 10 } )




--]]
-- =============================================================
-- For testing ONLY
--local onAndroid = onAndroid or onSimulator
--local oniOS 	= onAndroid or onSimulator

-- =============================================================
-- Requires
-- =============================================================
_G.analytics = require "analytics"

-- =============================================================
-- Locals and Forward Declarations
-- =============================================================
local knownProviders = { "flurry", "amplitude" }
local activeProvider = ""

local universal 	= true
local debugLevel  = 2

local function dprint( lvl, ... )
	if( debugLevel >= lvl ) then
		print( unpack(arg) )
	end
end

local function tdump( lvl, tbl )
	if( debugLevel >= lvl ) then
		table.dump(tbl)
	end
end	

local getTimer = system.getTimer


local AnalyticKeys = {}
AnalyticKeys.flurry =
	{ 
		["Android"] 		= "YBV4X7FGGCPYWNWD2TV8",  
		["Universal"] 		= "G85W6YJSQBSQSFVQKJF2",
		["iPad"] 			= "RRNXBGPX9J9PX5Y22N86"
	}

AnalyticKeys.amplitude =
	{ 
		["Android"] 		= "EFM",  
		["Universal"] 		= "EFM",
		["iPad"] 			= "EFM"
	}

local init
local logEvent
local logRevenue
local logCrashes

-- =============================================================
-- Functions
-- =============================================================
init = function( provider, mode, key )
	local activeProvider = provider or "flurry"
	local mode = mode
	if( not mode ) then
		if( oniOS ) then  
			mode = "Universal" 
			if(not AnalyticKeys[provider][mode]) then mode = "iPad" end
		else
			mode = "Android"
		end
	end
	local key = key or AnalyticKeys[provider][mode]

	dprint(2, "ssk.analytics.init( " .. tostring(activeProvider) .. ", " .. tostring(mode) .. " ) Key == " .. tostring(key) )


	if( activeProvider == "amplitude") then 
		_G.amplitude = require "plugin.amplitude"
		amplitude.init( key )
	else
		analytics.init( key )
	end	
end

logRevenue = function( amount )
	if( activeProvider == "amplitude") then
		amplitude.logRevenue( amount )
	else
		analytics.logEvent( "Revnue", { amount = amount } )
	end
end

 

logEvent = function( event, params )
	if( activeProvider == "amplitude") then
		amplitude.logEvent( event )
		--amplitude.logEvent( event, params ) -- Params not supported?
	else
		analytics.logEvent( event, params )
	end
end

logCrashes = function()
	local function myUnhandledErrorListener( event )
	   logEvent( "Crash",
	      {
	         errorMessage=event.errorMessage,
	         stackTrace=event.stackTrace
	      }
	   )
	end
	Runtime:addEventListener("unhandledError", myUnhandledErrorListener) 
end

-- =============================================================
-- Module
-- =============================================================
public = {}

public.init 				= init
public.logEvent				= logEvent
public.logRevenue 			= logRevenue
public.logCrashes			= logCrashes

if( not _G.ssk ) then
	_G.ssk = {}
end
_G.ssk.analytics = public
return public