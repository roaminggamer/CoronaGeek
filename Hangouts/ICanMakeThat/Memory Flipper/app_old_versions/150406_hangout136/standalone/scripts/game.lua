-- =============================================================
-- Copyright Roaming Gamer, LLC. 2009-2014 
-- =============================================================
-- 
-- =============================================================
local public = {}

----------------------------------------------------------------------
--								REQUIRES							--
----------------------------------------------------------------------
local cardM 		= require "scripts.card"
local hudsM 		= require "scripts.huds"

----------------------------------------------------------------------
--								DECLARATIONS						--
----------------------------------------------------------------------
-- Variables
local layers
local cards = {}

local duration = 60

local rows = 4 --8
local cols = 3 -- 5	

local cardWidth = w/cols -- 52
local cardHeight = cardWidth

local flipCount = 0
local currentCards = {}

--local images = "coronaCrush" -- 6 images (up to 12 tiles)
--local images = "nicuFlowers" -- 6 images (up to 12 tiles)
--local images = "nicuMonsters" -- 6 images (up to 12 tiles)
local images = "nicuFruit" -- 8 images (up to 16 tiles)
--local images = "lostGarden" -- 16 images (up to 32 tiles)
--local images = "nicuMix" -- 20 images (up to 40 tiles)


-- Forward Declarations
local drawBoard
local onFlippedCard

-- Localizations
local mRand             = math.random
local getTimer          = system.getTimer
local pairs             = pairs

----------------------------------------------------------------------
--								DEFINITIONS							--
----------------------------------------------------------------------
-- Initialize Game
function public.create( parent )	
	parent = parent or display.currentStage

	-- Initialize key game variables
	--
	flipCount = 0
	currentCards = {}	
	cards = {}

	-- Create rendering layers for our game
	--
	layers = ssk.display.quickLayers( parent, "underlay", "content",  "overlay" )		

	-- Create the rest of our game parts.
	--
	drawBoard()	
	hudsM.create( layers, duration )	
end


-- Stop and Destroy The Game
function public.destroy( path )	
	hudsM.destroy( )
	display.remove(layers)
	layers = nil	
end


-- Draw Board
--
drawBoard = function()
	-- Calculate the position of the first card (upper-left)
	--
	local startX = centerX - (cols * cardWidth)/2 + cardWidth/2
	local startY = centerY - (rows * cardHeight)/2 + cardHeight/2 + 20 

	-- Generate a list of card numbers then 'shuffle' it
	local count = 1
	local cardNumbers = {}	
	for i = 1, (rows * cols)/2 do		
		cardNumbers[#cardNumbers+1] = count
		cardNumbers[#cardNumbers+1] = count
		count = count + 1
	end

	-- Randomize (shuffle) the numbers list
	--
	table.shuffle( cardNumbers, 100 )
	
	-- Create and lay out the cards 
	--
	local count = 1
	for i = 1, cols do
		for j = 1, rows do				
			local card = cardM.create( layers.content, 
				                       startX + (i-1) * cardWidth, 
						               startY + (j-1) * cardHeight, 
				                       cardWidth - 6, cardHeight - 6, 
				                       cardNumbers[count],
				                       images )
			cards[card] = card	
			count = count+1
		end
	end

	post("onStartTimer", { duration = 60 } )
end


-- Listen For Card Flips - onFlippedCard()
--
onFlippedCard = function(event)	
	flipCount = flipCount + 1
	currentCards[flipCount] = event.card

	if( flipCount > 1 ) then
		-- Same image?
		--
		if( currentCards[1].num == currentCards[2].num ) then
			-- Yes!
			--
			transition.to( currentCards[1], { xScale = 0.05, yScale = 0.05, alpha = 0,
				                              time = 250, delay = 500, onComplete = display.remove } )
			transition.to( currentCards[2], { xScale = 0.05, yScale = 0.05, alpha = 0,
				                              time = 250, delay = 500, onComplete = display.remove } )

			-- Remove cards from our tracking list
			--
			cards[currentCards[1]] = nil
			cards[currentCards[2]] = nil

			post("onScore")

			if( table.count(cards) == 0 ) then
				post("onGameOver")
			end
		else
			-- Nope.
			--
			local card1 = currentCards[1]
			local card2 = currentCards[2]

			timer.performWithDelay( 500, 
				function()
					-- Since we waited, do simple check to be sure
					-- the objects are still valid (not already removed).
					--
					if( not card1 or card1.removeSelf == nil or
					    not card2 or card2.removeSelf == nil ) then 
					    print("One of the cards was removed before it was time to flip.")
					    return
					end

					card1:flip(true)
					card2:flip(true)					
				end )
		end
		currentCards = {}
		flipCount = 0
	end	
end
listen( "onFlippedCard", onFlippedCard )

-- Handle Game Over Event
--
local function onGameOver( event )
	hudsM.destroy(true)

	-- For now, create a touch blocker to stop play
	local tmp = display.newRect( layers.overlay, centerX, centerY, fullw, fullh )
	tmp.isHitTestable = true
	tmp.alpha = 0.5
	
	-- Win or lose?
	--
	if( table.count(cards) == 0 ) then
		tmp:setFillColor(0,1,0)
		post( "onSFX", { sfx = "win" } )
	
	else
		tmp:setFillColor(1,0,0)
		post( "onSFX", { sfx = "lose" } )
	end
	
	-- Block all touches
	--
	tmp.touch = function() return true end
	tmp:addEventListener( "touch" )
end
listen( "onGameOver", onGameOver )



return public