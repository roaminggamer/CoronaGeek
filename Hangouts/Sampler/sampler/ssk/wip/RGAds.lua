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
--[[
1. Configure IDs below with correct values for networks you will use.

2. Optionally set up custom callback(s) and/or event Listeners

local function customCB( networkName, event )
	print("*** In custom callback: " .. networkName )
	table.dump(event)
end

local eventListener = function( event )
	table.dump(event)
end
listen( "RGADS_ERROR", eventListener )
listen( "RGADS_INSTALLED", eventListener )
listen( "RGADS_RECEIVED", eventListener )
listen( "RGADS_DISPLAYED", eventListener )
listen( "RGADS_SUCCESS", eventListener )


3. Init ad networks
-- Testing mode
ssk.ads.init( { "admob", "revmob", "iads", "vungle" }, 
              { testMode = true, captureData = true },
              customCB  ) 
	
-- Production mode (data capture is optional)
ssk.ads.init( { "admob", "revmob", "iads", "vungle" }, { captureData = true }, customCB ) 


4. (optional) Cache ads (not working yet)
ssk.ads.cacheAds( { "admob", "revmob", "iads", "vungle" } )


5. Request an ad (banner or full page [interstitial] )

--timer.performWithDelay( 500, function() ssk.ads.full( "revmob" ) end )
--timer.performWithDelay( 500, function() ssk.ads.banner( "revmob" ) end )
--timer.performWithDelay( 500, function() ssk.ads.banner( "revmob", { x = centerX, y = h - 35, width = w, height = 80 }, customCB ) end )
--timer.performWithDelay( 500, function() ssk.ads.banner( "revmob", { width = 300, height = 50 }, customCB ) end )
--timer.performWithDelay( 500, function() ssk.ads.full( "admob", nil, customCB ) end )

timer.performWithDelay( 5000, function() ssk.ads.banner( "vungle", nil, customCB ) end )



--]]
-- =============================================================
-- For testing ONLY
local onAndroid = onAndroid or onSimulator
local oniOS 	= onAndroid or onSimulator

-- =============================================================
-- Requires
-- =============================================================
_G.ads = require "ads"

-- =============================================================
-- Locals and Forward Declarations
-- =============================================================
local knownNetworks = { "admob", "revmob", "iads", "vungle" }
local enabledNetworks = {}

local lastAd
local lastCB

local adsReadyCount = 0

local testMode = false
local debugLevel  = 3

local function dprint( lvl, ... )
	if( testMode or debugLevel >= lvl ) then
		print( unpack(arg) )
	end
end

local function tdump( lvl, tbl )
	if( testMode or debugLevel >= lvl ) then
		table.dump(tbl)
	end
end	

local getTimer = system.getTimer

-- PLEASE DO NOT USE MY IDs!!  I'm leaving them here as I work on improving this
--

local ADMOB_IDS = 
	{ 
		["Android"] 	= "ca-app-pub-2064790293916744/8050477511",   -- Tester Ad
		["iPhone OS"] 	= "ca-app-pub-2064790293916744/9527210715"   
	}

local IADS_ID = "com.roaminggamer.rad"	

local REVMOB_IDS = 
	{ 
		["Android"] 	= "530400ccedec72d144f63a5a",  
		["iPhone OS"] 	= "530402e8282084b828f84154"   
	}

local VUNGLE_IDS = 
	{ 
		["Android"] 	= "530401f5a3a442915f000078", 
		["iPhone OS"] 	= "530401594cfba3935f00007e" 
	}

local adMobListener
local iAdsListener
local vungleListener
local revMobListener

local captureUsefulData
local locationListener
local locationData
local runAd
local runBanner
local runFullScreen

-- =============================================================
-- Functions
-- =============================================================
local function isEnabled( name )
	return ( enabledNetworks[name] ~= nil)
end

