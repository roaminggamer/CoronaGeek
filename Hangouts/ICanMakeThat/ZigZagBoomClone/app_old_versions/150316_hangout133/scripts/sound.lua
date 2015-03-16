-- =============================================================
-- Copyright Roaming Gamer, LLC. 2009-2014 
-- =============================================================
-- 
-- =============================================================
local audio = require "audio"
local sound = {}

-- Local storage for handles to sound files
--
local effects = {}

-- Sound Effect EVENT listener
--
sound.onSFX = function( self, event )
	local sfx = effects[event.sfx]
	if( not sfx ) then return end
	local channel = audio.findFreeChannel( 2 )
	if( channel ) then
		audio.play( sfx,  { channel = channel } )
	end
end; listen( "onSFX", sound )

function sound.init()
	effects["click"] 		= audio.loadSound("sounds/sfx/click.mp3")
	effects["explosion"] 	= audio.loadSound("sounds/sfx/explosion.wav")
end

-- Set the sound track file
--
sound.playSoundTrack = function( path )
	local soundTrack = audio.loadStream( path )
	audio.play( soundTrack,  { channel=1, loops=-1, fadein = 3000 } )
end

return sound