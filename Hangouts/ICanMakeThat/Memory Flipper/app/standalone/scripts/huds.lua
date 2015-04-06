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
local layers
local scoreLabel
local timerLabel

-- Forward Declarations

-- LUA/Corona Localizations
local mRand             = math.random
local getTimer          = system.getTimer
local pairs             = pairs

----------------------------------------------------------------------
--								DEFINITIONS							--
----------------------------------------------------------------------
-- Create HUDs
function public.create( parent, duration  )	
	layers = parent

	-- Create simple HUD background for legibility
	--
	local back = display.newRect( layers.overlay, centerX, top + 22, fullw-4, 40 )
	back:setFillColor( 0,0,0,0)
	back:setStrokeColor( 1,1,1 )
	back.strokeWidth = 1


	-- Create simple Score Label
	--
	local msgPrefix = "Matches: "
	scoreLabel = display.newText( layers.overlay, msgPrefix .. "0", fullw - 10, back.y, native.systemFont, 20 )
	scoreLabel.anchorX = 1
	scoreLabel.currentScore = 0	
	-- Add a custom 'onScore' event listener
	--
	scoreLabel.onScore = function( self, event )
		scoreLabel.currentScore = scoreLabel.currentScore + 1
		self.text = msgPrefix .. scoreLabel.currentScore
	end
	-- Start listening
	--
	listen( "onScore", scoreLabel )



	-- Create simple timer Label
	--
	local msgPrefix = "Remaining Time: "
	timerLabel = display.newText( layers.overlay, msgPrefix .. duration, 10, back.y, native.systemFont, 20 )
	timerLabel.anchorX = 0
	timerLabel.remainingTime = 0
	timerLabel.remainingTime = duration

	-- Add a 'timer' method to be called by performWithDelay
	--
	timerLabel.timer = function( self )
		-- Decrement count
		--
		self.remainingTime = self.remainingTime - 1
		self.text = msgPrefix .. self.remainingTime
		
		-- Check count.  If 0, game over...
		-- 
		if( self.remainingTime == 0 ) then
			post("onGameOver")
			return
		end

		-- Tick again in 1 second
		self.lastTimer = timer.performWithDelay(1000, self )
	end

	-- Start counting
	--
	timerLabel.lastTimer = timer.performWithDelay( 1000, timerLabel )
end


-- Destroy HUDS
-- If stopOnly is true, only stop the timer.
function public.destroy( stopOnly )	
	-- Cancel the timer if running
	--
	if( timerLabel.lastTimer ) then
		timer.cancel( timerLabel.lastTimer )
		timerLabel.lastTimer = nil
	end

	-- Are we only stopping the timer? If so, exit early
	--
	if( stopOnly ) then 
		return
	end

	-- Stop listening for 'onScore' 
	--	
	ignore( "onScore", scoreLabel )


	-- Destroy the labels
	--
	display.remove( scoreLabel )
	display.remove( timerLabel )
	
	-- Clear local references to objects
	--
	scoreLabel = nil
	timerLabel = nil
	layers = nil
end

return public