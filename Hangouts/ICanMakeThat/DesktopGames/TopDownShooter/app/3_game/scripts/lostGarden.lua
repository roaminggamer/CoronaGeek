-- =============================================================
-- Copyright Roaming Gamer, LLC. 2009-2015 
-- =============================================================
-- This content produced for Corona Geek Hangouts audience.
-- You may use any and all contents in this example to make a game or app.
-- =============================================================
local textureNames = { "B000M800", "B000M801", "B000N800", "B000N801", "B000N802", "B000N803", "B000N804", "B000N805", "B000N806", 
                       "B100M800", "B100M801", "B100M802", "B100M803", "B100N801", "B100N802", "B100N803", "B100N804", "B100N805", 
                       "B100N806", "B100N807", "B100N808", "B100N809", "B100S800", "B100S801", "B100S810", "B100S811", "B101S800", 
                       "B101S801", "B101S810", "B101S811", "B102S800", "B102S801", "B102S802", "B102S803", "B102S810", "B102S811", 
                       "B102S812", "B102S813", "B1B0A800", "B1B0B800", "B1B0E800", "B1B0I800", "B1S1A800", "B1S1B800", "B1S1E800", 
                       "B1S1I800", "D000M800", "D000M801", "D000M802", "D000N800", "D000N801", "D000N802", "D000N803", "D0B0A800", 
                       "D0B0B800", "D0B0E800", "D0B0I800", "D0G0A800", "D0G0B800", "D0G0E800", "D0G0I800", "D100M800", "D1B0A800", 
                       "D1B0B800", "D1B0E800", "D1B0I800", "D1S2A800", "D1S2B800", "D1S2E800", "D1S2I800", "D200M800", "D200M801", 
                       "D200M802", "D200M803", "D200M804", "D200M805", "D2G0A800", "D2G0B800", "D2G0E800", "D2G0I800", "D300M800", 
                       "D300M801", "D300M802", "D300M803", "D300M804", "D3D2A800", "D3D2A801", "D3D2B800", "D3D2B801", "D3D2E800", 
                       "D3D2E801", "D3D2I800", "D3D2I801", "G000M800", "G000M801", "G000M802", "G000M803", "G0G0A800", "G0G0A801", 
                       "G0G0B800", "G0G0B801", "G0G0E800", "G0G0E801", "G0G0I800", "G0G0I801", "G0S0A800", "G0S0B800", "G0S0B801", 
                       "G0S0E800", "G0S0I800", "G100M800", "G1G0A800", "G1G0B800", "G1G0E800", "G1G0I800", "G200M800", "G200M801", 
                       "G200M803", "G2G0A800", "G2G0B800", "G2G0E800", "G2G0I800", "G300M800", "G3G0A800", "G3G0B800", "G3G0E800", 
                       "G3G0I800", "P000M800", "P000M801", "P000M802", "P000M803", "P000M804", "P000M805", "P000M806", "P000M807", 
                       "P0G0A800", "P0G0B800", "P0G0E800", "P0G0I800", "P100M800", "P100M801", "P100M802", "P100M803", "P100M804", 
                       "P100M805", "P100M806", "P1G0A800", "P1G0A801", "P1G0B800", "P1G0B801", "P1G0E800", "P1G0E801", "P1G0I800", 
                       "P1G0I801", "R000M800", "R0D0A800", "R0D0A801", "R0D0B800", "R0D0B801", "R0D0C800", "R0D0C801", "R0D0E800", 
                       "R0D0E801", "R0D0F800", "R0D0F801", "R0D0I800", "R0D0I801", "R0D0J800", "R0D0J801", "S000M800", "S100M800", 
                       "S200M800", "S200M801", "S200M802", "S200N800", "S200N801", "S200N802", "S200N803", "S200N804", "S2D0A800", 
                       "S2D0A801", "S2D0B800", "S2D0B801", "S2D0E800", "S2D0E801", "S2D0I800", "S2D0I801", "S2S2A800", "S2S2A801", 
                       "S2S2B800", "S2S2B801", "S2S2E800", "S2S2E801", "S2S2I800", "S2S2I801", "S300M800", "S300M802", "S3G0A800", 
                       "S3G0B800", "S3G0E800", "S3G0I800", "S400M800", "S400M801", "S4D0A800", "S4D0A801", "S4D0A802", "S4D0B800", 
                       "S4D0B801", "S4D0B802", "S4D0E800", "S4D0I800", "S4G0A800", "S4G0A801", "S4G0A802", "S4G0B800", "S4G0B801",
                       "S4G0B802", "S4G0E800", "S4G0E801", "S4G0E802", "S4G0I800", "S4G0I801", "S4G0I802", "S4S0A800", "S4S0A801", 
                       "S4S0A810", "S4S0A811", "S4S0B800", "S4S0B801", "S4S0B810", "S4S0B811", "S4S0E800", "S4S0E801", "S4S0E810", 
                       "S4S0E811", "S4S0I800", "S4S0I801", "S4S0I810", "S4S0I811", "S500M800", "S500M801", "S5G0A800", "S5G0A801", 
                       "S5G0B800", "S5G0B801", "S5G0E800", "S5G0E801", "S5G0I800", "S5G0I801" }

