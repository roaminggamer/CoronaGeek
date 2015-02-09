local theData = table.load( "myPersistentData.json" ) or {}

local myPersistentData = {}

myPersistentData.store = function( )
	table.save( theData, "myPersistentData.json" )
end


myPersistentData.get = function( name  )
	return theData[name]
end

myPersistentData.set = function( name, value, autoStore )
	theData[name] = value
	if(autoStore) then myPersistentData.store() end
end

--
-- Set Defaults
--
local defaults = {}
defaults["count"] = 0

for k,v in pairs(defaults) do
	theData[k] = theData[k] or v
end

myPersistentData.store()

return myPersistentData