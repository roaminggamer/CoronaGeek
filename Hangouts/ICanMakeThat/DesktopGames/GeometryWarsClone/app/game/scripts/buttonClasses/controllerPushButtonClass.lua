class = require 'scripts.buttonClasses.30log'
require "scripts.buttonClasses.pushButtonClass"


ControllerPushButton = PushButton:extends()
ControllerPushButton.__name = 'ControllerPushButton'

function ControllerPushButton:touch( event )
	local target = event.target 
	local id 	 = event.id
	local phase  = event.phase
	if( phase == "began" ) then
		display.currentStage:setFocus( target, id )
		self.isFocus 				= true
		self.initiallySelected 		= self.selected
		self.selected 				= true
		self.unselRect.isVisible 	= not self.unselRect.isVisible
		self.selRect.isVisible 		= not self.selRect.isVisible

	
	elseif( self.isFocus ) then
		local bounds = target.stageBounds
		local x,y = event.x, event.y
		local isWithinBounds = 
			bounds.xMin <= x and bounds.xMax >= x and bounds.yMin <= y and bounds.yMax >= y

		if( isWithinBounds ) then
			self.unselRect.isVisible 	= self.initiallySelected
			self.selRect.isVisible 		= not self.initiallySelected
		else
			self.unselRect.isVisible 	= not self.initiallySelected
			self.selRect.isVisible 		= self.initiallySelected
		end

		if( phase == "moved" ) then
			-- Do nothing for push-button
		elseif( phase == "ended" or phase == cancelled ) then
			display.currentStage:setFocus( target, nil )
			self.isFocus 				= nil
			if( isWithinBounds and self.listener ) then
				self.selected 				= not self.initiallySelected
				self.unselRect.isVisible 	= self.initiallySelected
				self.selRect.isVisible 		= not self.initiallySelected
				self:listener( event )
			else
				self.selected 				= self.initiallySelected
				self.unselRect.isVisible 	= not self.initiallySelected
				self.selRect.isVisible 		= self.initiallySelected
			end
		end
	end
	return true
end

function ControllerPushButton:select( isSelected )	
   if( isSelected ) then
      self.unselRect.isVisible 	= false
      self.selRect.isVisible 		= true
   else
      self.unselRect.isVisible 	= true
      self.selRect.isVisible 		= false
   end
   self._isSelected = isSelected
end

function ControllerPushButton:selectNext( )	
   print( "Next", self.myName, self.__nextButton.myName )
   self:select( false )
   self.__nextButton:select( true )   
end

function ControllerPushButton:selectPrev( )
	
   print( "Prev", self.myName, self.__prevButton.myName )
   self:select( false )
   self.__prevButton:select( true )
end

function ControllerPushButton:setNext( nextButton, noAutoPrev )
   self.__nextButton = nextButton
   if( not noAutoPrev ) then
      nextButton:setPrev( self, true )
   end
end

function ControllerPushButton:setPrev( prevButton, noAutoNext )
   self.__prevButton = prevButton
   if( not noAutoNext ) then
      prevButton:setNext( self, true )
   end
end


function ControllerPushButton:enableKeys( enable )	
   self._keysEnabled = (enable == nil) and true or enable
end


function ControllerPushButton:toggle()	
   self:listener()
end



function ControllerPushButton:draw( group, x, y, labelText, listener, params)	
   params = params or {  }
   params.nextKey    = params.nextKey or "down"
   params.prevKey    = params.prevKey or "up"
   params.pressKey   = params.pressKey or "buttonA"
         
   self._keysEnabled = true
   
   self.myName = params.myName
   
   function self.key( self, event )     
      --table.dump(event)
      if( not self._keysEnabled ) then return false end
      if( not self._isSelected ) then return false end
      
      
      if( event.phase == "down" ) then         
         if( event.keyName == params.nextKey ) then
            --print( event.keyName, params.nextKey )
            timer.performWithDelay( 1, 
               function()
                  self:selectNext()
               end )
            
         elseif( event.keyName == params.prevKey ) then
            timer.performWithDelay( 1, 
               function()
                  self:selectPrev()
               end )
         
         elseif( event.keyName == params.pressKey ) then
            timer.performWithDelay( 1, 
               function()
                  self:toggle()
               end )
            
         end
      end
      
      return false      
   end 
   Runtime:addEventListener( "key", self )
   
   self.super.draw( self, group, x, y, labelText, listener, params)
end

