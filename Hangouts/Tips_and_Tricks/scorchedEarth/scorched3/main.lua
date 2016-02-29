--
-- Poor Man's Destroyable Environment (ala Scorched Earth)
--

--
-- Shorthand helper variables
--
local w      = display.actualContentWidth
local h      = display.actualContentHeight
local cx     = display.contentCenterX
local cy     = display.contentCenterY
local left   = cx - w/2
local right  = cx + w/2
local top    = cy - h/2
local bottom = cy + h/2

-- Simple meters (FPS and memory)
local meter = require "meter"


local physics = require "physics"
physics.start()
physics.setDrawMode("hybrid")

-- Table of tables to hold references to our 'ground blocks'
local columns = {}

--
-- Function to add bodies to 'top layer' of ground
--
local function attachBodies()
    for k,v in pairs(columns) do
        -- Note: Y values higher on the screen are smaller than the ones below them.
        -- i.e. Y increases downward.
        local highest = math.huge 
        local block  
        for l,m in pairs( v ) do
            if( m.y < highest ) then
                highest = m.y
                block = m 
            end
        end

        -- Add a body to the block if it doesn't have one.        
        if( block and not block.hasBody ) then
            --block:setFillColor(0.5,0,0)
            block.hasBody = true
            physics.addBody( block, "static", { friction=0.5, bounce=0.3 } )
        end
    end
end


--
-- Function to build 'ground' out of destructable blocks
--
local function buildGround()
    local blockSize     = 8
    local curX          = left + blockSize/2
    local curY          = bottom - 20.5 * blockSize
    local lastStartY    = curY

    -- Lay out column by column
    while( curX < right ) do
        -- Adjust our starting y by [-2,2] from last starting y
        --
        curY = lastStartY + math.random(-12,12)
        lastStartY = curY

        local curColumn = {}
        columns[curColumn] = curColumn

        -- Build the column
        while( curY <= bottom + blockSize) do
            local tmp = display.newRect( curX, curY, blockSize, blockSize )
            tmp:setFillColor( 0, 0.5, 0 )

            -- Make note of this block's current column
            tmp.myColumn = curColumn

            -- Just shove this object in it's column table
            curColumn[tmp] = tmp
            curY = curY + blockSize
        end
        curX = curX + blockSize
    end

    attachBodies()
end


--
-- Touch listener to drop a ball or bomb
--
local function dropBallBomb( event )
    local ballBombRadius = 10

    -- Ignore all but 'began' phase
    if( event.phase ~= "ended" ) then return false end


    -- Bomb or ball?
    local isBomb = ( event.y < cy )

    local ballBomb = display.newCircle( event.x, event.y, ballBombRadius )


    -- Make it red if it is a bomb
    if( isBomb ) then 
        ballBomb:setFillColor( 30, 0 , 0 )
        ballBomb.isBomb = true
    else 
        ballBomb.isBall = true
    end


    -- If this is not a bomb, remove it from the game in 10 seconds
    if( not isBomb ) then 
        timer.performWithDelay( 10000, function() display.remove( ballBomb ) end )
    end


    -- Add a body
    physics.addBody( ballBomb, "dynamic", { friction=0.5, bounce=0.3, radius = ballBombRadius } )

    
    -- If this is a bomb, add a 'collision' listener to destroy the bomb and what it hits
    if( isBomb ) then
        -- Add a 'collision' listener
        function ballBomb.collision( self, event )
            if (event.phase ~= "began" ) then return false end

            -- Ignore hits on other bombs
            if( event.other.isBomb ) then return end

            -- If this is a block, then remove if from
            -- the column of tables it is being tracked in.
            if( not event.other.isBall ) then            
                event.other.myColumn[event.other] = nil
            end

            -- destroy the block/nball
            display.remove( event.other )

            -- remove the bomb that did the damage
            display.remove( self )

            -- Wait till next frame and add bodies to newly exposed 'column heads'
            timer.performWithDelay(1, attachBodies )
            return false
        end
        ballBomb:addEventListener( "collision" )
    end
end


-- 1. Draw the ground
buildGround()

-- 2. Draw a line to indicate the bomb/ball divide (touch above for a bomb)
local bombLine = display.newLine( left, cy, right, cy )
bombLine:setStrokeColor(1,0,0)
bombLine.strokeWidth = 6

-- 3. Start listening for touches
Runtime:addEventListener( "touch", dropBallBomb )

-- Meters for debug purposes only
meter.create_fps()
meter.create_mem()