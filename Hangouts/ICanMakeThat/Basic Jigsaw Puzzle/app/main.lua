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

----------------------------------------------------------------------
--	1. Requires
----------------------------------------------------------------------


----------------------------------------------------------------------
--	2. Initialization
----------------------------------------------------------------------
io.output():setvbuf("no") -- Don't use buffer for console messages
display.setStatusBar(display.HiddenStatusBar)  -- Hide that pesky bar

----------------------------------------------------------------------
-- 3. Declarations
----------------------------------------------------------------------

-- Locals
											-- Some helper variables specifying:
local w       = display.contentWidth		-- Design width, height, and center <x,y> positions.
local h       = display.contentHeight
local centerX = display.contentWidth/2 
local centerY = display.contentHeight/2

											-- Choose one of two pre-defined puzzle piece sets
local puzzleName = "starrynight"
--local puzzleName = "dogs"

local puzzlePieces = {}						-- Table used to store the puzzle pieces.

-- Labels, Buttons, Etc
local gameStatusMsg							-- Empty variable that will be used to store the handle to a text object 
											-- representing the game status message.

local puzzleArea							-- Empty variable that will be used to store the handle to a rectangle.
											-- This rectangle is the location where the finished puzzle should be placed.

local piecesTray							-- Empty variable that will be used to store the handle to a rectangle.
											-- This rectangle is the location where the puzzle pieces will be placed
											-- at the beginning of the game.  (Temporary place to stack the unused pieces.)

-- Forward Declarations
local drawBoard								-- Function to draw the game board. (Makes puzzleArea and piecesTray)
local placePieces							-- Function to draw the actual puzzle pieces (starting in their solved positions).
local movePiecesToTray						-- Function to take the previously placed pieces and stack them in the 'piecesTray'.

local isSolved								-- Function to check for a solved puzzle.  
local pointInRect							-- Helper function that checks if an <x,y> point is inside a rectangular area on the screen.

-- Listener Declarations
local onPuzzlePieceTouch					-- Touch handler for the puzzle pieces.  Handles drag-n-drop response.

----------------------------------------------------------------------
-- 4. Definitions
----------------------------------------------------------------------

--==
-- ================================= FUNCTION DEFINITIONS
--==

