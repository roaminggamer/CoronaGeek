local w = display.contentWidth
local h = display.contentHeight
local centerX = display.contentCenterX
local centerY = display.contentCenterY

local mRand = math.random

local function squareMover( obj, loops, size, time )
	size = size or 100
	time = (time or 1000)/4
	loops = loops or 1

	local corner = 1

	local corners = {}
	corners[1] = { obj.x, obj.y }
	corners[2] = { obj.x, obj.y - size }
	corners[3] = { obj.x + size, obj.y - size }
	corners[4] = { obj.x + size, obj.y }



	local function nextMove( self )		
		if( corner == 1 and loops <= 0 ) then return end
		corner = corner + 1
		if( corner > 4 ) then 
	   	corner = 1 
	   	loops = loops - 1
	   end
	   transition.to( self, { x = corners[corner][1], y = corners[corner][2], time = time, onComplete = nextMove })	   
	end

	nextMove( obj )
end

local tmp = display.newCircle( 150, 150, 10 )
squareMover( tmp )

local tmp2 = display.newCircle( 300, 150, 10 )
squareMover( tmp2, 2 )
