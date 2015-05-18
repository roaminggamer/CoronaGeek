-- =============================================================
-- Copyright Roaming Gamer, LLC. 2009-2015
-- =============================================================
--                              License
-- =============================================================
--[[
    > This example is free to use.
    > This example is free to edit.
    > This example is free to use as the basis for a free or commercial game.
    > This example is free to use as the basis for a free or commercial non-game app.
    > This example is free to use without crediting the author (credits are still appreciated).
    > This example is NOT free to sell as a tutorial, or example of making jig saw puzzles.
    > This example is NOT free to credit yourself with.
]]
-- =============================================================
local editor = {}

local physics 		= require "physics"

-- Localizations
local newCircle 	= ssk.display.newCircle
local newRect 		= ssk.display.newRect
local newImageRect 	= ssk.display.newImageRect
local easyIFC   	= ssk.easyIFC
local mRand 		= math.random
local isValid 		= display.isValid
local newAngleLine 	= ssk.display.newAngleLine
local newLine 		= ssk.display.newLine
local subVec 		= ssk.math2d.sub
local lenVec 		= ssk.math2d.length

local mAbs 			= math.abs

-- Locals
--
local lastGame		-- Last game level (group)
local editorGroup 	-- Edit group
local levelGroup	-- Level Group
local editorBack 	-- Editor background
local markers 		-- Editor grid markers

local pieceSize 	= 40
local levelW		= 480
local levelH		= 320
local ox			= -levelW/2 + pieceSize/2
local oy			= -levelH/2 + pieceSize/2
local cols 			= levelW/pieceSize
local rows 			= levelH/pieceSize
local editorScale 	= 0.6
local inverseScale 	= 1/editorScale

-- Forward Declarations
--
local createBumper
local createGoal
local createBall


-- Definitions
--

