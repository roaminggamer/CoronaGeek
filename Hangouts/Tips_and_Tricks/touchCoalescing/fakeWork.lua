local fakeWork = {}

local getTimer = system.getTimer

function fakeWork.run( duration )
    duration = duration or 5
    local count = 0
    local began = getTimer()
    while( getTimer() - began < duration ) do 
    	count = count + 1
    end    
    print(count)
end

function fakeWork.run2( maxCount )
    maxCount = maxCount or 2 * 1e5
    local count = 1
    local began = getTimer()
    while( count < maxCount ) do 
    	count = count + 1
    	math.sqrt( count )
    end    
    --print(count)    
end


return fakeWork