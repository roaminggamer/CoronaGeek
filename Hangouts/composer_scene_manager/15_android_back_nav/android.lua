-- =============================================================
-- Written by Roaming Gamer, LLC. 
-- =============================================================
--
-- Permission is hereby granted, free of charge, to any person obtaining
-- a copy of this software and associated documentation files (the
-- "Software"), to deal in the Software without restriction, including
-- without limitation the rights to use, copy, modify, merge, publish,
-- distribute, sublicense, and/or sell copies of the Software, and to
-- permit persons to whom the Software is furnished to do so, subject to
-- the following conditions:
--
-- The above copyright notice and this permission notice shall be
-- included in all copies or substantial portions of the Software.
--
-- THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
-- EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
-- MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
-- IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
-- CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
-- TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
-- SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
--
-- [ MIT license: http://www.opensource.org/licenses/mit-license.php ]
--
-- =============================================================

local android = {}
function android.new( params )
    params = params or { onBack = nil, onExit = nil, debugEn = false  }
    params.title = params.title or "Exit?"
    params.msg = params.msg or "Are you sure?"
    local function exitApp()
        local alert
        alert = native.showAlert( params.title, params.msg, { "NO", "YES" }, onComplete )
        local function onComplete( event )
            if "clicked" == event.action then
                local i = event.index
                if 1 == i then
                    native.cancelAlert( alert )
                    alert = nil
                elseif 2 == i then
                    if( params.onExit ) then params.onExit() end
                    native.requestExit()
                end                        
            end
        end            
    end
    local handler = {}
    function handler.key( self, event )
        local phase = event.phase
        local keyName = event.keyName
        if( (keyName == "back") and (phase == "down") ) then 
            if( params.onBack ) then
                params.onBack()
            else
                exitApp()                
            end
        elseif( params.debugEn and (keyName == "escape") and (phase == "up") ) then 
            if( params.onBack ) then
                params.onBack()
            else
                exitApp()                
            end
        end
        return true
    end
    function handler.activate( self )
        timer.performWithDelay( 1,
            function()
                Runtime:addEventListener( "key", self )
            end )
    end
    function handler.deactivate( self )
        Runtime:removeEventListener( "key", self )
    end
    return handler
end

return android