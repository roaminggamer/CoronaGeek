-- =============================================================
-- Copyright Roaming Gamer, LLC. 2009-2015 
-- =============================================================
-- 
-- =============================================================
local public = {}
local private = {}

----------------------------------------------------------------------
--								REQUIRES							--
----------------------------------------------------------------------
local physics 		= require "physics"
local common 		= require "scripts.common"

----------------------------------------------------------------------
--								DECLARATIONS						--
----------------------------------------------------------------------
-- Variables
local savesEnabled  = false
local layers
local gridSize = 60
local pieceSize = 45
local gridPieces = {}
local lastDrop
local dtg
local drawimg = {}

-- Forward Declarations
local firstGrid

-- Localizations
local mRand             = math.random
local getTimer          = system.getTimer
local pairs             = pairs

----------------------------------------------------------------------
--								DEFINITIONS							--
----------------------------------------------------------------------

-- 
-- destroy() - Destroys the current level
--
function public.destroy( )	
	display.remove( layers )
	layers = nil
end

-- 
-- create() - Creates a new level.
--
function public.create(  )	
	public.destroy()

	layers 				= display.newGroup()
	layers.underlay 	= display.newGroup()
	layers.content 		= display.newGroup()
	layers.overlay 		= display.newGroup()
	layers:insert( layers.underlay )
	layers:insert( layers.content )
	layers:insert( layers.overlay )

	local back = display.newRect( layers.underlay, centerX, centerY, fullw, fullh )
	back:setFillColor( 0.2, 0.6, 1 )

	private.drawEditGrid()
	private.drawPieceTray()
	private.drawDetailsTray()

	private.restore()

	savesEnabled = true

	private.refreshDetailTray( firstGrid )
end

----------------------------------------------------------------------
----------------------------------------------------------------------
function private.drawEditGrid()
	local editGrid = display.newGroup()
	layers.content:insert(editGrid)
	
	local startX = -common.levelGrid/2 * gridSize
	local startY = -common.levelGrid/2 * gridSize
	local curX   = startX
	local curY   = startY
	local col 	 = 1
	local row 	 = 1
	for row = 1, common.levelGrid do
		for col = 1, common.levelGrid do
			local grid = display.newRect( editGrid, curX, curY, gridSize-2, gridSize-2 )
			grid:setFillColor(0.2,0.2,0.2,0.5)
			grid:setStrokeColor(1,0,0,0.5)
			grid.strokeWidth = 1
			curX = curX + gridSize

			grid.row = row
			grid.col = col
			grid.parts = {}
			grid.coins = { false, false, false, false }
			grid.decoys = { false, false, false, false }
			grid.spikes = { false, false, false, false }
			grid.monster = { false, false, false, false }
			grid.subtype = 1

			grid.touch = private.editGridTouch
			grid:addEventListener( "touch" )

			grid.refresh = private.refreshGrid

			gridPieces[grid] = grid

			if( not firstGrid ) then 
				firstGrid = grid 
				grid:setStrokeColor(0,1,0)
				grid.xScale = 0.95
				grid.yScale = 0.95
				grid.strokeWidth = 2
			end

		end
		curX = startX
		curY = curY + gridSize
	end

	editGrid.x = common.levelGrid/2 * gridSize + gridSize/2 + 15
	editGrid.y = common.levelGrid/2 * gridSize + gridSize/2 + 15
end

