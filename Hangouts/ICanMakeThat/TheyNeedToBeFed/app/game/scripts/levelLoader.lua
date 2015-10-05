-- =============================================================
-- Copyright Roaming Gamer, LLC. 2009-2015 
-- =============================================================
-- 
-- =============================================================
local public = {}

----------------------------------------------------------------------
--								REQUIRES							--
----------------------------------------------------------------------
local common 		= require "scripts.common"

----------------------------------------------------------------------
--								DECLARATIONS						--
----------------------------------------------------------------------
-- Variables

-- Forward Declarations

-- Localizations
local pairs             = pairs

----------------------------------------------------------------------
--								DEFINITIONS							--
----------------------------------------------------------------------
-- 
-- get() - Converts a level table into one suitable to consumption by the 
--         level builders.
--
function public.get( levelNum )	

	local level = {}

	local levelData = table.load( "data/level" .. levelNum .. ".txt", system.ResourceDirectory )	

	local function convertToLevelRecords( )

		-- Pass 1 - Translate into builder records.  x and y are row and column for now
		--
		local centerRow = 1
		local centerCol = 1

		for i = 1, #levelData do
			local entry = levelData[i]
			table.print_r(entry)

			if( entry.otype == "start" ) then
				centerRow = entry.row
				centerCol = entry.col					
				local buildType = entry.otype
				local record = { type = entry.otype, subtype = tonumber(entry.subtype), x = entry.col, y = entry.row  }
				level[#level+1] = record
			elseif( entry.otype and entry.otype ~= "none" ) then
				local buildType = entry.otype
				local record = { type = entry.otype, subtype = tonumber(entry.subtype), x = entry.col, y = entry.row  }
				level[#level+1] = record
			end

			for i = 1, 4 do
				if( entry.coins[i] ) then
					local record = { type = "coins", subtype = tonumber(i), x = entry.col, y = entry.row  }
					level[#level+1] = record
				end
				if( entry.decoys[i] ) then
					local record = { type = "decoys", subtype = tonumber(i), x = entry.col, y = entry.row  }
					level[#level+1] = record
				end
				if( entry.monster[i] ) then
					local record = { type = "monster", subtype = tonumber(i), x = entry.col, y = entry.row  }
					level[#level+1] = record
				end
			end

		end

		table.print_r( level )

		return centerRow, centerCol
	end

	
	local function finalizeLevel( centerRow, centerCol )

		-- Pass 2 - Now that we have the records and know the starting center, we
		--          need to convert rows and columns into y and x.
		for i = 1, #level do
			--print( i, level[i].x, level[i].y, (level[i].x - centerCol) , (level[i].y - centerRow) )
			level[i].x = (level[i].x - centerCol) * common.gapSize + centerX
			level[i].y = (level[i].y - centerRow) * common.gapSize + centerY 
			             --+ common.startOffsetY
			             + common.blockSize/2 + common.playerSize/2 + common.startOffsetY -- If we don't do this, camera won't be centered
		end


		-- Pass 3 - Finally convert the single 'start' record into two records
		--          #1 original becomes circle record
		--          #2 added to end of list is 'player' record.
		for i = 1, #level do
			if( level[i].type == "start" ) then
				level[i].type = "round"			
				local record = { type = "player", 
				                 x = level[i].x, 
				                 y = level[i].y - common.blockSize/2 - common.playerSize/2 - common.startOffsetY 
				               }
				level[#level+1] = record
			end
		end
	end
	
	--
	-- Place the Platforms
	--	
	local centerRow, centerCol = convertToLevelRecords()

	--if( common.loadDangers ) then
		--convertToLevelRecords( require("data.level" .. levelNum ).dangers )
	--end

	--if( common.loadOther ) then
		--convertToLevelRecords( require("data.level" .. levelNum ).other )
	--end

	finalizeLevel( centerRow, centerCol )

	--table.print_r(level)
	

	return level 
end

-- 
-- countCoins() - Examines level and count all coins.
--
function public.countCoins( levelNum )	

	local coinCount = 0

	local levelData = table.load( "data/level" .. levelNum .. ".txt", system.ResourceDirectory )	

		for i = 1, #levelData do
			local entry = levelData[i]

			for i = 1, 4 do
				if( entry.coins[i] ) then
					coinCount = coinCount + 1
				end
			end

		end

	return coinCount 
end

-- 
-- countDecoys() - Examines level and count all decoys.
--
function public.countDecoys( levelNum )	

	local decoyCount = 0

	local levelData = table.load( "data/level" .. levelNum .. ".txt", system.ResourceDirectory )	

		for i = 1, #levelData do
			local entry = levelData[i]

			for i = 1, 4 do
				if( entry.decoys[i] ) then
					decoyCount = decoyCount + 1
				end
			end

		end

	return decoyCount 

end



return public