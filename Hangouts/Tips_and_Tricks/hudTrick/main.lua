--require("mobdebug").start() -- ZeroBrane Users
-- =============================================================
-- Copyright Roaming Gamer, LLC. 2009-2016
-- =============================================================
-- This content produced for Corona Geek Hangouts audience.
-- You may use any and all contents in this example to make a game or app.
-- =============================================================
display.setStatusBar(display.HiddenStatusBar)  
io.output():setvbuf("no") 

--
-- Basic Version
--
local function newHUD( x, y )
   -- Enable wrapping
   display.setDefault( "textureWrapX", "repeat" )
   
   -- Create the HUD image
   local aHUD = display.newRect( x, y, 32, 32 )
   aHUD.fill = { type="image", filename = "smiley.png" }

   aHUD.strokeWidth = 2

   --aHUD.fill.x = -0.2



   -- Set wrapping back to default value.
   display.setDefault( "textureWrapX", "clampToEdge" )

   -- Set the initial value
   aHUD.value = 1
   
   function aHUD.setValue( self, value )
      self.value = value

      if( self.value == 0 ) then 
         self.isVisible = false
      else
         -- Show the HUD in case it was hidden
         self.isVisible = true

         -- Set x-Scale to value
         self.xScale = self.value

         --Update the fill scale accordingly to retain visible scale         
         aHUD.fill.scaleX = 1/aHUD.xScale
         
         -- Adjust fill offset based on whether scale is odd or even
         if( aHUD.xScale % 2 == 0 ) then
            aHUD.fill.x = 0.5
         else 
            aHUD.fill.x = 0
         end
      end
   end

   function aHUD.getValue( self ) 
      return self.value
   end
   
   return aHUD
end

--
-- Version with Limit
--
local function newHUD2( x, y, limit )
   -- Enable wrapping
   display.setDefault( "textureWrapX", "repeat" )
   
   -- Create the HUD image
   local aHUD = display.newRect( x, y, 32, 32 )
   aHUD.fill = { type="image", filename = "smiley.png" }

   -- Set wrapping back to default value.
   display.setDefault( "textureWrapX", "clampToEdge" )

   -- Set the initial value
   aHUD.value = 1
   aHUD.limit = limit

   -- Add a Text object for counting past the limit
   aHUD.label = display.newText( 1, x, y, native.systemFont, 32 )
   aHUD.label.isVisible = false
   aHUD.label.x = aHUD.x - aHUD.contentWidth/2 - 5
   aHUD.label.anchorX = 1
   --aHUD.label.x = aHUD.x + aHUD.contentWidth/2 + 5
   --aHUD.label.anchorX = 0

   
   function aHUD.setValue( self, value )
      self.value = value
      self.label.text = value

      if( self.value == 0 ) then 
         self.isVisible = true
         self.label.isVisible = true

      elseif( self.value > self.limit ) then
         self.xScale = 1
         aHUD.fill.scaleX = 1
         aHUD.fill.x = 0

         self.isVisible = true
         self.label.isVisible = true
      else
         self.label.isVisible = false
         self.isVisible = true
         
         self.xScale = self.value
         aHUD.fill.scaleX = 1/aHUD.xScale
         if( aHUD.xScale % 2 == 0 ) then
            aHUD.fill.x = 0.5
         else 
            aHUD.fill.x = 0
         end
      end
   end

   function aHUD.getValue( self ) 
      return self.value
   end
   
   return aHUD
end   

local hud1 = newHUD( display.contentCenterX, 50 )

local hud2 = newHUD( display.contentCenterX, 100 )
hud2.anchorX = 1

local hud3 = newHUD( display.contentCenterX, 150 )
hud3.anchorX = 0

local hud4 = newHUD2( display.contentCenterX, 200, 3 )

--
-- Simple code to demo huds in action
--
local curValue = 1


local function onTouch( event )
   if( event.phase == "began" ) then
      curValue = curValue + 1
      if( curValue > 6 ) then
         curValue = 0
      end
      hud1:setValue( curValue )
      hud2:setValue( curValue )
      hud3:setValue( curValue )
      hud4:setValue( curValue )
   end
end

Runtime:addEventListener( "touch", onTouch  )

