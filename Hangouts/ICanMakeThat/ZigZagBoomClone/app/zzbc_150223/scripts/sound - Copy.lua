-- =============================================================
-- Copyright Roaming Gamer, LLC. 2009-2014 
-- =============================================================
-- 
-- =============================================================
local sound = {}

-- Local storage for handles to sound files
--
local effects = {}

-- Sound Effect EVENT listener
--
sound.onSFX = function( self, event )
	local sfx = effects[event.sfx]
	if( not sfx ) then return end
	media.playEventSound( sfx )
end; listen( "onSFX", sound )

function sound.init()
	effects["click"] 		= media.newEventSound("sounds/sfx/click.mp3")
	effects["explosion"] 	= media.newEventSound("sounds/sfx/explosion.wav")
end

-- Set the sound track file
--
sound.playSoundTrack = function( path )
	media.playSound( path )
end

return sound