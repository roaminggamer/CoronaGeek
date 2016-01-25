--require("mobdebug").start() -- ZeroBrane Users
-- =============================================================
-- Copyright Roaming Gamer, LLC. 2009-2016 
-- =============================================================
-- This content produced for Corona Geek Hangouts audience.
-- You may use any and all contents in this example to make a game or app.
-- =============================================================
display.setStatusBar(display.HiddenStatusBar)  
io.output():setvbuf("no") 

-- Include SSK Core (Features I just can't live without.)
require("ssk_core.globals.variables")
require("ssk_core.globals.functions")
require("ssk_core.extensions.display")
require("ssk_core.extensions.io")
require("ssk_core.extensions.math")
require("ssk_core.extensions.string")
require("ssk_core.extensions.table")
require("ssk_core.extensions.transition_color")

local meter = require "meter"
meter.create_fps()
meter.create_mem()

--
--  Example control code starts here...
--

local particleMgr = require "particleMgr"


local function runTest( style, instances, useCaching )
   --print(style,instances,useCaching)
   local mRand = math.random
   local objects

   local curFrame = 0

   function onEnterFrame()
      if( curFrame % 2 == 0 ) then
         --print("\nCREATING", curFrame)
         objects = {}
         for i = 1, instances do      
            local obj = particleMgr.get( style, useCaching )
            obj:setFillColor( mRand(), mRand(), mRand() )
            obj.x = mRand( left + 10, right - 10 )
            obj.y = mRand( top + 10, bottom - 10 )
            objects[#objects+1] = obj
         end
      else
         --print("\nDESTROYING", curFrame)
         for i = 1, #objects do
            objects[i]:release()
         end
         objects = nil
      end


      curFrame = curFrame + 1
   end
   Runtime:addEventListener( "enterFrame", onEnterFrame )
end

--
-- Buttons To Select style, count, and caching (pressing this starts example)
--

local styleButtons = display.newGroup()
local countButtons = display.newGroup()
local runButtons   = display.newGroup()

local curStyle    = 1
local curCount    = 100
local useCaching  = true

local function onTouchStyle( self, event )
   if( event.phase == "ended") then
      curStyle = self.style
      display.remove( styleButtons )
   end
   return true
end

local function onTouchCount( self, event )
   if( event.phase == "ended") then
      curCount = self.count
      display.remove( countButtons )
   end
   return true
end


local function onTouchGo( self, event )
   if( event.phase == "ended") then
      useCaching = self.useCaching
      display.remove( runButtons )
      runTest( curStyle, curCount, useCaching )
   end
   return true
end


-- Style 'Buttons'
for i = 1, 4 do
   local button = display.newText( styleButtons, i, left + i * 60, top + 200, native.systemFont, 36 )
   button.style = i 
   button:setFillColor(1,0,0)
   button.touch = onTouchStyle
   button:addEventListener("touch")
end

-- Count 'Buttons'
local last 
for i = 1, 15 do
   local button = display.newText( countButtons, i * 100, left + i * 50, top + 300, native.systemFont, 24 )
   button.count = i * 100
   if( last ) then
      button.x = last.x + last.contentWidth/2 + 20 + button.contentWidth/2
   end   
   button.touch = onTouchCount
   button:setFillColor(0,1,0)
   button:addEventListener("touch")
   last = button

end

-- Run/Cache 'Buttons'
local button = display.newText( runButtons, "Use Caching", left + 200 , top + 400, native.systemFont, 24 )
button:setFillColor(1,1,0)
button.touch = onTouchGo
button:addEventListener("touch")
button.useCaching = true

local button = display.newText( runButtons, "No Caching", left + 400 , top + 400, native.systemFont, 24 )
button:setFillColor(1,0,1)
button.touch = onTouchGo
button:addEventListener("touch")
button.useCaching = false

--timer.performWithDelay( 2000, function() runTest( 1, 750, true ) end )
--timer.performWithDelay( 2000, function() runTest( 1, 750, false ) end )