----------------------------------------------------------------------
----------------------------------------------------------------------
function private.drawPieceTray()
	local tray = display.newRoundedRect( layers.overlay, 5, h - 5, w - 10, 130, 12  )
	tray.anchorX = 0
	tray.anchorY = 1
	tray:setFillColor(0.5,0.5,0.5,0.5)
	tray:setStrokeColor(1,1,0,0.5)
	tray.strokeWidth = 2

	-- Create Editor Drag & Drop 'Buttons'
	local row1 = tray.y - (gridSize + 5) * 1.5
	local row2 = row1 + gridSize + 5
	local col1 = tray.x + gridSize/2 + 10
	local function col( num ) return col1 + (num-1) * (gridSize + 10) end


	-- Round Platform
	local button = display.newRect( layers.overlay, col(1), row1, pieceSize, pieceSize )
	button.otype = "none"
	button.touch = private.pieceDragger
	button:addEventListener( "touch" )
	button:setFillColor(1,0,1)

	-- Player (start)
	local button = display.newImageRect( layers.overlay, "images/editor/start.png", pieceSize, pieceSize )
	button.x = col(2)	
	button.y = row1
	button.otype = "start"
	drawimg["start"] = "start"
	button.touch = private.pieceDragger
	button:addEventListener( "touch" )

	-- Round Platform
	local button = display.newImageRect( layers.overlay, "images/editor/round.png", pieceSize, pieceSize )
	button.x = col(3)	
	button.y = row1
	button.otype = "round"
	drawimg["round"] = "round"
	button.touch = private.pieceDragger
	button:addEventListener( "touch" )

	-- Square Platform
	local button = display.newImageRect( layers.overlay, "images/editor/square.png", pieceSize, pieceSize )
	button.x = col(4)
	button.y = row1
	button.otype = "square"
	drawimg["square"] = "square"
	button.touch = private.pieceDragger
	button:addEventListener( "touch" )

	-- Timed Dispearing Round Platform
	local button = display.newImageRect( layers.overlay, "images/editor/timedround.png", pieceSize, pieceSize )
	button.x = col(5)
	button.y = row1
	button.otype = "timedround"
	drawimg["timedround"] = "timedround"
	button.touch = private.pieceDragger
	button:addEventListener( "touch" )

	-- Charles' invisible platform
	local button = display.newImageRect( layers.overlay, "images/editor/charles.png", pieceSize, pieceSize )
	button.x = col(6)
	button.y = row1
	button.otype = "charles"
	drawimg["charles"] = "charles"
	button.touch = private.pieceDragger
	button:addEventListener( "touch" )


	-- Laser Turret
	local button = display.newImageRect( layers.overlay, "images/editor/laserturret.png", pieceSize, pieceSize )
	button.x = col(1)	
	button.y = row2
	button.otype = "laserturret"
	drawimg["laserturret"] = "laserturret"
	button.touch = private.pieceDragger
	button:addEventListener( "touch" )

	-- Rotating Laser Turret
	local button = display.newImageRect( layers.overlay, "images/editor/rotatinglaserturret.png", pieceSize, pieceSize )
	button.x = col(2)	
	button.y = row2
	button.otype = "rotatinglaserturret"
	drawimg["rotatinglaserturret"] = "rotatinglaserturret"
	button.touch = private.pieceDragger
	button:addEventListener( "touch" )

	-- Rocket Turret
	local button = display.newImageRect( layers.overlay, "images/editor/rocketturret.png", pieceSize, pieceSize )
	button.x = col(3)	
	button.y = row2
	button.otype = "rocketturret"
	drawimg["rocketturret"] = "rocketturret"
	button.touch = private.pieceDragger
	button:addEventListener( "touch" )

	-- Horizontal Path
	local button = display.newImageRect( layers.overlay, "images/editor/hpath.png", pieceSize, pieceSize )
	button.x = col(4)	
	button.y = row2
	button.otype = "hpath"
	drawimg["hpath"] = "round"
	button.touch = private.pieceDragger
	button:addEventListener( "touch" )

	-- Vertical Path
	local button = display.newImageRect( layers.overlay, "images/editor/vpath.png", pieceSize, pieceSize )
	button.x = col(5)	
	button.y = row2
	button.otype = "vpath"
	drawimg["vpath"] = "round"
	button.touch = private.pieceDragger
	button:addEventListener( "touch" )


end

----------------------------------------------------------------------
----------------------------------------------------------------------
function private.drawDetailsTray( )
	local tray = display.newRoundedRect( layers.overlay, w - 5, 15, 450, 475, 12  )
	tray.anchorX = 1
	tray.anchorY = 0
	tray:setFillColor(0.5,0.5,0.5,0.5)
	tray:setStrokeColor(1,1,0,0.5)
	tray.strokeWidth = 2

	dtg = display.newGroup()

	-- Create Editor Drag & Drop 'Buttons'
	function dtg.cx( val ) return tray.x - tray.contentWidth + val end 
	function dtg.cy( val ) return tray.y + val end 
end

----------------------------------------------------------------------
----------------------------------------------------------------------
private.pieceDragger = function( self, event )
	if( event.phase == "began" ) then
		self.x0 = self.x
		self.y0 = self.y
		self.alpha = 0.5
		self.isFocus = true
		--display.getCurrentStage():setFocus( self, event.id )
	elseif( self.isFocus ) then
		self.x = event.x
		self.y = event.y
		if( event.phase == "ended" ) then
			print("DRAGGER")
			--display.getCurrentStage():setFocus( self, nil )
			self.isFocus = false
			self.x = self.x0
			self.y = self.y0
			lastDrop = self.otype
			self.alpha = 1			
		end
	end
	return false
end

----------------------------------------------------------------------
----------------------------------------------------------------------
private.editGridTouch = function( self, event )
	if( event.phase == "ended" ) then		
		if( lastDrop ) then 
			print("Drop @ grid ", self.col, self.row, lastDrop )
			self.otype = lastDrop
			self.subtype = 1
			lastDrop = nil
			self:refresh()			
		else
			print("Select grid ", self.col, self.row )
		end

		private.refreshDetailTray( self )

		for k, v in pairs( gridPieces ) do
			v:setStrokeColor(1,0,0,0.5)
			v.xScale = 1
			v.yScale = 1
			v.strokeWidth = 1
		end
		self:setStrokeColor(0,1,0)
		self.xScale = 0.95
		self.yScale = 0.95
		self.strokeWidth = 2
	end
	return false
