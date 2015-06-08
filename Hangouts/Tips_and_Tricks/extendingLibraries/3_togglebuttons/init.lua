local persist = ssk.persist

local init = {}

function init.run()

	persist.setDefault( "settings.json", "musicEn", false )

	persist.setDefault( "settings.json", "sfxEn", true )

	persist.setDefault( "settings.json", "difficulty", 1 )
end

return init