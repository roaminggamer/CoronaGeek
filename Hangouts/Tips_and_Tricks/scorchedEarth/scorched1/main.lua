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


--
-- Function to build 'ground' out of destructable blocks
--
local function buildGround()
    local blockSize = 20
    local startX    = left + blockSize/2
    local startY    = bottom - 10.5 * blockSize
    local curX      = startX
    local curY      = startY
   
    -- Lay out blocks in columns and rows till we hit bottom right corner of screen
    while( curX < right and curY < bottom ) do
        local tmp = display.newRect( curX, curY, blockSize, blockSize )
        tmp:setFillColor( 0, 0.5, 0 )
        tmp:setStrokeColor(1,1,0)
        tmp.strokeWidth = 1

        -- Add a static body
        physics.addBody( tmp, "static", { friction=0.5, bounce=0.3 } )

        curX = curX + blockSize
        if( curX >= right  ) then
            curY = curY + blockSize
            if(curY < bottom) then
                curX = startX
            end
        end
   end
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
        ballBomb:setFillColor( 1, 0 , 0 )        
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

            -- Destroy object we hit and the bomb itself
            self:removeEventListener( "collision" )
            display.remove( event.other )
            display.remove( self )

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