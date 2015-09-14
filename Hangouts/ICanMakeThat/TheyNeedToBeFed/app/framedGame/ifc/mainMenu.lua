-- =============================================================
-- Your Copyright Statement Here, YYYY-YYYY
-- =============================================================
-- Main Menu
-- =============================================================
local composer 		= require( "composer" )
local scene    		= composer.newScene()
local common 		= require "scripts.common"
----------------------------------------------------------------------
--								LOCALS								--
----------------------------------------------------------------------
-- Variables
local isFirstRun = true

-- Forward Declarations
local onPlay
local onOptions

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

----------------------------------------------------------------------
----------------------------------------------------------------------
function scene:create( event )
	local sceneGroup = self.view

	-- Create a simple background
	local back = display.newRect( sceneGroup, centerX, centerY, 570*2, 380*2 )
	back:setFillColor( 0.2, 0.6, 1 )

	local menuGroup = display.newGroup()
	sceneGroup:insert(menuGroup)

	-- Create a label showing which scene this is
	local label = display.newText( menuGroup, "Monsters Need Coins !!!", centerX, centerY - 260, "Harrowprint", 50 )
	label.x = label.x-1
	label.y = label.y-1
	local label = display.newText( menuGroup, "Monsters Need Coins !!!", centerX, centerY - 260, "Harrowprint", 50 )
	label:setFillColor( 0xff/255, 0x59/255, 0x1c/255 )
	label.x = label.x+1
	label.y = label.y+1
	local label = display.newText( menuGroup, "Monsters Need Coins !!!", centerX, centerY - 260, "Harrowprint", 50 )
	label:setFillColor( 0xfd/255, 0xe5/255, 0 )


	-- Create some buttons for navigation
	local levels 		= 32
	local maxLevels		= common.maxLevels
	local buttonWidth 	= 100
	local buttonHeight 	= 100
	local buttonSep 	= 10
	local startX 		= centerX - 350
	local startY 		= centerY - 160
	local curX   		= startX
	local curY   		= startY
	local buttonsPerRow = 8

	for i = 1, levels do
		local cb = onPlay
		local alpha = 1
		if( i > maxLevels ) then 
			cb = nil
			alpha = 0.2
		end
		local selFill 		= { 0xfd/255, 0xe5/255, 0, alpha}
		local unselFill 	= { 0xfd/255, 0xe5/255, 0, alpha}
		local selStroke 	= {1,1,1, alpha}
		local unselStroke 	= {0.2,0.2,0.2, alpha}
		if( i > maxLevels ) then 
			selFill = unselFill
			selStroke = unselStroke
		end		
		
		local tmp = PushButton( menuGroup, curX, curY, i, cb, 
								{ labelSize 	= 42, width = buttonWidth-buttonSep, height = buttonHeight-buttonSep,
								  labelColor 	= {0x01/255, 0x0f/255, 0x2a/255, alpha}, 
								  selFill 		= selFill, 
								  unselFill 	= unselFill, 
								  selStroke 	= selStroke,
								  unselStroke 	= unselStroke,
								  labelFont 	= "Harrowprint"  } )
		tmp.level = i
		curX = curX + buttonWidth		
		if( i % buttonsPerRow == 0 ) then
			curY = curY + buttonHeight
			curX = startX
		end
	end

	local optionsButton = PushButton( menuGroup, centerX, bottom - buttonHeight/2 - buttonSep, "Options", onOptions, 
	                          { labelSize 	= 42, width = 300, height = buttonHeight - buttonSep,
	                            labelColor 	= {0x01/255, 0x0f/255, 0x2a/255}, 
								unselFill 	= { 0.4,0.4,0.4}, 
								unselFill 	= { 0.3,0.3,0.3}, 
								selStroke 	= {1,1,1},
							    unselStroke = {0.2,0.2,0.2},
								labelFont 	= "Harrowprint"  } )

end

----------------------------------------------------------------------
----------------------------------------------------------------------
function scene:willEnter( event )
end
----------------------------------------------------------------------
----------------------------------------------------------------------
function scene:didEnter( event )
end

----------------------------------------------------------------------
----------------------------------------------------------------------
function scene:willExit( event )
end
----------------------------------------------------------------------
----------------------------------------------------------------------
function scene:didExit( event )
end

----------------------------------------------------------------------
----------------------------------------------------------------------
function scene:destroy( event )
end

----------------------------------------------------------------------
--				FUNCTION/CALLBACK DEFINITIONS						--
----------------------------------------------------------------------
onPlay = function ( self, event ) 
	print("Play ", self.level )
	local options = { effect = "slideLeft",  time = 500, params = { level = self.level } }
	composer.gotoScene( "ifc.playGUI", options  )
	return true
end

onOptions = function ( self, event ) 
	local options = { isModal = true, effect = "fromTop", time = 500 }
	composer.showOverlay( "ifc.optionsOverlay", options  )	
	return true
end

---------------------------------------------------------------------------------
-- Scene Dispatch Events, Etc. - Generally Do Not Touch Below This Line
---------------------------------------------------------------------------------
function scene:show( event )
	local sceneGroup 	= self.view
	local willDid 	= event.phase
	if( willDid == "will" ) then
		self:willEnter( event )
	elseif( willDid == "did" ) then
		self:didEnter( event )
	end
end
function scene:hide( event )
	local sceneGroup 	= self.view
	local willDid 	= event.phase
	if( willDid == "will" ) then
		self:willExit( event )
	elseif( willDid == "did" ) then
		self:didExit( event )
	end
end
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )
---------------------------------------------------------------------------------
return scene
