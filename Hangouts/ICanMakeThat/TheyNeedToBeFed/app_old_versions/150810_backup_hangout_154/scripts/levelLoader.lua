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

-- Table of all level layouts
-- Note: For this demo, levels are only 8 x 8 
local levelLayouts = {}
levelLayouts[1] = require "data.level1"

print("level Layout 1", #levelLayouts[1])

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
	local levelLayout = levelLayouts[levelNum]

	local level = {}

	-- Pass 1 - Translate into builder records.  x and y are row and column for now
	--
	local row = 1
	local col = 1
	local centerRow = 1
	local centerCol = 1
	for i = 1, #levelLayout do
		local entry = levelLayout[i]

		local record

		if( entry == "empty" ) then
			-- Do nothing

		else
			if( string.match( entry, "start" ) ) then
				centerRow = row
				centerCol = col
			end

			record = { type = entry, x = col, y = row, rotation = 0 }
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

	-- Pass 2 - Now that we have the records and know the starting center, we
	--          need to convert rows and columns into y and x.
	for i = 1, #level do
		print( i, level[i].x, level[i].y, (level[i].x - centerCol) , (level[i].y - centerRow) )
		level[i].x = (level[i].x - centerCol) * common.gapSize + centerX
		level[i].y = (level[i].y - centerRow) * common.gapSize + centerY 
		             --+ common.startOffsetY
		             + common.blockSize/2 + common.playerSize/2 + common.startOffsetY -- If we don't do this, camera won't be centered
	end


	-- Pass 3 - Finally convert the single 'start' record into two records
	--          #1 original becomes circle1 record
	--          #2 added to end of list is 'player' record.
	for i = 1, #level do
		if( level[i].type == "start" ) then
			level[i].type = "circle1"			
			local record = { type = "player", 
			                 x = level[i].x, 
			                 y = level[i].y - common.blockSize/2 - common.playerSize/2 - common.startOffsetY, 
			                 rotation = 0 }
			level[#level+1] = record
		end
	end

	table.print_r(level)

	return level 
end


return public