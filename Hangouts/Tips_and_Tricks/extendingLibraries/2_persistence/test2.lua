local persist = ssk.persist

local test = {}

function test.run()
	persist.set( "settings.json", "volume", round(math.random(),2) )

	persist.set( "settings.json", "coins", persist.get( "settings.json", "coins" ) - 5 ) 
 	
	persist.set( "settings.json", "username", "Bob The Baker" ) 
end


return test