-- =============================================================
-- Copyright Roaming Gamer, LLC. 2009-2014 
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

local builderFiles = {}
-- Player Start
builderFiles.B = "start"

-- Level Blocks
builderFiles.R = "round"
builderFiles.S = "square"

-- Dangers
builderFiles.X = "spikes"

-- Pickups, Monsters
builderFiles.C = "coins"
builderFiles.M = "monster"


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

	local function convertToLevelRecords( input )
		--table.print_r(input)

		-- Pass 1 - Translate into builder records.  x and y are row and column for now
		--
		local row = 1
		local col = 1
		local centerRow = 1
		local centerCol = 1
		for i = 1, #input do
			local entry = input[i]

			-- Convert symbols to table then massage
			entry = string.split( entry, "_" )			

			local record

			if( entry[1] == "" ) then
				--table.dump(entry)
				-- Do nothing

			else
				table.dump(entry)
				if( entry[1] == "B" ) then
					centerRow = row
					centerCol = col					
				end
				record = { type = builderFiles[entry[1]], subtype = tonumber(entry[2]), x = col, y = row  }
				
			end

			if( record ) then
				level[#level+1] = record
			end

			col = col + 1
			if( col  > common.levelGrid ) then
				col = 1
				row = row +1
			end
		end

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
	local centerRow, centerCol = convertToLevelRecords( require("data.level" .. levelNum ).platforms )

	if( common.loadDangers ) then
		convertToLevelRecords( require("data.level" .. levelNum ).dangers )
	end

	if( common.loadOther ) then
		convertToLevelRecords( require("data.level" .. levelNum ).other )
	end

	finalizeLevel( centerRow, centerCol )

	--table.print_r(level)


	return level 
end


return public