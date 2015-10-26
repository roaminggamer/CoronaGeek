local zombieMaker = {}

local info 	= require "images.reiners.redzombie"
local sheet 	= info:getSheet()
local imageSheet 	=  graphics.newImageSheet("images/reiners/redzombie.png", sheet )

local seqData = {}

local function generateSequence( seqData, name, dir, loops )
	--print("Generate sequence for anim: " .. name .. " dir: " .. dir )
	local newSeq =  {}
	newSeq.name = name .. "_" .. dir
	newSeq.time = 1000
	newSeq.loopCount = loops or 0
	newSeq.loopDirection = "forward"	
	local frames = {}
	newSeq.frames = frames
	for i = 1, 8 do
		local indexName = string.format( "%s %s000%d", name, dir, i-1 )
		local index = info:getFrameIndex( indexName ) or 0
		if( index == 0 ) then
			print("Error generating sequence for anim: " .. name .. " dir: " .. dir, indexName )
		end

		frames[i] = index
	end
	--table.print_r( newSeq )
	seqData[#seqData+1] = newSeq
end

local anims =  { "walking", "disintegrate", "attack", "been hit" }
local dirs = { "n", "s", "e", "w", "ne", "se", "nw", "sw" }
--local anims =  { "walking" }
--local dirs = { "n" }
for i = 1, #anims do
	for j = 1, #dirs do
		if( anims[i] == "disintegrate" or anims[i] == "been hit" ) then
			generateSequence( seqData, anims[i], dirs[j], 1 )
		else
			generateSequence( seqData, anims[i], dirs[j] )
		end
	end
end


--table.print_r( seqData )

function zombieMaker.angleToDir( angle )
	local split = 45/2
	if( angle < 45 - split ) then
		return "n"
	elseif(  angle < 90 - split ) then
		return "ne"
	elseif(  angle < 135 - split ) then
		return "e"
	elseif(  angle < 180 - split ) then
		return "se"
	elseif( angle < 225 - split ) then
		return "s"
	elseif( angle < 270 - split ) then
		return "sw"
	elseif(  angle < 315 - split ) then
		return "w"
	elseif( angle < 360 - split ) then
		return "nw"
	else
		return "n"
	end
end

function zombieMaker.create( group, x, y, scale )
	local tmp = display.newSprite( imageSheet, seqData )
	tmp.x = x
	tmp.y = y
	group:insert( tmp )
	tmp:play()

	tmp:scale(scale,scale)

	function tmp.playAngleAnim( self, name, angle )		
		local dir = zombieMaker.angleToDir( angle )
		local newName = name .. "_" .. dir
		print("playAngleAnim() ", angle, dir, newName )
		if( self.sequence ~= newName ) then
			self:setSequence( newName )
			self:play()
		end
	end

	return tmp
end

--table.print_r( sheet.frames )
--local frameIndex 	= info.frameIndex
--table.dump( frameIndex )


--[[

local pinkyInfo 	= require "pinky"
local pinkySheet 	= graphics.newImageSheet("pinky.png", pinkyInfo:getSheet() )
local seqData = 
	{
		{ name = "idle", frames = {2}, time = 1000, loopCount = 0, loopDirection = "forward"}, 
		{ name = "jump", frames = {1}, time = 1000, loopCount = 0, loopDirection = "forward"}, 
		{name = "rightwalk", frames = {3,4,5,6,7,8,9,10,11,12,13 }, time = 500, loopCount = 0, loopDirection = "forward"}, 
		{name = "leftwalk", frames = {3,4,5,6,7,8,9,10,11,12,13 }, time = 500, loopCount = 0, loopDirection = "forward"}, 
	}

]]

return zombieMaker