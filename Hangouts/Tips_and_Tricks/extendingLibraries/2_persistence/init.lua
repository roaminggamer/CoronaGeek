local persist = ssk.persist

local init = {}

function init.run()

	persist.setDefault( "settings.json", "volume", 0.5 )

	persist.setDefault( "settings.json", "coins", 100 )

	persist.setDefault( "settings.json", "email", "bob@fakemail.com" )
end

return init