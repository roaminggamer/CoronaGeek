

-- display.remove( func ) - Replacement that works in tandem with 'isValid'
--
display._remove = display.remove
display.remove = function ( obj )
	if( not obj ) then return end
	display._remove( obj )
	obj.__destroyed = true
end

-- display.remove( func ) - Replacement that works in tandem with 'isValid'
--
display.isValid = function ( obj )
	return( obj and not obj.__destroyed )
end

-- removeWithDelay( func ) - Remove an object in the next frame
--
function display.removeWithDelay( obj, delay )
    delay = delay or 1    
    timer.performWithDelay(delay, 
        function() 
            display.remove( obj )
        end )
end