local function init( networks, params, cb )
	local enabledNetworks = networks or knownNetworks
	local params = params or {}
	testMode = fnn( params.testMode, false)
	local captureData = fnn( params.captureData, false)

	lastCB = cb

	tdump(2,enabledNetworks)

	-- Grab data for future use if we can
	if(captureData) then
		captureUsefulData()
	end	

	for k,v in pairs( enabledNetworks ) do
		--
		-- AdMob
		--
		if( v == "admob" ) then
			if(onSimulator) then
				if( lastCB ) then
					lastCB( "admob", { isError = true, response = "On simulator", time = getTimer() } )
				end
				post( "RGADS_ERROR", { network = "admob", event = { isError = true, response = "On simulator", time = getTimer() } } )
			end
			if( onAndroid ) then
				dprint(1,"Initializing ADMOB FOR ANDROID " .. ADMOB_IDS["Android"])
				ads.init( "admob", ADMOB_IDS["Android"] , adMobListener )
			

			elseif( oniOS ) then
				dprint(1,"Initializing ADMOB FOR IOS " .. ADMOB_IDS["iPhone OS"])
				ads.init( "admob", ADMOB_IDS["iPhone OS"] , adMobListener )

				adsReadyCount = adsReadyCount + 1
			end
		--
		-- iAds
		--
		elseif( v == "iads" ) then
			if(onSimulator) then
				if( lastCB ) then
					lastCB( "iads", { isError = true, response = "On simulator", time = getTimer() } )
				end
				post( "RGADS_ERROR", { network = "iads", event = { isError = true, response = "On simulator" } } )
			end
			if( oniOS ) then
				dprint(1,"Initializing IADS FOR IOS" .. IADS_ID)
				ads.init( "iads", IADS_ID, iAdsListener )

				adsReadyCount = adsReadyCount + 1
			end
		--
		-- RevMob
		--
		elseif( v == "revmob" ) then
			_G.RevMob = require("ssk.ads.revmob")
			if( onAndroid ) then
				dprint(1,"Initializing REVMOB FOR ANDROID " .. REVMOB_IDS["Android"])
			elseif( oniOS ) then
				dprint(1,"Initializing REVMOB FOR IOS " .. REVMOB_IDS["iPhone IOS"])
			end
			RevMob.startSession(REVMOB_IDS)

			if( testMode ) then
				dprint(1,"Setting up testing mode for RevMob")
				--RevMob.settestMode(RevMob.TEST_WITH_ADS)
				RevMob.settestMode(RevMob.TEST_WITHOUT_ADS)
				--RevMob.settestMode(RevMob.TEST_DISABLED)
			end

		--
		-- Vungle
		--
		elseif( v == "vungle" ) then
			if(onSimulator) then
				if( lastCB ) then
					lastCB( "vungle", { isError = true, response = "On simulator", time = getTimer() } )
				end
				post( "RGADS_ERROR", { network = "vungle", event = { isError = true, response = "On simulator" } } )
			end
			if( onAndroid ) then
				dprint(1,"Initializing VUNGLE FOR ANDROID " .. VUNGLE_IDS["Android"])
				ads.init( "vungle", VUNGLE_IDS["Android"] , vungleListener )
		
			elseif( oniOS ) then
				dprint(1,"Initializing VUNGLE FOR IOS " .. VUNGLE_IDS["iPhone IOS"])
				ads.init( "vungle", VUNGLE_IDS["iPhone IOS"] , vungleListener )

			end
		end

	end
end

captureUsefulData = function()
	Runtime:addEventListener( "location", locationListener )
end


local function cacheAds( networkNames )
	-- EFM add if possible
end


