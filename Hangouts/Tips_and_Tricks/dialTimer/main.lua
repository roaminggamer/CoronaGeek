-- =============================================================
-- main.lua
-- =============================================================
io.output():setvbuf("no") 
display.setStatusBar(display.HiddenStatusBar)  

local common = require "common"

local function createDial( group, x, y, params  )

	group = group or display.currentStage
	params = params or {}

	local size 		= params.size or 128	

	local backImg 	= params.backImg or "images/back.png"
	local backSize 	= params.backSize or 128
	local backFill 	= params.backFill or {1,1,1}

	local dialImg 	= params.dialImg or "images/halfdial.png"
	local dialSize 	= params.dialSize or 128
	local dialFill 	= params.dialFill or {0xC0, 0x40, 0x00}
	local dialAlpha	= params.dialAlpha or 0.5

	local borderImg 	= params.borderImg or "images/halfborder.png"
	local borderSize 	= params.borderSize or 128
	local borderFill 	= params.borderFill or {1,1,1}

	local dial = display.newGroup()
	group:insert(dial)
	dial.x = x or common.centerX
	dial.y = y or common.centerY

	dial.back = display.newImageRect( dial, backImg, backSize, backSize )
	dial.back:setFillColor(unpack(backFill))

	dial.left = display.newGroup()
	dial:insert( dial.left )
	dial.left.halfdial = display.newGroup()
	dial.left:insert( dial.left.halfdial )
	dial.left.dial = display.newImageRect( dial.left.halfdial, dialImg, dialSize, dialSize )
	dial.left.dial:setFillColor(unpack(dialFill))
	dial.left.dial.alpha = dialAlpha
	dial.left.border = display.newImageRect( dial.left.halfdial, borderImg, borderSize, borderSize )
	dial.left.border:setFillColor(unpack(borderFill))
	display.setDefault('magTextureFilter', 'nearest')
	dial.left.mask = graphics.newMask( "images/halfmask.png" )
	dial.left:setMask( dial.left.mask )
	--dial.left.isVisible = false
	display.setDefault('magTextureFilter', 'linear')

	dial.right = display.newGroup()
	dial:insert( dial.right )
	dial.right.halfdial = display.newGroup()
	dial.right:insert( dial.right.halfdial )
	dial.right.dial = display.newImageRect( dial.right.halfdial, dialImg, dialSize, dialSize )
	dial.right.dial:setFillColor(unpack(dialFill))
	dial.right.dial.alpha = dialAlpha
	dial.right.border = display.newImageRect( dial.right.halfdial, borderImg, borderSize, borderSize )
	dial.right.border:setFillColor(unpack(borderFill))
	display.setDefault('magTextureFilter', 'nearest')
	dial.right.mask = graphics.newMask( "images/halfmask.png" )
	dial.right:setMask( dial.right.mask )
	dial.right.maskScaleX = -1
	--dial.right.isVisible = false
	display.setDefault('magTextureFilter', 'linear')

	dial.left.halfdial.rotation = 180
	dial.right.halfdial.rotation = 0

	dial.percent = 0

	function dial.setPercent( self, percent )
		percent = percent or 0
		percent = (percent > 100) and 100 or percent
		percent = (percent < 0) and 0 or percent
		self.percent = percent

		dial.left.halfdial.rotation = 180
		dial.right.halfdial.rotation = 0

		if( percent <= 50 ) then			
			dial.right.halfdial.rotation = 360 * (percent/100)

			dial.left.halfdial.rotation = 180
		
		elseif( percent > 50 ) then
			dial.right.halfdial.rotation = 180

			dial.left.halfdial.rotation = 180 + 180 * ((percent-50)/50)			
		end

	end

	function dial.getPercent( self )
		return self.percent
	end

	--display.setDefault('magTextureFilter', 'linear')

	dial:scale( size/128, size/128 )

	return dial
end


-- Example Usage 1
--
for i = 1, 6 do
	local size = common.w/6
	local dial = createDial( nil, i * size - size/2 , 100, { size = 50 } )	
	dial:setPercent( (i-1) * 20 )
	local tmp = display.newText( (i-1) * 20 .. "%", dial.x, dial.y + size/2 + 10 )
end

-- Example Usage 2
--
local dial = createDial( nil, common.centerX, common.centerY, 
	                    { backFill = {0,1,0}, backSize = 118,
	                      dialImg = "images/halfdial2.png", dialFill = {1,0,0}, dialAlpha = 1, 
	                      borderFill = {0,0,1} } )
dial.enterFrame = function( self )
	local percent = self:getPercent()
	percent = percent + 0.5
	if( percent > 100 ) then
		percent = 0
	end
	self:setPercent( percent )
end

Runtime:addEventListener( "enterFrame",  dial )

-- Example Usage 3
--
local dial = createDial( nil, common.centerX, common.centerY + 128, 
	                    { backImg = "images/coronasdklogo.png", backSize = 116,
	                      borderFill = {0,0,0,0}, dialSize = 117 } )
dial.enterFrame = function( self )
	local percent = self:getPercent()
	percent = percent + 0.5
	if( percent > 100 ) then
		percent = 0
	end
	self:setPercent( percent )
end

Runtime:addEventListener( "enterFrame",  dial )