end

----------------------------------------------------------------------
----------------------------------------------------------------------
private.refreshDetailTray = function( grid )
	while( dtg.numChildren > 0 ) do
		display.remove(dtg[1])
	end

	-- localize x/y offset calculators
	local cx = dtg.cx
	local cy = dtg.cy

	-- Draw grid label

	local posLabel = display.newText( dtg, "col: " .. grid.col .. "  row: " .. grid.row, cx( 20 ), cy( 20 ), native.systemFontBold, 22 )
	posLabel.anchorX = 0
	posLabel.anchorY = 0

	-- Type Label
	local typeLabel
	if( grid.otype and grid.otype ~= "none" ) then			
		typeLabel = display.newText( dtg, grid.otype, posLabel.x + posLabel.contentWidth + 20, posLabel.y , native.systemFontBold, 22 )
		typeLabel.anchorX = 0
		typeLabel.anchorY = 0
	end

	-- Coin Markers
	for i = 1, 4 do
		local tmp = display.newImageRect( dtg, "images/editor/coin.png", pieceSize - 10, pieceSize - 10 )		
		tmp.anchorX = 0
		tmp.x = cx( i * pieceSize ) - pieceSize/2
		tmp.y = cy( 80 )
		tmp:setStrokeColor(1,0,0)
		tmp.strokeWidth = 2
		tmp.pos = i
		if( grid.coins[i] == true ) then
			tmp:setStrokeColor(0,1,0)
		end
		tmp.touch = function( self, event )
			if( event.phase == "ended" ) then
			 	grid.coins[self.pos] = not grid.coins[self.pos]
			 	if( grid.coins[self.pos] == true ) then
			 		self:setStrokeColor(0,1,0)
			 	else
			 		self:setStrokeColor(1,0,0)
			 	end
			 	private.refreshGrid(grid)
			end
			return false
		end
		tmp:addEventListener("touch")
	end
	
	-- Decoy Markers
	for i = 1, 4 do
		local tmp = display.newImageRect( dtg, "images/editor/decoy.png", pieceSize - 10, pieceSize - 10 )		
		tmp.anchorX = 0
		tmp.x = 200 + cx( i * pieceSize ) - pieceSize/2
		tmp.y = cy( 80 )
		tmp:setStrokeColor(1,0,0)
		tmp.strokeWidth = 2
		tmp.pos = i
		if( grid.decoys[i] == true ) then
			tmp:setStrokeColor(0,1,0)
		end
		tmp.touch = function( self, event )
			if( event.phase == "ended" ) then
			 	grid.decoys[self.pos] = not grid.decoys[self.pos]
			 	if( grid.decoys[self.pos] == true ) then
			 		self:setStrokeColor(0,1,0)
			 	else
			 		self:setStrokeColor(1,0,0)
			 	end
			 	private.refreshGrid(grid)
			end
			return false
		end
		tmp:addEventListener("touch")
	end

	-- Spike Markers
	for i = 1, 4 do
		local tmp = display.newImageRect( dtg, "images/editor/spikes.png", pieceSize - 10, pieceSize - 10 )		
		tmp.rotation = (i-1) * 90
		tmp.x = cx( i * pieceSize ) - 5
		tmp.y = cy( 130 )
		tmp:setStrokeColor(1,0,0)
		tmp.strokeWidth = 2
		tmp.pos = i
		if( grid.spikes[i] == true ) then
			tmp:setStrokeColor(0,1,0)
		end
		tmp.touch = function( self, event )
			if( event.phase == "ended" ) then
			 	grid.spikes[self.pos] = not grid.spikes[self.pos]
			 	if( grid.spikes[self.pos] == true ) then
			 		self:setStrokeColor(0,1,0)
			 	else
			 		self:setStrokeColor(1,0,0)
			 	end
			 	private.refreshGrid(grid)			 	
			end
			return false
		end
		tmp:addEventListener("touch")
	end

	-- Monster Markers
	for i = 1, 4 do
		local tmp = display.newImageRect( dtg, "images/editor/monster.png", pieceSize - 10, pieceSize - 10 )		
		tmp.x = 215 + cx( i * pieceSize ) - pieceSize/2
		tmp.y = cy( 130 )
		tmp:setStrokeColor(1,0,0)
		tmp.strokeWidth = 2
		tmp.pos = i
		tmp.rotation = (i-1) * 90
		if( grid.monster[i] == true ) then
			tmp:setStrokeColor(0,1,0)
		end
		tmp.touch = function( self, event )
			if( event.phase == "ended" ) then
			 	grid.monster[self.pos] = not grid.monster[self.pos]
			 	if( grid.monster[self.pos] == true ) then
			 		self:setStrokeColor(0,1,0)
			 	else
			 		self:setStrokeColor(1,0,0)
			 	end
			 	private.refreshGrid(grid)
			end
			return false
		end
		tmp:addEventListener("touch")
	end

	-- Sub Type Label
	if( grid.otype == "laserturret" ) then

		local subTypeLabel = display.newText( dtg, "Subtype:", 0, cy(240), native.systemFontBold, 22 )
		--subTypeLabel.anchorX = 0
		subTypeLabel.x = cx(10 + subTypeLabel.contentWidth/2)
		local maxSubTypes
		local buttons = {}
		for i = 1, 8 do
			local tmp = display.newRect( dtg, subTypeLabel.x + subTypeLabel.contentWidth/2 + (i * (pieceSize-10)) - 5, subTypeLabel.y , pieceSize - 20, pieceSize - 20 )		
			local tmp2 = display.newText( dtg, i, tmp.x, tmp.y, native.systemFontBold, 10 )
			tmp2:setFillColor(0,0,0)

			buttons[tmp] = tmp
			tmp.rotation = (i-1) * 90
			tmp:setStrokeColor(1,0,0)
			tmp.strokeWidth = 2
			tmp.subtype = i
			if( grid.subtype == i ) then
				tmp:setStrokeColor(0,1,0)
			end
			tmp.touch = function( self, event )
				if( event.phase == "ended" ) then
					for k,v in pairs( buttons ) do
						v:setStrokeColor(1,0,0)
					end
				 	grid.subtype = self.subtype
				 	self:setStrokeColor(0,1,0)
				 	private.refreshGrid(grid)
				 	private.refreshDetailTray(grid)
				end
				return false
			end
			tmp:addEventListener("touch")
		end
	
	elseif( grid.otype == "rocketturret" or  grid.otype == "rotatinglaserturret" ) then

		local subTypeLabel = display.newText( dtg, "Subtype:", 0, cy(240), native.systemFontBold, 22 )
		--subTypeLabel.anchorX = 0
		subTypeLabel.x = cx(10 + subTypeLabel.contentWidth/2)
		local maxSubTypes
		local buttons = {}
		for i = 1, 4 do
			local tmp = display.newRect( dtg, subTypeLabel.x + subTypeLabel.contentWidth/2 + (i * (pieceSize-10)) - 5, subTypeLabel.y , pieceSize - 20, pieceSize - 20 )		
			local tmp2 = display.newText( dtg, i, tmp.x, tmp.y, native.systemFontBold, 10 )
			tmp2:setFillColor(0,0,0)

			buttons[tmp] = tmp
			tmp.rotation = (i-1) * 90
			tmp:setStrokeColor(1,0,0)
			tmp.strokeWidth = 2
			tmp.subtype = i
			if( grid.subtype == i ) then
				tmp:setStrokeColor(0,1,0)
			end
			tmp.touch = function( self, event )
				if( event.phase == "ended" ) then
					for k,v in pairs( buttons ) do
						v:setStrokeColor(1,0,0)
					end
				 	grid.subtype = self.subtype
				 	self:setStrokeColor(0,1,0)
				 	private.refreshGrid(grid)
				 	private.refreshDetailTray(grid)
				end
				return false
			end
			tmp:addEventListener("touch")
		end

	elseif( grid.otype == "hpath" or  grid.otype == "vpath" ) then

		local subTypeLabel = display.newText( dtg, "Subtype:", 0, cy(240), native.systemFontBold, 22 )
		--subTypeLabel.anchorX = 0
		subTypeLabel.x = cx(10 + subTypeLabel.contentWidth/2)
		local maxSubTypes
		local buttons = {}
		for i = 1, 6 do
			local tmp = display.newRect( dtg, subTypeLabel.x + subTypeLabel.contentWidth/2 + (i * (pieceSize-10)) - 5, subTypeLabel.y , pieceSize - 20, pieceSize - 20 )		
			local tmp2 = display.newText( dtg, i, tmp.x, tmp.y, native.systemFontBold, 10 )
			tmp2:setFillColor(0,0,0)

			buttons[tmp] = tmp
			tmp.rotation = (i-1) * 90
			tmp:setStrokeColor(1,0,0)
			tmp.strokeWidth = 2
			tmp.subtype = i
			if( grid.subtype == i ) then
				tmp:setStrokeColor(0,1,0)
			end
			tmp.touch = function( self, event )
				if( event.phase == "ended" ) then
					for k,v in pairs( buttons ) do
						v:setStrokeColor(1,0,0)
					end
				 	grid.subtype = self.subtype
				 	self:setStrokeColor(0,1,0)
				 	private.refreshGrid(grid)
				 	private.refreshDetailTray(grid)
				end
				return false
			end
			tmp:addEventListener("touch")
		end
	end

	if( grid.otype == "laserturret" ) then
		local rotations = { 0, 45, 90, 135, 180, 225, 270, 315 }
		local subTypeLabelDescription = display.newText( dtg, "Fixed Angle " .. rotations[grid.subtype] .. " degrees", cx(10), cy(280), native.systemFontBold, 22 )
		subTypeLabelDescription.anchorX = 0

	elseif( grid.otype == "rotatinglaserturret" ) then
		local rotations = { "right by 90 degrees every period", "left by 90 degrees every period", "right by 45 degrees every period", "left by 45 degrees every period" }
		local subTypeLabelDescription = display.newText( dtg, "Rotate " .. rotations[grid.subtype] .. " degrees", cx(10), cy(280), native.systemFontBold, 18 )
		subTypeLabelDescription.anchorX = 0		

	elseif( grid.otype == "rocketturret" ) then
		local rotations = { 45, 135, 225, 315 }
		print(grid.subtype)
		local subTypeLabelDescription = display.newText( dtg, "Fixed Angle " .. rotations[grid.subtype] .. " degrees", cx(10), cy(280), native.systemFontBold, 22 )
		subTypeLabelDescription.anchorX = 0		


	elseif( grid.otype == "hpath" ) then
		local pathlen = { "Short", "Short", "Short", "Short", "Long", "Long" }
		local offset = { "None", "Left", "Left", "Right", "None", "Right" }
		local starts = { "Left", "Left", "Left", "Right", "Right", "Right" }
		print(grid.subtype)
		local subTypeLabelDescription = display.newText( dtg, pathlen[grid.subtype] .. " path; " ..
			                                                  "Offset " .. offset[grid.subtype] .. "; " ..
			                                                  "Starts " .. starts[grid.subtype], 
			                                                  cx(10), cy(280), native.systemFontBold, 18 )
		subTypeLabelDescription.anchorX = 0		

	elseif( grid.otype == "vpath" ) then
		local pathlen = { "Short", "Short", "Long", "Short", "Short", "Long" }
		local offset = { "Down", "Up", "None", "Down", "Up", "None" }
		local starts = { "Up", "Up", "Up", "Down", "Down", "Down" }
		print(grid.subtype)
		local subTypeLabelDescription = display.newText( dtg, pathlen[grid.subtype] .. " path; " ..
			                                                  "Offset " .. offset[grid.subtype] .. "; " ..
			                                                  "Starts " .. starts[grid.subtype],
			                                                   cx(10), cy(280), native.systemFontBold, 18 )
		subTypeLabelDescription.anchorX = 0		

	end
