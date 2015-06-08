-- =============================================================
-- Copyright Roaming Gamer, LLC. 2009-2015
-- =============================================================
-- 								License
-- =============================================================
--[[
	> SSK is free to use.
	> SSK is free to edit.
	> SSK is free to use in a free or commercial game.
	> SSK is free to use in a free or commercial non-game app.
	> SSK is free to use without crediting the author (credits are still appreciated).
	> SSK is free to use without crediting the project (credits are still appreciated).
	> SSK is NOT free to sell for anything.
	> SSK is NOT free to credit yourself with.
]]
-- =============================================================
local rgFiles = {}
_G.ssk = _G.ssk or {}
_G.ssk.rgFiles = rgFiles

local lfs 			= require "lfs"

local resourceRoot = system.pathForFile('main.lua', system.ResourceDirectory)
local documentRoot = system.pathForFile('', system.DocumentsDirectory)
if( not resourceRoot ) then
	resourceRoot = ""
else
	resourceRoot = resourceRoot:sub(1, -9)
end

function rgFiles.getResourceRoot() return resourceRoot end

function rgFiles.isDirectory( path )
	local origPath = path
	path = system.pathForFile( path, system.ResourceDirectory )
	if( path == nil ) then
		path = resourceRoot .. origPath
	end
	if not path then
		return false
	end
	return lfs.attributes( path, "mode" ) == "directory"
end


function rgFiles.getFilesInDirectory( path )
	local origPath = path
	path = system.pathForFile( path, system.ResourceDirectory )
	if( path == nil ) then
		path = resourceRoot .. origPath
	end
	if path then		
		local files = {}		
		for file in lfs.dir( path ) do		
			if file ~= "." and file ~= ".." and file ~= ".DS_Store" then
				files[ #files + 1 ] = file
			end			
		end
		return files		
	end	
end

function rgFiles.findAllFiles( path )
	local tmp = rgFiles.getFilesInDirectory( path )
	local files = {}
	for k,v in pairs( tmp ) do
		files[v] = v
	end

	for k,v in pairs( files ) do
		local newPath =  path and (path .. "/" .. v) or v
		local isDir = rgFiles.isDirectory( newPath )
		if( isDir ) then
			files[v] = rgFiles.findAllFiles( newPath )
		else
		end
	end
	return files
end


function rgFiles.flattenNames( t, sep ) 
	local flatNames = {}
	local function flatten(t,indent,prefix)
		local path 
		if (type(t)=="table") then
			for k,v in pairs(t) do
				if (type(v)=="table") then
					path = (prefix) and (prefix .. indent .. tostring(k)) or tostring(k)
					path = flatten(v,indent,path)					
				else
					path = (prefix) and (prefix .. indent .. tostring(k)) or tostring(k)
					flatNames[path] = path
				end
			end
		else
			path = (prefix) and (prefix .. indent .. tostring(t)) or tostring(t)
			flatNames[path] = path
		end
		return prefix or ""
	end
	if (type(t)=="table") then
		flatten(t,sep)
	else
		flatten(t,sep)
	end
	return flatNames
end

function rgFiles.getLuaFiles( files )
	local luaFiles = rgFiles.flattenNames( files, "." )
	for k,v in pairs(luaFiles) do
		if( string.match( k, "%.lua" ) ) then
			luaFiles[k] = v:gsub( "%.lua", "" )
		else
			luaFiles[k] = nil
		end
	end
	local tmp = luaFiles
	luaFiles = {}
	for k,v in pairs(tmp) do
		luaFiles[v] = v
	end
	return luaFiles
end

function rgFiles.getResourceFiles( files )
	local resourceFiles = rgFiles.flattenNames( files, "/" )
	for k,v in pairs(resourceFiles) do
		if( string.match( k, "%.lua" ) ) then			
			resourceFiles[k] = nil
		end
	end
	local tmp = resourceFiles
	resourceFiles = {}
	for k,v in pairs(tmp) do
		resourceFiles[v] = v
	end
	return resourceFiles
end



function rgFiles.mkdir( dirName )
	local temp_path = system.pathForFile( "", system.DocumentsDirectory )
	local success = lfs.chdir( temp_path ) 
	local new_folder_path
	if success then
		success = lfs.mkdir( dirName )
		new_folder_path = lfs.currentdir() .. "/" .. dirName
	end
	return success
end

function rgFiles.rmdir( dirName )
	local temp_path  = system.pathForFile( dirName , system.DocumentsDirectory )
	if(onWin) then
		command = "rmdir /Q /S " .. '"' .. temp_path .. '"'
	else
		command = "rm -rf " .. '"' .. temp_path .. '"'
	end
	------print( command )
	local retVal =  os.execute( command )
	if( retVal == 0 ) then return true end
	return false
end


function rgFiles.mkdir2( dirName )
	local temp_path = dirName
	local new_folder_path
	success = lfs.mkdir( dirName )
	return success
end

function rgFiles.rmdir2( dirName )
	local temp_path  = dirName
	if(onWin) then
		command = "rmdir /Q /S " .. '"' .. temp_path .. '"'
	else
		command = "rm -rf " .. '"' .. temp_path .. '"'
	end
	------print( command )
	local retVal =  os.execute( command )
	return ( retVal == 0 ) 
end

function rgFiles.copyDocumentToResource( fileName )
	local from = documentRoot
	local to = resourceRoot
	if(onWin) then
		from = from .. "\\"
	else
		from = from .. "/"
		to = to .. "/"
	end

	local command  
	if(onWin) then
		command = "copy /Y " .. '"' .. from .. fileName  .. '" "' .. to .. fileName .. '"'
	else
		command = "cp " .. '"' .. from .. fileName  .. '" "' .. to .. fileName .. '"'
	end
	print(command)
	local retVal =  os.execute( command )
	return ( retVal == 0 ) 
end


function rgFiles.cdhome( )
	local temp_path = system.pathForFile( "", system.ResourcesDirectory )
	local success = lfs.chdir( temp_path ) -- returns true on success
	return success
end

return rgFiles