runAd = function( networkName, banner, params )
	local networkName = networkName or "admob"
	local banner = fnn(banner, false)
	if( banner ) then
		dprint(1,"Attempting to show BANNER ad with network " .. networkName )
	else
		dprint(1,"Attempting to show FULL-SCREEN ad with network " .. networkName )
	end

	--
	-- AdMob
	--
	if(networkName == "admob") then		
		ads:setCurrentProvider( networkName )
		local params = params or { x = 0, y = 0, testMode = testMode }
		if(banner) then
			ads.show( "banner", params )
		else
			ads.show( "interstitial", params )
		end
	
	--
	-- inMobi
	--
	elseif(networkName == "inmobi") then				
		local params = params or 
			{
				isAnimated = false,
		   		isAutoRotation = true,
			}

		ads:setCurrentProvider( networkName )
		if(banner) then
			if( lastCB ) then
				lastCB( "inmobi", { isError = true, response = "Banner not supported.", time = getTimer() } )
			end
			post( "RGADS_ERROR", { network = "inmobi", event = { isError = true, response = "Banner not supported.", time = getTimer() } } )
			print("WARNING: inMobi only supports full page interstitials.")
		else
			ads.show( "interstitial", params )
		end

	--
	-- Inneractive
	--
	elseif(networkName == "inneractive") then			
		ads:setCurrentProvider( networkName )
		local params = params or { x=0, y=0, interval=60 }			
		if(banner) then
			ads.show( "banner", params )
		else
			ads.show( "interstitial", params )
		end

	--
	-- iAds
	--
	elseif(networkName == "iads") then		
		local params = params or 
			{
				isAnimated = true,
		   		isAutoRotation = true,
		   		x = -unusedWidth/2 
		   		--y = h + unusedHeight/2,
			}
		ads:setCurrentProvider( networkName )
		if(banner) then
			ads.show( "banner", params )
		else
			ads.show( "interstitial", params )
		end

	--
	-- RevMob
	--
	elseif(networkName == "revmob") then		
		local params = params or { x = centerX, y = (w/10 + 5), width = w, height = w/5 }

		params.x = params.x or centerX
		params.width = params.width or w
		params.height = params.height or params.width/5
		params.y = params.y or (params.height/2 + 5)

		if(locationData) then
			tdump(2,locationData)
			if(locationData.latitude) then
				RevMob.setUserLocationLatitude(locationData.latitude)
			end
			if(locationData.longitude) then
				RevMob.setUserLocationLatitude(locationData.longitude)
			end
			if(locationData.accuracy) then
				RevMob.setUserLocationLatitude(locationData.accuracy)
			end
		end
		--[[
	      RevMob.setUserGender("male")
	      RevMob.setUserAgeRangeMin(18)
	      RevMob.setUserAgeRangeMax(25)
	      RevMob.setUserBirthday("1995/01/01")
	      RevMob.setUserPage("http://twitter.com/revmob")
	      
	      local interests = {"corona", "apps", "mobile"}
	      RevMob.setUserInterests(interests)		      
		--]]
		--Runtime:addEventListener( "location", locationListener )

		if(banner) then
			params.listener = params.listener or revMobListener
			lastAd = RevMob.createBanner( params  )
		else
			lastAd = RevMob.showFullscreen(revMobListener)
		end

		table.dump(lastAd)

	--
	-- Vungle
	--
	elseif(networkName == "vungle") then		
		local params = params or 
			{
				isAnimated = false,
		   		isAutoRotation = true
			}

		params.listener = params.listener or vungle			
		ads:setCurrentProvider( networkName )

		dprint(2, "Running vungle ad now...")
		tdump(2, params )
		if(banner) then
			if( lastCB ) then
				lastCB( "vungle", { isError = true, response = "Banner not supported.", time = getTimer() } )
			end
			post( "RGADS_ERROR", { network = "vungle", event = { isError = true, response = "Banner not supported.", time = getTimer() } } )
			print("WARNING: Vungle only supports full page interstitials.")
		else
			ads.show( "interstitial", params )
		end
	end
end

runBanner = function( networkName, params, cb )
	dprint(1,"runBanner()")
	lastCB = cb
	runAd( networkName, true, params )
end

runFullScreen = function( networkName, params, cb  )
	dprint(1,"runFullScreen()")
	lastCB = cb
	runAd( networkName, false, params )
end


