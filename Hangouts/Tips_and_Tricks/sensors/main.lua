--require("mobdebug").start() -- ZeroBrane Users
-- =============================================================
-- Copyright Roaming Gamer, LLC. 2009-2015 
-- =============================================================
-- This content produced for Corona Geek Hangouts audience.
-- You may use any and all contents in this example to make a game or app.
-- =============================================================
display.setStatusBar(display.HiddenStatusBar)  
io.output():setvbuf("no") 


local physics = require "physics"
physics.start()

local sensors = {}

local function onCollision( self, event )
   if( event.phase == "began" ) then
      self.canSpawn = false
      self:setFillColor(1,0,0)
   elseif( event.phase == "ended" ) then
      self.canSpawn = true
      self:setFillColor(0,1,0)
   end
   return false
end

local function newSensor( x, y, size )
   local tmp = display.newRect( x, y, size, size )
   tmp.canSpawn = true
   tmp:setFillColor(0,1,0)
   tmp.alpha = 0.15

   -- Add body 
   physics.addBody( tmp, "static", { isSensor = true } )

   -- Add collision listener
   tmp.collision = onCollision
   tmp:addEventListener("collision")

   -- Store reference to sensor in sensors table
   sensors[#sensors+1] = tmp
end

newSensor( display.contentCenterX - 50,  display.contentCenterY - 50, 100 )
newSensor( display.contentCenterX + 50,  display.contentCenterY - 50, 100 )
newSensor( display.contentCenterX - 50,  display.contentCenterY + 50, 100 )
newSensor( display.contentCenterX + 50,  display.contentCenterY + 50, 100 )


local aHUD = display.newText( #sensors, display.contentCenterX, display.contentCenterY - 120, native.systemFont, 22 )
aHUD.enterFrame = function( self )
   local count = 0
   for i = 1, #sensors do
      if(sensors[i].canSpawn) then
         count = count + 1
      end
   end
   self.text = count
end
Runtime:addEventListener( "enterFrame", aHUD )


local obj = display.newImageRect( "smiley.png", 32, 32 )
obj.x = display.contentCenterX
obj.y = display.contentCenterY
physics.addBody( obj, "dynamic", { radius = 16 } )
obj.gravityScale = 0
obj.touch = function( self, event )
   self.x = event.x
   self.y = event.y
end
obj:addEventListener( "touch" )