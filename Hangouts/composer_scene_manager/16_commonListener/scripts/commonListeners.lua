-- =============================================================
-- Rudimenatary Shared Button Listeners Example 
-- =============================================================
local composer 		= require( "composer" )

local dest1, dest2

local shared = {}

function shared.setDestinations( d1, d2 )
	dest1 = d1
	dest2 = d2
end

function shared.listener1( self, event )
	print(dest1)
	composer.gotoScene( "ifc." .. dest1 , { effect = "slideRight", time = 500 }  )	
end

function shared.listener2( self, event )
	print(dest2)
	composer.gotoScene( "ifc." .. dest2 , { effect = "slideLeft", time = 500 }  )	
end

return shared
