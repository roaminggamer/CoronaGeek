-- =============================================================
-- Copyright Roaming Gamer, LLC. 2009-2015
-- =============================================================
-- Facebook Graph Library Examples
-- =============================================================
-- 								License
-- =============================================================
-- You may use the contents of this file however you wish.
-- =============================================================
--[[
		Useful Links:
		+ https://docs.coronalabs.com/daily/api/library/facebook/index.html
		+ https://docs.coronalabs.com/daily/guide/social/implementFacebook/index.html#facebook
		+ https://docs.coronalabs.com/daily/guide/social/setupFacebook/index.html 
		+ https://docs.coronalabs.com/daily/plugin/facebook/login.html
		+ https://docs.coronalabs.com/daily/plugin/facebook/request.html
		+ https://docs.coronalabs.com/plugin/facebook/showDialog.html
			+ https://developers.facebook.com/docs/javascript/reference/FB.ui
		+ http://stackoverflow.com/questions/23850807/get-all-user-friends-using-facebook-graph-api-android
		+ http://stackoverflow.com/questions/23417356/facebook-graph-api-v2-0-me-friends-returns-empty-or-only-friends-who-also-u
		+ https://coronalabs.com/blog/2014/01/14/tutorial-getting-facebook-friends-the-easy-way/

		+ https://developers.facebook.com/
		+ https://developers.facebook.com/docs/facebook-login/permissions/v2.4
		+ https://developers.facebook.com/docs/graph-api/using-graph-api/v2.4
		+ https://developers.facebook.com/docs/graph-api/reference/
		+ https://developers.facebook.com/docs/javascript/reference/FB.ui
		+ https://developers.facebook.com/tools/explorer/
]]
display.setStatusBar(display.HiddenStatusBar)  
io.output():setvbuf("no") -- Don't use buffer for console messages
-- =============================================================
-- IGNORE CODE ABOVE THIS LINE
-- =============================================================
-- =============================================================
-- Utility Functions
-- =============================================================
-- Table dumper
local function rpad(str, len, char)
	local theStr = str; if char == nil then char = ' ' end; return theStr .. string.rep(char, len - #theStr)
end
table.dump = table.dump or function (theTable, padding, marker )
	marker = marker or "";local theTable = theTable or {};
	local function compare(a,b) return tostring(a) < tostring(b) end
	local tmp = {};  for n in pairs(theTable) do table.insert(tmp, n) end;  table.sort(tmp,compare)
	local padding = padding or 30; print("\Table Dump:"); print("-----")
	if(#tmp > 0) then 
		for i,n in ipairs(tmp) do
			local key = tmp[i]; local value = tostring(theTable[key]);local keyType = type(key)
			local valueType = type(value);local keyString = tostring(key) .. " (" .. keyType .. ")";
			local valueString = tostring(value) .. " (" .. valueType .. ")";
			keyString = rpad(keyString,padding); valueString = rpad(valueString,padding);
			print( keyString .. " == " .. valueString );
		end
	else print("empty") end; print( marker .. "-----\n")
end

-- =============================================================
-- Example Begins Here
-- =============================================================
local json 				= require "json"
local facebook 			= require("facebook")
local facebookAppID 	= "YOUR_ID_HERE" 

require "scripts.pushButtonClass"
require "scripts.toggleButtonClass"
local w = display.contentWidth
local h = display.contentHeight
local centerX = display.contentCenterX
local centerY = display.contentCenterY


local function listener( event )
	--table.dump(event)

    print( "event.name", event.name )  
    print( "event.type:", event.type ) --type is either "session", "request", or "dialog"
    print( "isError: " .. tostring( event.isError ) )
    print( "didComplete: " .. tostring( event.didComplete ) )

    local response = event.response
    if( response and string.len( response ) > 0 ) then
    	response = json.decode( response )
    	table.dump(response, nil, "------------ Facebook Response Dump")
    	print("----------------------------------------")
    	if( response.data ) then
    		for i = 1, #response.data do
    			print( "\nFacebook Response", i)
    	 		local entry = response.data[i]
    			table.dump(entry)
    			if( entry.picture ) then
    				table.dump( entry.picture )
    			end
    		end
    	end
    	print("----------------------------------------\n\n")
    end

    --"session" events cover various login/logout events
    --"request" events handle calls to various Graph API calls
    --"dialog" events are standard popup boxes that can be displayed

    if ( "session" == event.type ) then
        --options are: "login", "loginFailed", "loginCancelled", or "logout"
        if ( "login" == event.phase ) then
            local access_token = event.token
            --code for tasks following a successful login
        end

    elseif ( "request" == event.type ) then
        print("facebook request")
        if ( not event.isError ) then
            local response = json.decode( event.response )
            --process response data here
        end

    elseif ( "dialog" == event.type ) then
        print( "dialog", event.response )
        --handle dialog results here
    end
end

-- =============================================================
-- Example Facebook Plugin Calls
-- =============================================================

local function login()
	print("\n\nAttempting to login to facebook", facebookAppID)
	facebook.login( facebookAppID, listener, { "user_friends" } )
end


local function simpleDirectPost()
	print("\n\nAttempting to post message")
	facebook.request( "me/feed", "POST", { message="Test facebook post using Graph library.",  } ) 
end


local function complexDirectPost()
	print("\n\nAttempting to post complex message")
	facebook.request( "me/feed", "POST", 
		{ 
			message="Test complex facebook post using Graph library.",  
		    source = {
		        baseDir=system.ResourceDirectory, 
		        filename="rg.png",
		        type="image"
		    }
		} ) 
end


local function getMe()
	print("\n\nAttempting to get details about 'me'")
	facebook.request( "me", "GET" )
end


local function getFriendsList() -- Only friends using the app?
	print("\n\nAttempting to get friends list")
	facebook.request( "me/friends", "GET" )
end


local function getTaggableFriendsList() -- Only friends using the app?
	print("\n\nAttempting to get taggable friends list")
	facebook.request( "me/taggable_friends", "GET" )
end


local function showFeedDialog()
	print("\n\nAttempting to open a post dialog.")

	facebook.showDialog( "feed", 
		{ 
			name 		= "Test Facebook Post Title",
			link 		= "http://roaminggamer.com/",
			caption 	= "Test Facebook Dialog Caption",
			description = "Test Facebook Message",

			-- Picture NOT working... :(
		    picture = 
		    {
		        baseDir		= system.ResourceDirectory, 
		        filename 	= "smiley.png",
		        type 		= "image"
		    };
			ref 		= "12345"  
		} 
	)
end


-- =============================================================
-- Create some buttons to run specific functions
-- =============================================================

local buttonActions = {}
buttonActions[1] = { "Log In", login }
buttonActions[2] = { "Simple direct post", simpleDirectPost }
buttonActions[3] = { "Complex direct post ", complexDirectPost }
buttonActions[4] = { "Get User Details", getMe }
buttonActions[5] = { "Get Friend (wrong)", getFriendsList }
buttonActions[6] = { "Get Friends (right)", getTaggableFriendsList }
buttonActions[7] = { "Feed Dialog", showFeedDialog }

for i = 1, #buttonActions do
	PushButton( sceneGroup, centerX, centerY - 200 + i * 50, buttonActions[i][1], buttonActions[i][2], 
		{ labelColor = {0,1,0}, labelSize = 18, width = 250 } )
end