end

----------------------------------------------------------------------
----------------------------------------------------------------------
private.refreshGrid = function( self )
	--print("refreshing Grid"
	-- Purge all old art 
	for k, v in pairs( self.parts ) do
		display.remove(v)
	end
	self.parts = {}

	if( self.otype and self.otype ~= "none" ) then
		local tmp = display.newImageRect( self.parent, "images/editor/" .. drawimg[self.otype] .. ".png", pieceSize/2, pieceSize/2 )
		tmp.x = self.x
		tmp.y = self.y	
		self.parts[tmp]	= tmp
	

		if( self.otype == "laserturret" ) then
			local rotations = { 0, 45, 90, 135, 180, 225, 270, 315 }
			tmp.rotation = rotations[self.subtype]		
		
		elseif( self.otype == "rotatinglaserturret" ) then
			if( self.subtype == 1 ) then
				function tmp.onComplete( self )
					if( self.removeSelf == nil ) then
						return 
					end
					transition.to( self, { delay = common.turretRotateTime, time = common.turretRotateTime, rotation = self.rotation + 90, onComplete = self } )
				end		
				transition.to( tmp, { delay = 1000, time = 1000, rotation = tmp.rotation + 90, onComplete = tmp } )
			
			elseif( self.subtype == 2 ) then
				tmp.xScale = -1
				function tmp.onComplete( self )
					if( self.removeSelf == nil ) then
						return 
					end
					transition.to( self, { delay = 1000, time = 1000, rotation = self.rotation - 90, onComplete = self } )
				end		
				transition.to( tmp, { delay = 1000, time = 1000, rotation = tmp.rotation - 90, onComplete = tmp } )


			elseif( self.subtype == 3 ) then
				function tmp.onComplete( self )
					if( self.removeSelf == nil ) then
						return 
					end
					transition.to( self, { delay = 1000/2, time = 1000/2, rotation = self.rotation + 45, onComplete = self } )
				end		
				transition.to( tmp, { delay = 1000/2, time = 1000/2, rotation = tmp.rotation + 45, onComplete = tmp } )
			
			elseif( self.subtype == 4 ) then
				tmp.xScale = -1
				function tmp.onComplete( self )
					if( self.removeSelf == nil ) then
						return 
					end
					transition.to( self, { delay = 1000/2, time = 1000/2, rotation = self.rotation - 45, onComplete = self } )
				end		
				transition.to( tmp, { delay = 1000/2, time = 1000/2, rotation = tmp.rotation - 45, onComplete = tmp } )

			end
		elseif( self.otype == "rocketturret" ) then
			local rotations = { 45, 135, 225, 315 }
			tmp.rotation = rotations[self.subtype]		

		elseif( self.otype == "hpath" ) then
			if( self.subtype == 1 ) then
				local track = display.newRect( self.parent, tmp.x, tmp.y, gridSize, pieceSize/8 )
				track.anchorX = 0
				track:setFillColor(0)
				track:setStrokeColor(1)
				track.strokeWidth = 2
				self.parts[track]	= track
				tmp:toFront()
				local startPoint = display.newCircle( self.parent, tmp.x, tmp.y, pieceSize/10)
				startPoint:setFillColor(0,1,0)
				self.parts[startPoint]	= startPoint

				local endPoint = display.newCircle( self.parent, tmp.x + gridSize, tmp.y, pieceSize/10)
				endPoint:setFillColor(1,0,0)
				self.parts[endPoint]	= endPoint

			elseif( self.subtype == 2 ) then
				local track = display.newRect( self.parent, tmp.x, tmp.y, gridSize, pieceSize/8 )
				track.anchorX = 1
				track:setFillColor(0)
				track:setStrokeColor(1)
				track.strokeWidth = 2
				self.parts[track]	= track
				tmp:toFront()
				local startPoint = display.newCircle( self.parent, tmp.x-gridSize, tmp.y, pieceSize/10)
				startPoint:setFillColor(0,1,0)
				self.parts[startPoint]	= startPoint

				local endPoint = display.newCircle( self.parent, tmp.x, tmp.y, pieceSize/10)
				endPoint:setFillColor(1,0,0)
				self.parts[endPoint]	= endPoint

			elseif( self.subtype == 3 ) then
				local track = display.newRect( self.parent, tmp.x, tmp.y, gridSize * 2, pieceSize/8 )
				--track.anchorX = 0
				track:setFillColor(0)
				track:setStrokeColor(1)
				track.strokeWidth = 2
				self.parts[track]	= track
				tmp:toFront()
				local startPoint = display.newCircle( self.parent, tmp.x - gridSize, tmp.y, pieceSize/10)
				startPoint:setFillColor(0,1,0)
				self.parts[startPoint]	= startPoint

				local endPoint = display.newCircle( self.parent, tmp.x + gridSize, tmp.y, pieceSize/10)
				endPoint:setFillColor(1,0,0)
				self.parts[endPoint]	= endPoint

			elseif( self.subtype == 4 ) then
				local track = display.newRect( self.parent, tmp.x, tmp.y, gridSize, pieceSize/8 )
				track.anchorX = 0
				track:setFillColor(0)
				track:setStrokeColor(1)
				track.strokeWidth = 2
				self.parts[track]	= track
				tmp:toFront()
				local startPoint = display.newCircle( self.parent, tmp.x+ gridSize, tmp.y, pieceSize/10)
				startPoint:setFillColor(0,1,0)
				self.parts[startPoint]	= startPoint

				local endPoint = display.newCircle( self.parent, tmp.x , tmp.y, pieceSize/10)
				endPoint:setFillColor(1,0,0)
				self.parts[endPoint]	= endPoint
			
			elseif( self.subtype == 5 ) then
				local track = display.newRect( self.parent, tmp.x, tmp.y, gridSize, pieceSize/8 )
				track.anchorX = 1
				track:setFillColor(0)
				track:setStrokeColor(1)
				track.strokeWidth = 2
				self.parts[track]	= track
				tmp:toFront()
				local startPoint = display.newCircle( self.parent, tmp.x, tmp.y, pieceSize/10)
				startPoint:setFillColor(0,1,0)
				self.parts[startPoint]	= startPoint

				local endPoint = display.newCircle( self.parent, tmp.x-gridSize, tmp.y, pieceSize/10)
				endPoint:setFillColor(1,0,0)
				self.parts[endPoint]	= endPoint

			elseif( self.subtype == 6 ) then
				local track = display.newRect( self.parent, tmp.x, tmp.y, gridSize * 2, pieceSize/8 )
				--track.anchorX = 0
				track:setFillColor(0)
				track:setStrokeColor(1)
				track.strokeWidth = 2
				self.parts[track]	= track
				tmp:toFront()
				local startPoint = display.newCircle( self.parent, tmp.x + gridSize, tmp.y, pieceSize/10)
				startPoint:setFillColor(0,1,0)
				self.parts[startPoint]	= startPoint

				local endPoint = display.newCircle( self.parent, tmp.x - gridSize, tmp.y, pieceSize/10)
				endPoint:setFillColor(1,0,0)
				self.parts[endPoint]	= endPoint
			end

		elseif( self.otype == "vpath" ) then
			if( self.subtype == 1 ) then
				local track = display.newRect( self.parent, tmp.x, tmp.y, pieceSize/8, gridSize )
				track.anchorY = 0
				track:setFillColor(0)
				track:setStrokeColor(1)
				track.strokeWidth = 2
				self.parts[track]	= track
				tmp:toFront()
				local startPoint = display.newCircle( self.parent, tmp.x, tmp.y, pieceSize/10)
				startPoint:setFillColor(0,1,0)
				self.parts[startPoint]	= startPoint

				local endPoint = display.newCircle( self.parent, tmp.x, tmp.y + gridSize, pieceSize/10)
				endPoint:setFillColor(1,0,0)
				self.parts[endPoint]	= endPoint

			elseif( self.subtype == 2 ) then
				local track = display.newRect( self.parent, tmp.x, tmp.y, pieceSize/8, gridSize )
				track.anchorY = 1
				track:setFillColor(0)
				track:setStrokeColor(1)
				track.strokeWidth = 2
				self.parts[track]	= track
				tmp:toFront()
				local startPoint = display.newCircle( self.parent, tmp.x, tmp.y-gridSize, pieceSize/10)
				startPoint:setFillColor(0,1,0)
				self.parts[startPoint]	= startPoint

				local endPoint = display.newCircle( self.parent, tmp.x, tmp.y, pieceSize/10)
				endPoint:setFillColor(1,0,0)
				self.parts[endPoint]	= endPoint

			elseif( self.subtype == 3 ) then
				local track = display.newRect( self.parent, tmp.x, tmp.y, pieceSize/8, gridSize * 2 )
				track:setFillColor(0)
				track:setStrokeColor(1)
				track.strokeWidth = 2
				self.parts[track]	= track
				tmp:toFront()
				local startPoint = display.newCircle( self.parent, tmp.x, tmp.y- gridSize, pieceSize/10)
				startPoint:setFillColor(0,1,0)
				self.parts[startPoint]	= startPoint

				local endPoint = display.newCircle( self.parent, tmp.x, tmp.y + gridSize, pieceSize/10)
				endPoint:setFillColor(1,0,0)
				self.parts[endPoint]	= endPoint

			elseif( self.subtype == 4 ) then
				local track = display.newRect( self.parent, tmp.x, tmp.y, pieceSize/8, gridSize )
				track.anchorY = 0
				track:setFillColor(0)
				track:setStrokeColor(1)
				track.strokeWidth = 2
				self.parts[track]	= track
				tmp:toFront()
				local startPoint = display.newCircle( self.parent, tmp.x, tmp.y + gridSize, pieceSize/10)
				startPoint:setFillColor(0,1,0)
				self.parts[startPoint]	= startPoint

				local endPoint = display.newCircle( self.parent, tmp.x , tmp.y, pieceSize/10)
				endPoint:setFillColor(1,0,0)
				self.parts[endPoint]	= endPoint
			
			elseif( self.subtype == 5 ) then
				local track = display.newRect( self.parent, tmp.x, tmp.y, pieceSize/8, gridSize )
				track.anchorY = 1
				track:setFillColor(0)
				track:setStrokeColor(1)
				track.strokeWidth = 2
				self.parts[track]	= track
				tmp:toFront()
				local startPoint = display.newCircle( self.parent, tmp.x, tmp.y, pieceSize/10)
				startPoint:setFillColor(0,1,0)
				self.parts[startPoint]	= startPoint

				local endPoint = display.newCircle( self.parent, tmp.x, tmp.y - gridSize, pieceSize/10)
				endPoint:setFillColor(1,0,0)
				self.parts[endPoint]	= endPoint

			elseif( self.subtype == 6 ) then
				local track = display.newRect( self.parent, tmp.x, tmp.y, pieceSize/8, gridSize * 2 )
				track:setFillColor(0)
				track:setStrokeColor(1)
				track.strokeWidth = 2
				self.parts[track]	= track
				tmp:toFront()
				local startPoint = display.newCircle( self.parent, tmp.x, tmp.y + gridSize, pieceSize/10)
				startPoint:setFillColor(0,1,0)
				self.parts[startPoint]	= startPoint

				local endPoint = display.newCircle( self.parent, tmp.x, tmp.y - gridSize, pieceSize/10)
				endPoint:setFillColor(1,0,0)
				self.parts[endPoint]	= endPoint
			end
		end
	end

	-- Show Spikes
	for i = 1, 4 do
		if( self.spikes[i] == true ) then
			local tmp = display.newImageRect( self.parent, "images/editor/spikes.png", pieceSize/2, pieceSize/2)
			self.parts[tmp]	= tmp
			tmp.x = self.x
			tmp.y = self.y	

			if( i == 1 ) then 
				tmp.rotation = 0
				tmp.x = self.x
				tmp.y = self.y - pieceSize/7	
			elseif( i == 2 ) then 
				tmp.rotation = 90
				tmp.x = self.x + pieceSize/7
				tmp.y = self.y	
			elseif( i == 3 ) then 
				tmp.rotation = 180
				tmp.x = self.x
				tmp.y = self.y + pieceSize/7
			else
				tmp.rotation = 270
				tmp.x = self.x - pieceSize/7
				tmp.y = self.y	
			end
		end
	end

	-- Show Coins
	for i = 1, 4 do
		if( self.coins[i] == true ) then
			local tmp = display.newImageRect( self.parent, "images/editor/coin.png", pieceSize/4, pieceSize/4)
			self.parts[tmp]	= tmp
			if( i == 1 ) then 
				tmp.x = self.x
				tmp.y = self.y - pieceSize/2	
			elseif( i == 2 ) then 
				tmp.x = self.x + pieceSize/2
				tmp.y = self.y	
			elseif( i == 3 ) then 
				tmp.x = self.x
				tmp.y = self.y + pieceSize/2
			else
				tmp.x = self.x - pieceSize/2
				tmp.y = self.y	
			end
		end
	end

	-- Show Decoys
	for i = 1, 4 do
		if( self.decoys[i] == true ) then
			local tmp = display.newImageRect( self.parent, "images/editor/decoy.png", pieceSize/3, pieceSize/3)
			self.parts[tmp]	= tmp
			if( i == 1 ) then 
				tmp.x = self.x
				tmp.y = self.y - pieceSize/2	
			elseif( i == 2 ) then 
				tmp.x = self.x + pieceSize/2
				tmp.y = self.y	
			elseif( i == 3 ) then 
				tmp.x = self.x
				tmp.y = self.y + pieceSize/2
			else
				tmp.x = self.x - pieceSize/2
				tmp.y = self.y	
			end
		end
	end

	-- Show Monsters
	for i = 1, 4 do
		if( self.monster[i] == true ) then
			local tmp = display.newImageRect( self.parent, "images/editor/monster.png", pieceSize/2, pieceSize/2)
			self.parts[tmp]	= tmp
			tmp.x = self.x
			tmp.y = self.y	

			if( i == 1 ) then 
				tmp.rotation = 0
				tmp.x = self.x
				tmp.y = self.y - pieceSize/7	
			elseif( i == 2 ) then 
				tmp.rotation = 90
				tmp.x = self.x + pieceSize/7
				tmp.y = self.y	
			elseif( i == 3 ) then 
				tmp.rotation = 180
				tmp.x = self.x
				tmp.y = self.y + pieceSize/7
			else
				tmp.rotation = 270
				tmp.x = self.x - pieceSize/7
				tmp.y = self.y	
			end

		end
	end

	if( savesEnabled ) then
		private.save()
	end
end

----------------------------------------------------------------------
----------------------------------------------------------------------
function private.restore()
	print("Restoring @ ", getTimer() )

	local level = table.load( "level.txt" ) or  {}	
	for k,v in pairs( gridPieces ) do
		for i = 1, #level do			
			if( level[i].row == v.row and level[i].col == v.col ) then
				--table.dump(level[i])
				v.otype = level[i].otype
				v.subtype = level[i].subtype
				v.coins = level[i].coins or { false, false, false, false }
				v.monster = level[i].monster or { false, false, false, false }
				v.decoys = level[i].decoys or { false, false, false, false }
				v.spikes = level[i].spikes or { false, false, false, false }
				private.refreshGrid( v )
		 	end
		end
	end		
end

----------------------------------------------------------------------
----------------------------------------------------------------------
function private.save()
	local level = {}
	print("Saving @ ", getTimer() )
	for k,v in pairs( gridPieces ) do		
		local doSave = false

		doSave = doSave or (v.otype ~= nil and v.otype ~= "none" )
		doSave = doSave or (v.coins[1] or v.coins[2] or v.coins[3] or v.coins[4])
		doSave = doSave or (v.decoys[1] or v.decoys[2] or v.decoys[3] or v.decoys[4])
		doSave = doSave or (v.spikes[1] or v.spikes[2] or v.spikes[3] or v.spikes[4])
		if( doSave ) then
			--table.dump( v )
			local element = {}
			element.otype = v.otype
			element.row = v.row
			element.col = v.col
			element.subtype = v.subtype
			element.coins = v.coins
			element.decoys = v.decoys
			element.monster = v.monster
			element.spikes = v.spikes
			level[#level+1] = element
		end
	end

	table.save( level, "level.txt" )
end


return public