-- =============================================================
-- Your Copyright Statement Here, YYYY-YYYY
-- =============================================================
-- Play GUI
-- =============================================================
local composer 		= require( "composer" )

----------------------------------------------------------------------
--								LOCALS								--
----------------------------------------------------------------------
-- Variables
local w = display.contentWidth
local h = display.contentHeight
local centerX = display.contentCenterX
local centerY = display.contentCenterY
local left = centerX - display.actualContentWidth/2
local right = centerX + display.actualContentWidth/2
local top = centerY - display.actualContentHeight/2
local bottom = centerY + display.actualContentHeight/2


-- Forward Declarations
local player 
local onGameOver
local gameGroup 
local lastSceneGroup

-- Useful Localizations
local mAbs              = math.abs
local mRand             = math.random
local mDeg              = math.deg
local mRad              = math.rad
local mCos              = math.cos
local mSin              = math.sin
local mAcos             = math.acos
local mAsin             = math.asin
local mSqrt             = math.sqrt
local mCeil             = math.ceil
local mFloor            = math.floor
local mAtan2            = math.atan2
local mPi               = math.pi

local getInfo           = system.getInfo
local getTimer          = system.getTimer
local strMatch          = string.match
local strFormat         = string.format
local pairs             = pairs

----------------------------------------------------------------------
--	Scene Methods
----------------------------------------------------------------------
local game = {}

----------------------------------------------------------------------
----------------------------------------------------------------------
function game.start( )
	if( player ) then
		player:onComplete()
	end
end


----------------------------------------------------------------------
----------------------------------------------------------------------
function game.stop( )
	if( player ) then
		transition.cancel( player )
	end
end


----------------------------------------------------------------------
----------------------------------------------------------------------
function game.destroy( purge )
	game:stop( )
	display.remove( gameGroup )
	gameGroup = nil
	player = nil

	if( purge ) then
		print("PURGING")
		lastSceneGroup = nil
	end
end

----------------------------------------------------------------------
----------------------------------------------------------------------
function game.create( group )
	lastSceneGroup =  lastSceneGroup or group or display.currentStage

	gameGroup = display.newGroup()

	lastSceneGroup:insert( gameGroup )


	-- Create a simple background
	local back = display.newImageRect( gameGroup, "images/protoBack.png", 380, 570 )
	back.x = centerX
	back.y = centerY
	if(w>h) then back.rotation = 90 end

	-- Create a label showing which scene this is
	local label = display.newText( gameGroup, "Play GUI", centerX, 40, native.systemFont, 60 )
	label:setFillColor( 0xCC/255, 1, 1  )



	-- Create a simple background
	player = display.newCircle( gameGroup, centerX, centerY, 20 )
	player:setFillColor( mRand(), mRand(), mRand() )

	player.onComplete = function( self )
		transition.to( self,
			{ x = mRand(left,right), y = mRand(top,bottom), 
			  delay = 1000, time = 3000, onComplete = self } )
	end
	

	-- Create a button
	local push1 = PushButton( gameGroup, centerX, bottom - 30, "Game Over", onGameOver, 
	                          { labelColor = {0.8,0.2,0.2}, labelSize = 18 } )

end




----------------------------------------------------------------------
--				FUNCTION/CALLBACK DEFINITIONS						--
----------------------------------------------------------------------
onGameOver = function ( self, event ) 
	game.stop()

	local options =
	{
		isModal = true, -- Don't let touches leak through
		effect = "fromTop", -- See list here: http://docs.coronalabs.com/daily/api/library/composer/gotoScene.html
		time = 500,
		params =
		{
			arg1 = "value", 
			arg2 = 0
		}
	}
	composer.showOverlay( "ifc.gameOverOverlay", options  )	
	return true
end

return game
