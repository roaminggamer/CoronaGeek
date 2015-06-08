local persist = ssk.persist

local test = {}

function test.run()
	print( "    Volume is: ", persist.get( "settings.json", "volume" ) )
 	print( "     Coins is: ", persist.get( "settings.json", "coins" ) )
	print( "User email is: ", persist.get( "settings.json", "email" ) ) 
	print( " User name is: ", persist.get( "settings.json", "username" ) ) 
end


return test