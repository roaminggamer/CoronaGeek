-- =============================================================
-- Copyright Roaming Gamer, LLC. 2009-2015 
-- =============================================================
-- This content produced for Corona Geek Hangouts audience.
-- You may use any and all contents in this example to make a game or app.
-- =============================================================
local audio    = require "audio"
local common 	= require "scripts.common"
local public = {}

local getTimer = system.getTimer

-- Local storage for handles to sound files
--
local effects = {}

local minTime = {}
minTime.zombie1 = 2500
minTime.zombie2 = 5000
minTime.zombie3 = 5000
minTime.archer = 2000
minTime.bowfire = 150
local lastTime = {}

local altVolume = {}
altVolume.zombie2 = 0.25
altVolume.zombie3 = 0.25
altVolume.died = 0.5
altVolume.nextlevel = 0.5

-- Sound Effects Enable
--
local sfxEn = false
public.enableSFX = function( enable )
	sfxEn = enable 
end

-- Sound Effect EVENT listener
--
local function onSFX( event )
	local sfx = effects[event.sfx]
	if( not sfx ) then return end
	if( not sfxEn ) then return end
   
   
   local curTime = getTimer()   
   print(curTime, minTime[event.sfx], lastTime[event.sfx] )
   if( minTime[event.sfx] and lastTime[event.sfx] ) then      
      if( curTime - lastTime[event.sfx] < minTime[event.sfx] ) then
         return
      end
   end
   lastTime[event.sfx] = curTime
      
   
	local channel = audio.findFreeChannel( 2 )
	--table.dump(event)

	if( channel ) then
      audio.setVolume( altVolume[event.sfx] or 1, { channel = channel  }  )
		audio.play( sfx,  { channel = channel  } )
	end
end; listen( "onSFX", onSFX )

function public.init()
	effects["coin1"] 		   = audio.loadSound("sounds/sfx/Pickup_Coin.wav")
	effects["coin2"] 		   = audio.loadSound("sounds/sfx/Pickup_Coin2.wav")
	effects["coin3"] 		   = audio.loadSound("sounds/sfx/Pickup_Coin3.wav")
   effects["zombie1"]      = audio.loadSound("sounds/sfx/Zombie Kill You.wav")
   effects["zombie2"]      = audio.loadSound("sounds/sfx/Zombie Attack Walk.wav")
   effects["zombie3"]      = audio.loadSound("sounds/sfx/Zombie Moan.wav")
   effects["archer"]       = audio.loadSound("sounds/sfx/Archer.wav")
   effects["bowfire"]      = audio.loadSound("sounds/sfx/Bow Fire.wav")
   effects["died"]         = audio.loadSound("sounds/sfx/died.wav")
   effects["gem"]          = audio.loadSound("sounds/sfx/gem.wav")
   effects["nextlevel"]    = audio.loadSound("sounds/sfx/nextlevel.wav")
end

-- Set the sound track file
--
local firstPlay = true
public.playSoundTrack = function( path )
	if( firstPlay ) then
		firstPlay = false
		local soundTrack = audio.loadStream( path )
		audio.play( soundTrack,  { channel=1, loops=-1, fadein = 3000 } )
	else
		audio.resume( 1 )
	end
end

public.pauseSoundTrack = function( )
	audio.pause( 1 )
end

return public