local textureList = {}

local groupTypes	= {}
local transitionTos = {}
local tileTypes = {}
local versionTypes = {}
local mods = {}

for i = 1, #textureNames do
	local name = textureNames[i]
	local details = {}
	textureList[#textureList+1] = details
	details.groupType 		= string.sub( name, 1, 2)
	details.transitionTo 	= string.sub( name, 3, 4)
	details.tileType 		= string.sub( name, 5, 5)
	details.versionType 	= string.sub( name, 7, 7)
	details.mod 			= string.sub( name, 8, 8)
	details.path 			= "images/lostGarden/ground/" .. name .. ".png"

	groupTypes[details.groupType] 		= details.groupType
	transitionTos[details.transitionTo]	= details.transitionTo
	tileTypes[details.tileType] 		= details.tileType
	versionTypes[details.versionType]	= details.versionType
	mods[details.mod]					= details.mod
end

local easyGroupTypes = {}
easyGroupTypes["B0"] = "BLOB0"
easyGroupTypes["B1"] = "BLOB1"
easyGroupTypes["D0"] = "DIRT0"
easyGroupTypes["D1"] = "DIRT1"
easyGroupTypes["D2"] = "DIRT2"
easyGroupTypes["D3"] = "DIRT3"
easyGroupTypes["G0"] = "GRASS0"
easyGroupTypes["G1"] = "GRASS1"
easyGroupTypes["G2"] = "GRASS2"
easyGroupTypes["G3"] = "GRASS3"
easyGroupTypes["P0"] = "PLANT0"
easyGroupTypes["P1"] = "PLANT1"
easyGroupTypes["R0"] = "RAMP0"
easyGroupTypes["S0"] = "STONE0"
easyGroupTypes["S1"] = "STONE1"
easyGroupTypes["S2"] = "STONE2"
easyGroupTypes["S3"] = "STONE3"
easyGroupTypes["S4"] = "STONE4"
easyGroupTypes["S5"] = "STONE5"

--table.print_r( textureList )

----[[
--table.dump(groupTypes,nil,"groupTypes")
--table.dump(transitionTos,nil,"transitionTos")
--table.dump(tileTypes,nil,"tileTypes")
--table.dump(versionTypes,nil,"versionTypes")
--table.dump(mods,nil,"mods")
--]]

local public = {}
local private = {}

local curTiles = {}

local normRot		= ssk.misc.normRot

local path = textureList[math.random(1,#textureList)].path

function public.create( group, x, y, size )
	local path = textureList[1].path
	--local path = textureList[math.random(1,#textureList)].path
	local tmp = display.newImageRect( group, path, size, size )
	tmp.x = x
	tmp.y = y
	return tmp
end

local curGroup = {}
function public.selectGroup( groupType )
   curTiles = {}
   curGroup = {}
   for i = 1, #textureList do
      
      --print(string.sub( textureList[i].groupType, 1, 2 ), groupType)
      if( string.sub( textureList[i].groupType, 1, 2 ) == groupType ) then
            if( textureList[i].tileType == "M" ) then
               --table.dump( textureList[i] ) 
               curGroup[#curGroup+1] = textureList[i]
            end            
      end
   end
   --table.print_r( curGroup )
end

function private.tileToLeft( x, y, size )
   local leftOfX = x - size
   for k,v in pairs( curTiles ) do
      if( v.x == leftOfX  ) then
         return v.tileData
      end
   end
end

function private.tileAbove( x, y, size )
   local aboveY = y - size
   for k,v in pairs( curTiles ) do
      if( v.y == aboveY  ) then
         return v.tileData
      end
   end
end

local allTypes = { "A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M" }
local allowedBelow = {}
allowedBelow["A"] = { "C", "J", "K" }
allowedBelow["B"] = { "B", "F", "I" }
allowedBelow["C"] = { "A", "E", "H", "M" }
allowedBelow["D"] = { "D", "G", "L" }
allowedBelow["E"] = { "B", "F", "I" }
allowedBelow["F"] = { "A", "E", "H", "M" }
allowedBelow["G"] = { "A", "E", "H", "M" }
allowedBelow["H"] = { "D", "G", "L" }
allowedBelow["I"] = { "C", "J", "K" }
allowedBelow["J"] = { "B", "F", "I" }
allowedBelow["K"] = { "D", "G", "L" }
allowedBelow["L"] = { "C", "J", "K" }
allowedBelow["M"] = { "A", "E", "H", "M" }

local allowedToRight = {}
allowedToRight["A"] = { "E", "L" }
allowedToRight["B"] = { "D", "G", "H", "M" }
allowedToRight["C"] = { "C", "F", "K" }
allowedToRight["D"] = { "B", "I", "J" }
allowedToRight["E"] = { "D", "G", "H", "M" }
allowedToRight["F"] = { "D", "G", "H", "M" }
allowedToRight["G"] = { "C", "F", "K" }
allowedToRight["H"] = { "E", "L" }
allowedToRight["I"] = { "E", "L" }
allowedToRight["J"] = { "C", "F", "K" }
allowedToRight["K"] = { "D", "G", "L" }
allowedToRight["L"] = { "B", "I", "J" }
allowedToRight["M"] = { "D", "G", "H", "M" }

function private.isInSet( letter, set )
   for i = 1, #set do
      if( set[i] == letter ) then 
         return true
      end
   end
   return false
end


function public.create_new( group, x, y, size )
   
   local subGroup = {} -- Table to contain set of all 'allowed' tiles for this placement round
   
   local tileToLeft = private.tileToLeft( x, y, size )
   local tileAbove = private.tileAbove( x, y, size )      
   if( not tileToLeft and not tileAbove ) then
      --print("A")
      subGroup = curGroup
   
elseif( tileToLeft and tileAbove )  then
   --print("B")
      local leftType = tileToLeft.tileType
      local aboveType = tileAbove.tileType
      local allowedTypes = {}
  
       for i = 1, #allowedToRight[leftType] do
          local curType = allowedToRight[leftType][i]
          if( private.isInSet( curType, allowedBelow[aboveType] ) ) then
             allowedTypes[curType] = curType
          end
      end
      
      for i = 1, #curGroup do
         if( allowedTypes[curGroup[i].tileType] ) then
            subGroup[#subGroup+1] = curGroup[i]
         end
      end

   elseif( tileAbove )  then
      --print("C")
      local aboveType = tileAbove.tileType
      local allowedTypes = {}  
      for k,v in pairs(allowedBelow[aboveType]) do
            allowedTypes[v] = v
      end
      
      for i = 1, #curGroup do
         if( allowedTypes[curGroup[i].tileType] ) then
            subGroup[#subGroup+1] = curGroup[i]
         end
      end
   
   else
      --print("D")
   
      local leftType = tileToLeft.tileType
      local allowedTypes = {}  
       for k,v in pairs(allowedToRight[leftType]) do
            allowedTypes[v] = v
      end
      
      for i = 1, #curGroup do
         if( allowedTypes[curGroup[i].tileType] ) then
            subGroup[#subGroup+1] = curGroup[i]
         end
      end
   end

   --print("Total possible tiles = ", #subGroup, tileToLeft, tileAbove )
   
   --table.print_r(subGroup)
   
	--local path = curGroup[1].path
   --local tileData = curGroup[math.random(1,#curGroup)]
   local tileData = subGroup[math.random(1,#subGroup)]
	local tmp = display.newImageRect( group, tileData.path, size, size )
   tmp.tileData = tileData
   curTiles[tmp] = tmp
	tmp.x = x
	tmp.y = y
	return tmp
end


return public