-- Save Button Listener
--
local function onSave( event )
	local levelTable = {}

	for i = 1, #markers do
		local marker = markers[i]
		if(marker._data.obj) then
			local element = {}
			levelTable[#levelTable+1] = element
			element.pieceType = marker._data.obj.pieceType
			element.x = marker._data.obj.x
			element.y = marker._data.obj.y
			element.rotation = marker._data.obj.rotation
		end
	end
	table.save( levelTable, "myLevel.json")

end

-- Edit Button Listener
--
local function onEdit( event )
	display.remove(lastGame)
	editor.run()
	display.remove( event.target )
end

-- Test Button Listener
--
local function onTest( event )
	-- Always save first
	--
	onSave()

	-- Destroy the editor
	--
	display.remove( editorGroup )

	-- Run the level
	--
	local game = require "game"
	lastGame = game.run( "myLevel.json" )

	-- Create a button to get back to editor
	--
	easyIFC:presetPush( nil, "default", left + 15, top + 5, 30, 10, "Edit", onEdit, { labelSize = 8 } )

end

-- Loads an existing level from file and re-builds it.
--
local function restoreLevel()
	local levelTable = table.load( "myLevel.json" )
	if( not levelTable ) then return end
	for i = 1, #levelTable do
		local element = levelTable[i]
		local tx = element.x
		local ty = element.y
		local piece 
		if( element.pieceType == "bumper1") then
			piece = createBumper(tx,ty,false)
		elseif( element.pieceType == "bumper2") then
			piece = createBumper(tx,ty,true)
		elseif( element.pieceType == "goal") then
			piece = createGoal(tx,ty)
		elseif( element.pieceType == "ball") then
			piece = createBall(tx,ty)
		end
		piece.rotation = element.rotation
	end
end

-- Place dropped object on nearest grid marker, or if
-- too far from a grid marker (off editor), delete it.
--
-- If placing on a grid marker that has an object, delete 
-- current object.
--
local function placeObj( obj )

	-- Locate nearest grid-point
	--
	local maxDist = math.huge
	local nearest = 1
	for i = 1, #markers do
		local marker = markers[i]
		local dist = subVec(obj,marker)
		dist = lenVec( dist )
		if( dist < maxDist ) then
			nearest = i
			maxDist = dist
		end
	end

	-- If we are far from the nearest marker destroy object
	-- and exit early.
	--
	if( maxDist > pieceSize ) then
		if( obj._data ) then
			obj._data.obj = nil
		end
		display.remove( obj )
		return 
	end

	-- Grab the nearest marker
	--
	local marker = markers[nearest]	

	-- Destroy any object already at that position (if not same object)
	--
	if(marker._data.obj ~= obj) then 
		display.remove( marker._data.obj )
		marker._data.obj = obj
		obj._data = marker._data
	end

	-- Snap to the position of the marker
	--
	obj.x = marker.x
	obj.y = marker.y
end

-- Touch Listener for dragging placed piece.
--
local function editDrag( self, event )
	local phase = event.phase
	local id = event.id

	if( phase == "began" ) then
		self.x0 = self.x
		self.y0 = self.y
		self.alpha = 0.5
		display.currentStage:setFocus( self, id )
		self.isFocus = true
	elseif( self.isFocus ) then
		self.x = self.x0 + (event.x - event.xStart) * inverseScale
		self.y = self.y0 + (event.y - event.yStart) * inverseScale
		if( phase == "ended" ) then
			self.alpha = 1
			display.currentStage:setFocus( self, nil )
			self.isFocus = false
			if( self.x == self.x0 and self.y == self.y0 and self.clickAction ) then
				self:clickAction()
			end
			placeObj(self)
		end
	end
	return false
end

-- Function to build new bumper in editor area.
--
createBumper = function ( x, y, canTurn )
	local tmp = newImageRect( levelGroup, x, y, "images/triangle2.png", 
							 { size = bumperSize, touch = editDrag, 
							   pieceType = (canTurn) and "bumper2" or "bumper1",
							   fill = (canTurn) and _P_ or _W_ } ) 
	placeObj( tmp )
	tmp.clickAction = function( self )
		self.rotation = self.rotation + 90
		ssk.misc.normRot(self)
	end
	return tmp
end

-- Function to build new goal in editor area.
--
createGoal = function( x, y )
	local tmp = newImageRect( levelGroup, x, y, "images/circle.png", 
							 { size = bumperSize, touch = editDrag, pieceType = "goal" } ) 
	placeObj( tmp )
	return tmp
end

-- Function to build new ball in editor area.
--
createBall = function( x, y )
	local tmp = newImageRect( levelGroup, x, y, "images/yellow_round2.png", 
							 { size = bumperSize, touch = editDrag, pieceType = "ball" } ) 
	placeObj( tmp )
	
	tmp.clickAction = function( self )
		self.rotation = self.rotation + 90
		ssk.misc.normRot(self)
	end
	return tmp
end


-- Touch Listener for dragging editor buttons in order to create new pieces.
--
local function createDrag( self, event )
	local phase = event.phase
	local id = event.id

	if( phase == "began" ) then
		self.x0 = self.x
		self.y0 = self.y
		self.alpha = 0.5
		self.xScale = editorScale
		self.yScale = editorScale
		display.currentStage:setFocus( self, id )
		self.isFocus = true
	elseif( self.isFocus ) then
		self.x = event.x
		self.y = event.y
		if( phase == "ended" ) then
			self.x = self.x0
			self.y = self.y0
			self.alpha = 1
			self.xScale = 1
			self.yScale = 1
			display.currentStage:setFocus( self, nil )
			self.isFocus = false
			--print(self.pieceType)

			local tx,ty = levelGroup:contentToLocal(event.x,event.y)
			--print(tx,ty)
			if( self.pieceType == "bumper1") then
				createBumper(tx,ty,false)
			elseif( self.pieceType == "bumper2") then
				createBumper(tx,ty,true)
			elseif( self.pieceType == "goal") then
				createGoal(tx,ty)
			elseif( self.pieceType == "ball") then
				createBall(tx,ty)
			end
		end

	end
	return false
end

-- Module entry point
--
function editor.run()
	-- Destroy old edit group and create new one
	display.remove(editorGroup)
	editorGroup = display.newGroup()

	-- Create level group
	levelGroup = display.newGroup()
	editorGroup:insert(levelGroup)
	levelGroup.x = centerX
	levelGroup.y = centerY

	-- Down-scale levelGroup by 40%
	levelGroup:scale( editorScale , editorScale )

	-- Create Background and 'grid'	
	editorBack = newRect( levelGroup, 0, 0, { w = levelW, h = levelH, fill = hexcolor("#111111") } )

	markers = {}
	for col = 1, cols do
		for row = 1, rows do
			local marker = newRect( levelGroup, pieceSize * (col - 1) + ox, pieceSize * (row - 1) + oy, { size = 4 } )
			marker._data = { index = #markers+1 }
			markers[#markers+1] = marker
		end
	end

	-- Editor 'Buttons'
	--
	newImageRect( editorGroup, centerX - 2 * (pieceSize + 10), h - pieceSize , "images/triangle2.png", { size = bumperSize, touch = createDrag, pieceType = "bumper1" } ) 
	newImageRect( editorGroup, centerX - pieceSize - 10, h - pieceSize , "images/triangle2.png", { fill = _P_, size = bumperSize, touch = createDrag, pieceType = "bumper2" } ) 
	newImageRect( editorGroup, centerX, h - pieceSize , "images/circle.png", { size = bumperSize, touch = createDrag, pieceType = "goal" } ) 
	newImageRect( editorGroup, centerX + pieceSize + 10, h - pieceSize , "images/yellow_round.png", { size = bumperSize, touch = createDrag, pieceType = "ball" } ) 
	easyIFC:presetPush( editorGroup, "default", centerX + 110, h - pieceSize, 60, 30, "Save", onSave )
	easyIFC:presetPush( editorGroup, "default", left + 45, top + 20, 80, 30, "Test", onTest )

	restoreLevel()
end

return editor