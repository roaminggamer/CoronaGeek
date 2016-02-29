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
    local blockSize     = 16
    local textureSize   = 80
    
    local startX    = left + blockSize/2
    local startY    = bottom - 10.5 * blockSize
    local curX      = startX
    local curY      = startY

    -- Variables used for filling
    local col       = 0
    local row       = 3
    local fillScale = textureSize/blockSize
    local fillOffsetMultiple = 1/fillScale       
    print(fillScale, fillOffsetMultiple )

    -- Enable texture wrapping
    display.setDefault( "textureWrapX", "repeat" )
    display.setDefault( "textureWrapY", "repeat" )

    -- Lay out blocks in columns and rows till we hit bottom right corner of screen
    while( curX < right and curY < bottom ) do

        local tmp = display.newRect( curX, curY, blockSize, blockSize )
        --tmp:setStrokeColor(1,1,0)
        --tmp.strokeWidth = 1

        tmp.x = curX
        tmp.y = curY


        -- Fill With dirt texture
        tmp.fill = { type = "image", filename="dirt.png" }

        -- Scale the fill
        
        tmp.fill.scaleX = fillScale
        tmp.fill.scaleY = fillScale

        -- Offset the fill
        
        tmp.fill.x = fillOffsetMultiple * col
        tmp.fill.y = fillOffsetMultiple * row

        -- Add a static body
        physics.addBody( tmp, "static", { friction=0.5, bounce=0.3 } )

        curX = curX + blockSize

        -- Adjust fill column for offsetting
        col = col + 1
        if( col * fillOffsetMultiple > 1 ) then 
            col = 0            
        end        

        if( curX >= right  ) then
            curY = curY + blockSize

            -- Adjust fill column and row for offsetting
            col = 0
            row = row + 1
            if( row * fillOffsetMultiple > 1 ) then
                row = 0
            end

            if(curY < bottom) then
                curX = startX
            end
        end
   end

   -- Disable texture wrapping
   display.setDefault( "textureWrapX", "clamToEdge" )
   display.setDefault( "textureWrapY", "clamToEdge" )
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
            display.remove( event.other )
            display.remove( self )

            return false
        end
        ballBomb:addEventListener( "collision" )
    end
end

-- 1. Draw a background
local back = display.newImageRect( "back.png", w, h )
back.x = cx
back.y = cy

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