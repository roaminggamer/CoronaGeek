-- =============================================================
-- Copyright Roaming Gamer, LLC. 2009-2015 
-- =============================================================
-- This content produced for Corona Geek Hangouts audience.
-- You may use any and all contents in this example to make a game or app.
-- =============================================================
local joyTest = {}

local gamePad  = require "scripts.gamePad" 
local math2d   = require "plugin.math2d"

-- Localizations
local mRand             = math.random
local getTimer          = system.getTimer
local pairs             = pairs
local isValid           = display.isValid

local addVec			   = math2d.add
local subVec			   = math2d.sub
local diffVec			   = math2d.diff
local lenVec			   = math2d.length
local len2Vec			   = math2d.length2
local normVec			   = math2d.normalize
local vector2Angle		= math2d.vector2Angle
local angle2Vector		= math2d.angle2Vector
local scaleVec			   = math2d.scale


local function onGamePad( event )
   --table.dump(event)
end
listen( "onJoystick", onGamePad )
listen( "onGamePad", onGamePad )


local function onJoystick( self, event )
   self.ax     = event.x
   self.ay     = event.y
   
   local vec   = { x = self.ax, y = self.ay }
   
   vec         = scaleVec( vec, 40 )
   self.x      = self.x0 + vec.x
   self.y      = self.y0 + vec.y
end


local lOuter = display.newCircle( centerX - 150, centerY, 80 ) 
lOuter:setFillColor(0,0,0,0)
lOuter:setStrokeColor(1,1,0)
lOuter.strokeWidth = 3

local lInner = display.newCircle( lOuter.x, lOuter.y, 40 ) 
lInner.zeroFill = { 1, 0, 0, 0.5 }
lInner:setFillColor( unpack(lInner.zeroFill) )
lInner:setStrokeColor(0,1,1)
lInner.strokeWidth = 3

lInner.x0 = lInner.x
lInner.y0 = lInner.y
lInner.onLeftJoystick = onJoystick
listen( "onLeftJoystick", lInner )

local rOuter = display.newCircle( centerX + 150, centerY, 80 ) 
rOuter:setFillColor(0,0,0,0)
rOuter:setStrokeColor(1,1,0)
rOuter.strokeWidth = 3

local rInner = display.newCircle( rOuter.x, rOuter.y, 40 ) 
rInner.zeroFill = { 0, 1, 0, 0.5 }
rInner:setFillColor( unpack(rInner.zeroFill) )
rInner:setStrokeColor(0,1,1)
rInner.strokeWidth = 3

rInner.x0 = rInner.x
rInner.y0 = rInner.y
rInner.onRightJoystick = onJoystick
listen( "onRightJoystick", rInner )

return joyTest