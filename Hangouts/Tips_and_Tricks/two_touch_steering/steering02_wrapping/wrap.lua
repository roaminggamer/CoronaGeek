
-- ===============================================
-- ==          Caclulate Wrap Point
-- ===============================================
function math.calculateWrapPoint( objectToWrap, wrapRectangle )
	local right = wrapRectangle.x + wrapRectangle.contentWidth / 2
	local left  = wrapRectangle.x - wrapRectangle.contentWidth / 2

	local top = wrapRectangle.y - wrapRectangle.contentHeight / 2
	local bot  = wrapRectangle.y + wrapRectangle.contentHeight / 2

	if(objectToWrap.x >= right) then
		objectToWrap.x = left
	elseif(objectToWrap.x <= left) then 
		objectToWrap.x = right
	end

	if(objectToWrap.y >= bot) then
		objectToWrap.y = top
	elseif(objectToWrap.y <= top) then 
		objectToWrap.y = bot
	end
end
