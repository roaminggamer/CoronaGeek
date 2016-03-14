--
-- 2D Math Library (same as plugin version, but included with project so you can see it)
--
local math2d = require "RGMath2D"

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


--
-- Common touch listner used for both pads to dispatch event 'onTouchSteer'
--
local function onPadTouch( self, event )
    local phase   = event.phase
    local touchID = event.id
    
    if( phase == "began" ) then
        display.getCurrentStage():setFocus( self, touchID )
        self.isFocus = true
        self.alpha = 0.2
        Runtime:dispatchEvent( { name = "onTouchSteer", steeringValue = self.steeringValue } )
    

    elseif( self.isFocus ) then
        if(phase == "ended" or phase == "cancelled") then
            display.getCurrentStage():setFocus( self, nil )
            self.isFocus = false

            self.alpha = 0.05
            Runtime:dispatchEvent( { name = "onTouchSteer", steeringValue = -self.steeringValue } )
        end     
    end
    return true
end

--
-- Function to make two touch objects (simple buttons) used for creating steering events.
--
local function makeSteeringPads()
    -- Left Steering Pad
    local leftPad = display.newImageRect( "fillW.png", w/2, h )
    leftPad.x = left
    leftPad.y = cy
    leftPad.anchorX = 0
    leftPad:setFillColor( 1, 0, 0 )
    leftPad.alpha = 0.05
    leftPad.steeringValue = -1
    leftPad.touch = onPadTouch
    leftPad:addEventListener("touch")

    -- Right Steering Pad
    local rightPad = display.newImageRect( "fillW.png", w/2, h )
    rightPad.x = right
    rightPad.y = cy
    rightPad.anchorX = 1
    rightPad:setFillColor( 0, 1, 0 )
    rightPad.alpha = 0.05
    rightPad.steeringValue = 1
    rightPad.touch = onPadTouch
    rightPad:addEventListener("touch")
end


--
-- Function to make rudimentary car
--
local function makeCar( x, y )
    --
    -- Logic Control Variables
    --
    local movePPS   = 200 -- Move at this many piexls-per-second
    local rotateDPS = 180 -- Rotate at this many degrees-per-second
    
    --
    -- Basic rectangle as our 'car'
    --
    local car = display.newRect( x, y, 15, 24 )
    car:setFillColor( 0, 1, 1 )

    --
    -- Start with an initial steering value of 0 (not steering/turning)
    --
    car.steeringValue = 0 
    car.lastTime = system.getTimer() -- Used to calculate consistent tween frame delta time

    
    -- Listen for enterFrame and on each frame apply a steering amount to the car
    --
    function car.enterFrame( self )
        -- Note: Frame times are not perfectly consistent so for smooth steering
        -- we need to calculate a delta time instead of assuming one.
        --        
        local curTime   = system.getTimer()
        local dt        = curTime - self.lastTime 
        self.lastTime = curTime
        dt = dt/1000

        -- Calculate the 'rotate by' and 'moveby' rates for this frame.
        local rotateBy  = dt * rotateDPS * self.steeringValue
        local moveBy    = dt * movePPS

        -- Rotate (steer) the car
        --self.rotation = self.rotation + rotateBy
        --if(self.rotation > 360) then self.rotation = self.rotation - 360 end
        --if(self.rotation < 0) then self.rotation = self.rotation + 360 end
        self.rotation = ( self.rotation + rotateBy ) % 360

        print(self.rotation)

        -- Move the car in the new facing direction by 'moveby' distance
        local vec = math2d.angle2Vector( self.rotation, true )
        vec = math2d.scale( vec, moveBy )
        self.x = self.x + vec.x
        self.y = self.y + vec.y
    end
    Runtime:addEventListener( "enterFrame", car );

    -- Create a custom event listener for 'onTouchSteer'
    --
    function car.onTouchSteer( self, event )
        self.steeringValue = self.steeringValue + event.steeringValue
    end
    Runtime:addEventListener( "onTouchSteer", car )

    return car
end


-- =================================================
-- Make Pads and Steerable Car
-- =================================================
makeSteeringPads()

makeCar( cx, bottom - 50 )