-- ==
--    drawBoard() - Draws the 'puzzleArea', 'piecesTray', and the 'gameStatusMsg'.
-- ==
drawBoard = function()

	--
	-- 1. Draw Puzzle (Target) Area -- Place adjacent to the lower-right edge of the screen.
	--
	puzzleArea = display.newRect( 0, 0, 300, 240) 

	-- Tip: When we create a rectangle, we place it by its upper-left corner at <0,0>.
	--      However, after a rectangle has been created, the refenence point automatically
	--      changes to its center.  
	--      So, in the future when we place it, we are specifying where the CENTER of the 
	--      rectangle should be.

	puzzleArea.x = w - 160
	puzzleArea.y = centerY + 35

	-- Make the fill DARKGREY and the outline a THIN LIGHTGREY
	--
	puzzleArea:setFillColor( 0.125,0.125,0.125,1 )
	puzzleArea:setStrokeColor( 0.5,0.5,0.5,1 )
	puzzleArea.strokeWidth = 1

	--
	-- 2. Draw Piece Tray -- Take up most of the left side of the screen.
	--
	piecesTray = display.newRect( 0, 0, 140, 140) 

	-- Same tip as above on creation, then placement.
	--
	piecesTray.x = 85
	piecesTray.y = centerY

	-- Make the fill DARKGREY and the outline a THIN LIGHTGREY
	--
	piecesTray:setFillColor( 0.125,0.125,0.125,1 )
	piecesTray:setStrokeColor( 0.5,0.5,0.5,1 )
	piecesTray.strokeWidth = 1

	-- 
	-- 3. Make Game Status Indicator
	-- 
	gameStatusMsg = display.newEmbossedText( "Puzzle Solved!", 0, 0, native.systemFont, 36 )		

	gameStatusMsg.x = puzzleArea.x
	gameStatusMsg.y = 40

	-- Tip: I created the above text object at position <0,0> and then positioned it.  Why?  Because you have no way of knowing the exact width/height
	-- of a text object till it is created.  So, trying to position it during creation will end up placing it by the upper-left coordinates, and may not be what you wanted.
	-- However, after the text object is created, it changes to a center reference point.  So, by waiting to set the position, we get the result we really wanted.

	gameStatusMsg:setFillColor( 0.1211,0.8633,0.1211 )	-- Make the solved message a nice shade of green.
	gameStatusMsg.isVisible = false			-- Hide it for now.  (The puzzle isn't solved yet!)

end

-- ****************************************************************************************
--	WARNING		WARNING		WARNING		WARNING		WARNING		WARNING		WARNING
-- ****************************************************************************************
--  Before you read the next part of the code, be sure you have examined the document:
-- 
--			MakingJigsawPuzzlePieces.pdf
--
--  Otherwise, the source of the following dimensions and details may be somewhat mysterious.
--	
-- ****************************************************************************************

-- ==
--    placePieces() - (Create and) place the pre-sliced puzzle pieces.
-- ==
placePieces = function()

	-- Placing jigsaw pieces is a bit trickier than placing rectangular pieces, because
	-- the pieces generally do not have any (easily calculated) correct positions.
	--
	-- Why?  Because each piece is irregularly, shaped and sized.  Further comlicating things,
	-- each piece may overlap other pieces.  Now, there are ways to regularize this, but my suggestion
	-- is that you not try to programatically solve placment of jigsaw pieces.  Either buy an 
	-- algorithm from someone who has, or place the pieces manually and use my technique of later
	-- moving the solved positions to the tray.
	--
	-- Now, having said all of that, the example you are looking at is an exception to the 
	-- above rule.  Because this simple puzzle only has four (4) pieces, I can easily place them
	-- simply by setting their reference points to the correct outer edge and placing that piece on the
	-- corner of the 'puzzleArea'.
	--
	-- Follow along carefully now and this should become clear...
	--

	-- Calculate the outer bounds (left, right, top, and bottom) of the 'puzzleArea'
	--	
	local left   = puzzleArea.x - puzzleArea.contentWidth/2
	local right  = puzzleArea.x + puzzleArea.contentWidth/2
	local top    = puzzleArea.y - puzzleArea.contentHeight/2
	local bottom = puzzleArea.y + puzzleArea.contentHeight/2

	--
	-- Place Pieces In Solved Positions
	--
	-- To place the pieces, traverse the puzzle col first, column second.
	--
	local tmp
	for row = 1, 2 do
		for col = 1, 2 do

		-- Calculate the image number here we are placing.
		--
		local imgNum = row + (col-1) * 2
		
		tmp = display.newImage( "images/" .. puzzleName .. "/" .. imgNum .. ".png") 

		-- Now for the magic, depending on the piece we are placing, set it's reference
		-- point accordingly.
		-- 1 - Top Left 
		-- 2 - Top Right
		-- 3 - Bottom Left
		-- 4 - Bottom Right
		--
		-- Then, simply place that piece at the proper pre-calculated position.
		-- 1 - < left, top >
		-- 2 - < right, top >
		-- 3 - < left, bottom >
		-- 4 - < right, bottom >
		-- 
		-- Viola!
		--
		if(imgNum == 1) then
			--tmp:setReferencePoint( display.TopLeftReferencePoint )
			tmp.x = left
			tmp.y = top
			tmp.anchorX = 0
			tmp.anchorY = 0


		elseif(imgNum == 2) then
			--tmp:setReferencePoint( display.TopRightReferencePoint )
			tmp.x = right
			tmp.y = top
			tmp.anchorX = 1
			tmp.anchorY = 0

		elseif(imgNum == 3) then
			--tmp:setReferencePoint( display.BottomLeftReferencePoint )
			tmp.x = left
			tmp.y = bottom
			tmp.anchorX = 0
			tmp.anchorY = 1

		elseif(imgNum == 4) then
			--tmp:setReferencePoint( display.BottomRightReferencePoint )
			tmp.x = right
			tmp.y = bottom
			tmp.anchorX = 1
			tmp.anchorY = 1

		end

		-- Now, before we record the 'solved' position, set the 
		-- piece's reference point back to the middle.
		--
		--tmp:setReferencePoint( display.CenterReferencePoint )

		-- Mark the starting position of each tile after we place it.  This is the 'solved position'
		-- for the tile.
		--
		tmp.solvedX = tmp.x
		tmp.solvedY = tmp.y

		-- Mark the tile as 'not solved'.  (Used in our 'isSolved()' function later.)
		--
		tmp.isSolved = false

		-- Attach a touch listener to thew newly created and placed tile.
		-- 
		tmp:addEventListener( "touch", onPuzzlePieceTouch )

		-- Lastly, put a reference to the new tile into the table 'puzzlePieces'
		-- This simply provides an easy way to keep track of the pieces and to iterate
		-- over them later in 'isSolved()'.
		-- 
		puzzlePieces[#puzzlePieces+1] = tmp

		end
	end

end

-- ==
--    movePiecesToTray() - This function moves the tile pieces created in 'placePieces()' over
--    to the puzzle tray.  (Otherwise the puzzle would be solved already!)
--
--	  This code may look a little complicated but it is pretty simple.  Here is what it does:
--
--    1. It determines an upper (yStart) and lower (yEnd) bound for placing pieces.  Later,
--       no piece will be allowed to have a y position outside this range.
--
--	  2. It starts the first y-position (curY) at the top (yStart)
--  
--    3. I then iterates over the pieces and does this:
-- 
--       3a. Assign a random x-position to the current piece equal to the center x-position of
--       'piecesTray' +/- 20 pixels.
--
--       3b. Assign the y-position as curY
-- 
--       3c. Mark the piece's 'inTray' position as the new location (i.e. where we just placed it).
--       (This is later used to snap the piece back to its tray position if the user drags the piece
--        and releases it over the tray.)
--
--       3d. Make the piece 20% smaller (by scaling it).  (Not required for functionality, but a nice effect.)
--
--       3e. Randomly rotates the piece a little (+/- 30 degrees). (Again, not required just a nice effect.)
--       (Also, record this rotation (in 'inTrayAngle') so we can re-rotate pieces that get dropped on the tray.)
--
--       3f. Calulate the next y-position by randomly adding from 60 to 100 pixels to curY.  Notice that
--       if curY is then greater than yEnd, it is set back to yStart.  As I said above, this keeps it in
--       our pre-calculated y-boundary.
--
--       Repeat 3a. .. 3f. for each piece.
--
--	  At the end of this process, we will have a nice random looking of down-scaled puzzle pieces over our
--    'piecesTray'.  By using random values the end result is never the same twice which gives a much more
--    professional look to the game.
--
-- ==
movePiecesToTray = function()

	-- 1. 
	local yStart = piecesTray.y - piecesTray.contentHeight/2 + 55
	local yEnd   = piecesTray.y + piecesTray.contentHeight/2 - 40

	-- 2. 
	local curY = yStart
	
	-- 3.
	for i = 1, #puzzlePieces do

		local aPiece = puzzlePieces[i]

		-- 3a.
		aPiece.x = piecesTray.x + math.random( -20, 20 )

		-- 3b.
		aPiece.y = curY

		-- 3c.
		aPiece.inTrayX = aPiece.x
		aPiece.inTrayY = aPiece.y

		-- 3d.
		aPiece.xScale = 0.5
		aPiece.yScale = 0.5

		-- 3e.
		aPiece.rotation = math.random( -30, 30 )
		aPiece.inTrayAngle = aPiece.rotation

		-- 3f.
		curY = curY + math.random( 60, 100)
		if( curY > yEnd ) then
			curY = yStart
		end		

	end 
end

-- ==
--    pointInRect() - This function is used to determine if an <x,y> point is within the bounds of
--    a rectangle.  It is used by the touch handler to determine if a piece was dragged-and-dropped
--    over the pieces tray or the puzzle area.
-- ==
pointInRect = function( pointX, pointY, left, top, width, height )
	if( pointX >= left and pointX <= left + width and 
	    pointY >= top and pointY <= top + height ) then 
	   return true
	else
		return false
	end
end

-- ==
--    isSolved() - This function has one job.  Iterate over all the pieces and return false
--    unless EVERY piece is marked as 'isSolved'.
-- ==
isSolved = function()

	local retVal = true

	for i = 1, #puzzlePieces do
		retVal = retVal and  puzzlePieces[i].solved
	end

	return retVal
end


--==
-- ================================= LISTENER DEFINITIONS
--==

-- ==
--    onPuzzlePieceTouch() - This is the touch handler.  It provides the ability to drag-and-drop puzzle pieces
--    from the pieceTray to anywhere on the screen.  It provides these 'special effects':
--    
--    1. When a piece is first touched, it will rotate back to 0-degrees and scale back to 100% of its original size.
--       (It also pops to the top of all other pieces so it is on top during the drag.)
--
--    2. Pieces dropped close enough to their solved positions will snap into place and be marked as solved. (Solved
--       pieces are ignored by the touch handler.)
--
--    3. Pieces dropped over the pieces tray will snap back to their 'inTray' position, size, and rotation (angle).
--
--    4. Pieces dropped anywhere else on the screen will simply sit there.  This allows users to drag pieces around and
--       compare them to eachother in order to find the pattern.
--
--    5. At the end of ever (successful) drop, the touch handler will run the 'isSolved()' function to see if the board was solved.
--
-- ==

-- Helper function to deal with offsets due to anchor extremes.
local function centerDrag( obj, event )	
	obj.x = obj.x0 + event.x - event.xStart
	obj.y = obj.y0 + event.y - event.yStart

	if( obj.anchorX == 0 ) then
		obj.x = obj.x - obj.contentWidth/2
	else
		obj.x = obj.x + obj.contentWidth/2
	end

	if( obj.anchorY == 0 ) then
		obj.y = obj.y - obj.contentHeight/2
	else
		obj.y = obj.y + obj.contentHeight/2
	end


end
onPuzzlePieceTouch = function( event )
	-- Tip: For all but the simplest cases, it is best to extract the values you need from 'event' into local variables.
	local phase    = event.phase  
	local target   = event.target
	local x        = event.x
	local y        = event.y

	local minSnapDistance = 15 -- Must be within 15 pixels of the solved position to snap into place.

	-- Piece is in solved position, lock it down and ignore all touches
	--
	if( target.solved ) then 
		return true -- Tell Corona that this touch has been processed/handled and does not need to propagate.
	end

	-- 1. The touch has begun (see notes above for what this section does).
	--
	if(event.phase == "began") then  
		target.rotation = 0
		
		target.xScale = 1
		target.yScale = 1

		target:toFront()

		-- Set stage focus to this piece
		--
		target.isFocus = true 
		display.currentStage:setFocus( target )
		target.x0 = x
		target.y0 = y

	elseif( target.isFocus ) then

	    -- 2. We're dragging the piece. Make it move exactly where our finger goes.
		--
		if(event.phase == "moved") then  
			--target.x = target.x0 + event.x - event.xStart
			--target.y = target.y0 + event.y - event.yStart
			centerDrag( target, event )


		-- The piece has been dropped
		--
		elseif(event.phase == "ended") then  
		
			-- Release focus and clear focus flag
			target.isFocus = true 
			display.currentStage:setFocus( nil )

			-- 2. Check to see if the piece was dropped close enough to its solved position.
			--
			-- Calculate the distance between drop and piece's solved position
			--
			-- Length == Rectangular Root of dx * dx + dy * dy, where 	
			--
			--  < dx, dy > == < x1, y1 > - < x2, y2 >
			-- 
			local dx  = target.x - target.solvedX
			local dy  = target.y - target.solvedY
			local len = math.sqrt( dx * dx + dy * dy )

			print("Dropped distance: ", len )

			if( len <= minSnapDistance ) then

				-- Snap to solved position
				target.x = target.solvedX
				target.y = target.solvedY

				-- Mark piece as solved
				target.solved = true
			else

				-- 3. If the piece is over the 'piece tray' shrink it, re-rotate it, and snap it back
				-- to its original inTray position.

				local left   = piecesTray.x - piecesTray.contentWidth/2
				local top    = piecesTray.y - piecesTray.contentHeight/2
				local width  = piecesTray.contentWidth
				local height = piecesTray.contentHeight

				if( pointInRect( x, y, top, left, width, height ) ) then

					-- --[[  Send piece back to tray immediately
					target.rotation = target.inTrayAngle
			
					target.xScale = 0.5
					target.yScale = 0.5

					target.x = target.inTrayX
					target.y = target.inTrayY
					-- --]]

					-- Tip: This piece of code is nicer than immediately snapping, but 
					-- a little more complicated.  Check out the transition functions
					-- over at the CoronaLabs.Com site to learn more about this:
					--
					-- http://docs.coronalabs.com/api/library/transition/index.html
					-- 
					--[[
					-- Transition back to original tray position
					transition.to( target, 
						{ 
							x        = target.inTrayX,
							y        = target.inTrayY,
							rotation = target.inTrayAngle,
							xScale	 = 0.5,
							yScale   = 0.5,
							time     = 100,
						} 
					)
					--]]

				end			
			end
		else
			return false
		end

		-- 4. (See notes at top of function).

		-- 5. Check to see if puzzle was solved
		if( isSolved() ) then
			-- Yay! Show the "Solved!" message
			-- 
			gameStatusMsg.isVisible = true
		end

	end

	return true
end

----------------------------------------------------------------------
-- 5. Execution  - Now that we have written all the code, let's call
--                 our functions and run the game!
----------------------------------------------------------------------
drawBoard()
placePieces()
movePiecesToTray()