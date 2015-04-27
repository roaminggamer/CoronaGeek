-- =============================================================
-- Your Copyright Statement Here, YYYY-YYYY
-- =============================================================
-- Main Menu
-- =============================================================
local composer 		= require( "composer" )
local scene    		= composer.newScene()

----------------------------------------------------------------------
--								LOCALS								--
----------------------------------------------------------------------
-- Variables
local sceneGroup
local w = display.contentWidth
local h = display.contentHeight
local centerX = display.contentCenterX
local centerY = display.contentCenterY

local menuGroup
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
	sceneGroup = self.view

	-- Create a simple background
	local back = display.newRect( sceneGroup, centerX, centerY, 380, 570 )
	back:setFillColor( 0x01/255, 0x0f/255, 0x2a/255)

	menuGroup = display.newGroup()
	sceneGroup:insert(menuGroup)

	-- Create some buttons for navigation
	local boards = {}
	boards[#boards+1] = { images = "coronaCrush", rows = 4, cols = 3, duration = 60 }
	boards[#boards+1] = { images = "nicuFruit", rows = 4, cols = 3, duration = 60 }
	boards[#boards+1] = { images = "nicuFruit", rows = 4, cols = 4, duration = 90 }
	boards[#boards+1] = { images = "nicuFlowers", rows = 4, cols = 3, duration = 60 }
	boards[#boards+1] = { images = "lostGarden", rows = 4, cols = 3, duration = 60 }
	boards[#boards+1] = { images = "lostGarden", rows = 4, cols = 4, duration = 90 }
	boards[#boards+1] = { images = "lostGarden", rows = 4, cols = 4, duration = 90 }
	boards[#boards+1] = { images = "lostGarden", rows = 6, cols = 5, duration = 180 }

	local startY = centerY - (#boards * 40)/2

	for i = 1, #boards do
		local labelText = boards[i].images .. " - <" .. boards[i].rows .. "," .. boards[i].cols .. ">"
		local tmp = PushButton( menuGroup, centerX, startY + (i-1) * 40, labelText, onPlay, 
								{ labelSize = 14, width = 180, height = 32,
								  labelColor = {0x01/255, 0x0f/255, 0x2a/255}, 
								  selFill 	= { 0xfd/255, 0xe5/255, 0}, 
								  unselFill 	= { 0xfd/255, 0xe5/255, 0}, 
								  selStroke 	= {1,1,1},
								  unselStroke = {0,0,0}  } )
		tmp.board = boards[i]
	end

	local optionsButton = PushButton( menuGroup, centerX, centerY + 200, "Options", onOptions, 
	                          { labelSize = 14, width = 180, height = 32,
	                            labelColor = {0x01/255, 0x0f/255, 0x2a/255}, 
								unselFill 	= { 0.4,0.4,0.4}, 
								unselFill 	= { 0.3,0.3,0.3}, 
								selStroke 	= {1,1,1},
							    unselStroke = {0.2,0.2,0.2}  } )

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
	sceneGroup = nil
end

----------------------------------------------------------------------
--				FUNCTION/CALLBACK DEFINITIONS						--
----------------------------------------------------------------------
onPlay = function ( self, event ) 
	post( "onSFX", { sfx = "click" } )
	print("Play ", self.board[1], self.board[2], self.board[3] )
	local options = { effect = "slideLeft",  time = 500, params = { board = self.board } }
	composer.gotoScene( "ifc.playGUI", options  )
	return true
end

onOptions = function ( self, event ) 
	post( "onSFX", { sfx = "click" } )
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
