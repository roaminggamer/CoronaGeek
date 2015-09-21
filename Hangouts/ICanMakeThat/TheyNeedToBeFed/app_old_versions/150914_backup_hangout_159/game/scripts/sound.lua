-- =============================================================
-- Copyright Roaming Gamer, LLC. 2009-2015 
-- =============================================================
-- 
-- =============================================================
local audio = require "audio"
local sound = {}

-- Local storage for handles to sound files
--
local effects = {}

-- Sound Effects Enable
--
local sfxEn = false
sound.enableSFX = function( enable )
	sfxEn = enable 
end

-- Sound Effect EVENT listener
--
local function onSFX( event )
	local sfx = effects[event.sfx]
	if( not sfx ) then return end
	if( not sfxEn ) then return end
	local channel = audio.findFreeChannel( 2 )
	table.dump(event)

	if( channel ) then
		audio.play( sfx,  { channel = channel } )
	end
end; listen( "onSFX", onSFX )

function sound.init()
	effects["win"] 			= audio.loadSound("sounds/sfx/win.wav")
	effects["lose"] 		= audio.loadSound("sounds/sfx/lose.wav")

	effects["coin1"] 		= audio.loadSound("sounds/sfx/Pickup_Coin.wav")
	effects["coin2"] 		= audio.loadSound("sounds/sfx/Pickup_Coin2.wav")
	effects["coin3"] 		= audio.loadSound("sounds/sfx/Pickup_Coin3.wav")

	effects["jump1"] 		= audio.loadSound("sounds/sfx/Jump2.wav")
	effects["jump2"] 		= audio.loadSound("sounds/sfx/Jump3.wav")
	effects["jump3"] 		= audio.loadSound("sounds/sfx/Jump5.wav")

	effects["good1"] 	= audio.loadSound("sounds/sfx/g1.wav")
	effects["good2"] 	= audio.loadSound("sounds/sfx/g2.wav")
	effects["bad"] 	= audio.loadSound("sounds/sfx/b1.wav")
end

-- Set the sound track file
--
local firstPlay = true
sound.playSoundTrack = function( path )
	if( firstPlay ) then
		firstPlay = false
		local soundTrack = audio.loadStream( path )
		audio.play( soundTrack,  { channel=1, loops=-1, fadein = 3000 } )
	else
		audio.resume( 1 )
	end
end

sound.pauseSoundTrack = function( )
	audio.pause( 1 )
end

return sound