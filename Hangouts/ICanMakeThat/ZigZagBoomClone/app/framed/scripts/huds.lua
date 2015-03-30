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
local speedLabel

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
-- Initialize module
function public.init( parent, params )	
	layers = parent
	params = params or {}
	print("Initializing huds module.")

	-- Create simple HUD background for legibility
	--
	local back = display.newRect( layers.overlay, centerX, top + 21, fullw-2, 40 )
	back:setFillColor( 0x01/255, 0x0f/255, 0x2a/255)
	back:setStrokeColor( 0xa8/255, 0xcb/255, 0xde/255 )
	back.strokeWidth = 2
	--back.alpha = 0

	-- Create simple Score Label
	--
	scoreLabel = display.newText( layers.overlay, 0, back.x - fullw/4, back.y, native.systemFont, 20 )

	-- Add a custom 'onScore' event listener
	--
	scoreLabel.onScore = function( self, event )
		self.text = tonumber(self.text) + 1
	end

	-- Start listening
	--
	listen( "onScore", scoreLabel )

	-- Create simple Speed Label
	--
	speedLabel = display.newText( layers.overlay, "Speed: 0", back.x + fullw/5, back.y, native.systemFont, 16 )

	-- Add a custom 'onSpeed' event listener
	--
	speedLabel.onSpeed = function( self, event )
		self.text = "Speed: " .. tostring( event.speed )
	end

	-- Start listening
	--
	listen( "onSpeed", speedLabel )

end


-- Clean up the module (and optionally unload it from memory)
function public.cleanup( path )	
	print("Cleaning up huds module.")	

	-- Stop listening for 'onScore' and 'onSpeed'
	--	
	ignore( "onScore", scoreLabel )
	ignore( "onSpeed", speedLabel )	

	-- Destroy the labels
	--
	display.remove( scoreLabel )
	display.remove( speedLabel )

	-- Clear local references to objects
	--
	scoreLabel = nil
	speedLabel = nil
	layers = nil
end

return public