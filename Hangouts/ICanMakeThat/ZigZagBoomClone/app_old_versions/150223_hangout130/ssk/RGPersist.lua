-- =============================================================
-- Copyright Roaming Gamer, LLC. 2009-2015
-- =============================================================
-- 
-- =============================================================
local persist = {}
if( not _G.ssk ) then
	_G.ssk = {}
end
_G.ssk.persist = persist

local fileCache = {}

persist.get = function( fileName, fieldName, params )
	params		= params or {}
	local record = fileCache[fileName] 
	if( not record ) then
		record = table.load( fileName, params.base ) or {}		
		table.save( record, fileName, params.base )
	end
	return record[fieldName]
end

persist.set = function( fileName, fieldName, value, params )
	params		= params or {}
	local save	= (params.save == nil) and true or params.save

	local record = fileCache[fileName] 
	if( not record ) then
		record = table.load( fileName, params.base ) or {}
	end

	record[fieldName] = value

	if(save) then 
		table.save( record, fileName, params.base )
	end
end

return persist