-- =============================================================
-- Callbacks (Listeners)
-- =============================================================
adMobListener = function( event )
	dprint(2,"Entering adMobListener")

	-- "adStart", "adEnd", "adView", 
	local type = event.type 
	local isError = event.isError
	event.time = event.time or getTimer()

	if( lastCB ) then
		lastCB( "admob", event )
	end

	if( isError == true ) then
		post( "RGADS_ERROR", { network = "admob", event = event } )
		
	else
		post( "RGADS_SUCCESS", { network = "admob", event = event } )
	end

	return true
end

iAdsListener = function( event )
	dprint(2,"Entering iAdsListener")
	tdump(2,event)
	if ( event.isError ) then
		--storyboard.showOverlay( "selfpromo" )
	end
	return true
end

vungleListener = function( event )
	dprint(2,"Entering vungleListener")
	tdump(2,event)

	-- "adStart", "adEnd", "adView", 
	local type = event.type 
	local isError = event.isError
	event.time = event.time or getTimer()

	if( lastCB ) then
		lastCB( "vungle", event )
	end

	if( isError == true ) then
		post( "RGADS_ERROR", { network = "vungle", event = event } )

	elseif( type == "installReceived" ) then
		post( "RGADS_INSTALLED", { network = "vungle", event = event } )
	
	elseif( type == "adStart" ) then
		post( "RGADS_RECEIVED", { network = "vungle", event = event } )

	elseif( type == "adEnd" ) then
		post( "RGADS_DISPLAYED", { network = "vungle", event = event } )

	elseif( type == "adView"  ) then
		post( "RGADS_SUCCESS", { network = "vungle", event = event } )
	end

	-- Video ad not yet downloaded and available
	if ( event.type == "adStart" and event.isError ) then
		if ( system.getInfo("platformName") == "Android" ) then
			ads:setCurrentProvider( "admob" )
		else
			ads:setCurrentProvider( "iAds" )
		end
		ads.show( "interstitial" )
	elseif ( event.type == "adEnd" ) then
		-- Ad was successfully shown and ended; hide the overlay so the app can resume.
		--EFM storyboard.hideOverlay()
	else
		dprint(2,"Received event", event.type )
	end

	return true
end

revMobListener = function( event )
	-- "adReceived", "adNotReceived", "adDisplayed", "adClicked", "adClosed", "installReceived", "installNotReceived", "unknownError"
	local type = event.type 
	if( not event.time ) then event.time = getTimer() end
	tdump(2,event)

	if( lastCB ) then
		lastCB( "revmob", event )
	end


	if( type == "adNotReceived" or 
		type == "installNotReceived" or 
		type == "unknownError" ) then

		post( "RGADS_ERROR", { network = "revmob", event = event } )

	elseif( type == "installReceived" ) then
		post( "RGADS_INSTALLED", { network = "revmob", event = event } )
	
	elseif( type == "adReceived" ) then
		post( "RGADS_RECEIVED", { network = "revmob", event = event } )

	elseif( type == "adDisplayed" ) then
		post( "RGADS_DISPLAYED", { network = "revmob", event = event } )

	elseif( type == "adClicked" or type == "adClosed" ) then
		post( "RGADS_SUCCESS", { network = "revmob", event = event } )
	end

	return true
end

locationListener = function(event)
	-- Check for error (user may have turned off Location Services)
	if event.errorCode then
		dprint(2, "Location error: " .. tostring( event.errorMessage ) )
	else
		locationData = {}
		locationData.latitude = event.latitude
		locationData.longitude = event.longitude
		locationData.accuracy = event.accuracy
	end
	Runtime:removeEventListener( "location", locationListener )
end

-- =============================================================
-- Module
-- =============================================================
public = {}

public.isEnabled 			= isEnabled

public.init 				= init
--public.captureUsefulData	= captureUsefulData
public.cacheAds				= cacheAds

public.run					= runAd
public.banner				= runBanner
public.full 				= runFullScreen


if( not _G.ssk ) then
	_G.ssk = {}
end
_G.ssk.ads = public
return public