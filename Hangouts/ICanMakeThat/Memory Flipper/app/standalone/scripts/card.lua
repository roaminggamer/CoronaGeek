-- =============================================================
-- Copyright Roaming Gamer, LLC. 2009-2014 
-- =============================================================
-- 
-- =============================================================
local public = {}

----------------------------------------------------------------------
--								REQUIRES							--
----------------------------------------------------------------------

----------------------------------------------------------------------
--								DECLARATIONS						--
----------------------------------------------------------------------
-- Variables


-- Forward Declarations

-- LUA/Corona Localizations
local mRand             = math.random
local getTimer          = system.getTimer
local pairs             = pairs

-- SSK Localizations
local angle2VectorFast 	= ssk.math2d.angle2VectorFast
local addVectorFast 	= ssk.math2d.addFast
local subVectorFast 	= ssk.math2d.subFast
local scaleVectorFast 	= ssk.math2d.scaleFast

----------------------------------------------------------------------
--								DEFINITIONS							--
----------------------------------------------------------------------

--- Flip variations
--
-- Immediate
--
local function flip1( card, skipCB )
	card.image.isVisible = not card.image.isVisible
	card.isFaceUp = not card.isFaceUp
	card.isFlipping = false
	if( not skipCB ) then
		post( "onFlippedCard", { card = card } )
	end
end

-- Transition Pop
--
local function flip2( card, skipCB )

	local onComplete1
	local onComplete2
	
	onComplete1 = function ( self )
		self.image.isVisible = not self.image.isVisible
		transition.to( card, { xScale = 1, yScale = 1, time = 250, onComplete = onComplete2, transition = easing.outCirc } )
	end

	onComplete2 = function ( self )
		self.isFlipping = false
		self.isFaceUp = not self.isFaceUp
		if( not skipCB ) then
			post( "onFlippedCard", { card = self } )
		end
	end

	transition.to( card, { xScale = 0.05, yScale = 0.05, time = 250, onComplete = onComplete1, transition = easing.inCirc } )
end


-- Transition
--
local function flip3( card, skipCB )

	local onComplete1
	local onComplete2
	
	onComplete1 = function ( self )
		self.image.isVisible = not self.image.isVisible
		transition.to( card, { xScale = 1, time = 250, onComplete = onComplete2, transition = easing.outCirc } )
	end

	onComplete2 = function ( self )
		self.isFlipping = false
		self.isFaceUp = not self.isFaceUp
		if( not skipCB ) then
			post( "onFlippedCard", { card = self } )
		end
	end

	transition.to( card, { xScale = 0.05, time = 250, onComplete = onComplete1, transition = easing.inCirc } )
end



-- Create a new card
function public.create( group, x, y, width, height, num, images )	

	-- Use a display group to hold all parts of our card
	--
	local card = display.newGroup()
	group:insert( card )

	-- Position the 'card'
	--
	card.x = x
	card.y = y

	-- Build the layers
	--
	local back = display.newRoundedRect( card, 0, 0, width, height, 8 )
	back:setStrokeColor( 0, 0, 1 )
	back.strokeWidth = 2

	-- Build the image
	--
	local size = (width>height) and height or width
	--size = size * 0.8
	local image = display.newImageRect( card, "images/" .. images .. "/" .. num .. ".png", size, size )
	image.isVisible = false

	-- Initialize card info
	--
	card.num 		= num 
	card.isFlipping = false
	card.isFaceUp  	= false
	card.back 		= back
	card.image 		= image

	-- Attach 'flip' method to card
	-- 
	card.flip = flip3

	-- Add 'touch' handler
	--
	back.touch = function( self, event )	
		-- Ignore touches while flipping and face up
		--
		if( card.isFlipping ) then return true end
		if( card.isFaceUp ) then return true  end

		if(event.phase == "ended" ) then
			card.isFlipping = true
			card:flip()
			post( "onSFX", { sfx = "click" } )
		end
		return true
	end; back:addEventListener("touch")

	return card
end

return public