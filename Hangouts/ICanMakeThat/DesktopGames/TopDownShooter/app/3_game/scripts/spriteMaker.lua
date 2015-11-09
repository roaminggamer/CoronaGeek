-- =============================================================
-- Copyright Roaming Gamer, LLC. 2009-2015 
-- =============================================================
-- This content produced for Corona Geek Hangouts audience.
-- You may use any and all contents in this example to make a game or app.
-- =============================================================
local public = {}

function public.generateSequence( seqData, name, dir, info, details )
	--print("Generate sequence for anim: " .. name .. " dir: " .. dir )
	local newSeq = {}

	newSeq.name 			= name .. "_" .. dir
	newSeq.time 			= details.time
	newSeq.loopCount 		= details.loops
	newSeq.loopDirection 	= details.direction or "forward"	
	
	local frames = {}
	newSeq.frames = frames
	
	for i = 1, details.frames do
		local indexName = string.format( "%s %s%04.4d", name, dir, i-1 )
		local index = info:getFrameIndex( indexName ) or 0
		if( index == 0 ) then
			print("Error generating sequence for anim: " .. name .. " dir: " .. dir, indexName )
		end
		frames[i] = index
	end
	--table.print_r( newSeq )
	seqData[#seqData+1] = newSeq
end

function public.angleToDir( angle )
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

function public.create( group, x, y, scale, imageSheet, seqData )
	local tmp = display.newSprite( imageSheet, seqData )
	tmp.x = x
	tmp.y = y
	group:insert( tmp )
	tmp:play()

	tmp:scale(scale,scale)

	function tmp.playAngleAnim( self, name, angle )		
		local dir = public.angleToDir( angle )
		local newName = name .. "_" .. dir
		--print("playAngleAnim() ", angle, dir, newName )
		if( self.sequence ~= newName ) then
			self:setSequence( newName )
			self:play()
		end
	end

	return tmp
end


return public