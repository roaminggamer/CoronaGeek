-- =============================================================
-- Copyright Roaming Gamer, LLC. 2009-2015
-- =============================================================
-- WIP
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
local intersectFixer = {}
_G.ssk.intersectFixer = intersectFixer

-- convert flat list of x1,y1, ..., xN, yN vertex pairs
-- into points list: { { x1, y1}, ... { xN, yN } }
--
intersectFixer.toPointList = function( list )
	local points = {}
	for i = 1, #list, 2 do
		points[#points+1] = {}
		points[#points][1] = list[i]
		points[#points][2] = list[i+1]
	end	
	return points
end

-- convert points list: { { x1, y1}, ... { xN, yN } } into
-- flat list of x1,y1, ..., xN, yN vertex pairs
--
intersectFixer.toFlat = function( list )
	local flat = {}
	for i = 1, #list do
		flat[#flat+1] = list[i][1]
		flat[#flat+1] = list[i][2]
	end
	return flat
end

intersectFixer.removeCrossing = function( list )
	local points = intersectFixer.toPointList( list )
	--table.dump(points)

	local crossedAt = 0
	for i = 2, #points - 2 do
	   for j = i + 1 , #points - 1 do
	   		local a1 = i-1
	   		local a2 = i
	   		local b1 = j	   		
	   		local b2 = j + 1
	   		local didIntersect = intersectFixer.lines(points[a1],points[a2],points[b1],points[b2])
	   		print( a1.. ", " .. a2 .." : " .. b1 .. ", " .. b2, didIntersect )
	      if( crossedAt == 0 and didIntersect ) then
	      	crossedAt = j
         end
	   end
	end
	-- Remove points if needed	
	crossedAt = crossedAt or #points
	crossedAt = (crossedAt > 0) and crossedAt or #points

	if( crossedAt == #points ) then
		print("No crossing occured.\n")
	else
		print("Crossed at " .. crossedAt .. "\n")
	end
	
	local points2 = {}
	for i = 1, crossedAt do
		points2[i] = points[i]
	end

	-- convert back to flat list and return
	local flat = intersectFixer.toFlat( points2 )
	return flat
end


intersectFixer.lines =  function ( a1, a2, b1, b2 ) 
    -- Derived from this code: http://pastebin.com/JH7rWWPY
    local x1, y1, x2, y2, x3, y3, x4, y4

    x1 = a1.x or a1[1]
    y1 = a1.y or a1[2]
    x2 = a2.x or a2[1]
    y2 = a2.y or a2[2]
    x3 = b1.x or b1[1]
    y3 = b1.y or b1[2]
    x4 = b2.x or b2[1]
    y4 = b2.y or b2[2]

    d = (y4-y3)*(x2-x1)-(x4-x3)*(y2-y1)
    Ua_n = ((x4-x3)*(y1-y3)-(y4-y3)*(x1-x3))
    Ub_n = ((x2-x1)*(y1-y3)-(y2-y1)*(x1-x3))
    
    if d == 0 then
        if Ua_n == 0 and Ua_n == Ub_n then
            return true
        end
        return false
    end
    
    Ua = Ua_n / d
    Ub = Ub_n / d
    
    if Ua >= 0 and Ua <= 1 and Ub >= 0 and Ub <= 1 then    
    	print(Ua,Ub,Ua_n,Ub_n)
        return true
    end
    
    return false
end


return intersectFixer