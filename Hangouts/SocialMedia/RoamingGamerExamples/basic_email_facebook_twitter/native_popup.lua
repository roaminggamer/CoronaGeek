-- =============================================================
-- Copyright Roaming Gamer, LLC. 2009-2015
-- =============================================================
-- Basic Social Media Functionality via native.popup() and,
-- (in some cases) social plugin.
-- =============================================================
-- 								License
-- =============================================================
-- You may use the contents of this file however you wish.
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
-- Module Begins Here
-- =============================================================
local public = {}

local function twitterListener( event )
	table.dump( event )
	if(event and event.action == "sent" ) then 
		print("AWESOME!  Successfully tweeted!")

	elseif(event and event.action == "cancelled" ) then 
		print("DARN!  You cancelled the tweet.")
	end
end

local function shareListener( event )
	table.dump( event )
	if(event and event.action == "sent" ) then 
		print("AWESOME!  Successfully shared!")

	elseif(event and event.action == "cancelled" ) then 
		print("NOPE!  You cancelled the share.")
	end
end

local function facebookListener( event )
	table.dump( event )
	if(event and event.action == "sent" ) then 
		print("AWESOME!  Successfully posted to Facebook!")

	elseif(event and event.action == "cancelled" ) then 
		print("NOPE!  You cancelled the post to faceBook.")
	end
end

local function genericListener(event)
	table.dump(event)
end

function public.share( msg, url, image )
	if ( not native.canShowPopup( "social", "share" ) ) then
		print("Cannot open social feature?")
		return 
	end
	local options = 
	{
		service  = "share",
		message  = msg,
		url      = url,
		image    = image,
		listener = shareListener,
	}
	native.showPopup( "social", options )
end


function public.facebook( msg, url, image )
	if ( not native.canShowPopup( "social", "facebook" ) ) then
		print("Cannot open social feature?")
		return 
	end
	local options = 
	{
		service  = "facebook",
		message  = msg,
		url      = url,
		image    = image,
		listener = facebookListener,
	}
	native.showPopup( "social", options )
end



function public.twitter( msg, url, image )
	if ( not native.canShowPopup( "social", "twitter" ) ) then
		print("Cannot open social feature?")
		return 
	end

	local options = 
	{
	   	service  = "twitter",
	   	message  = msg,
	   	url      = url,
	   	image    = image,
		listener = twitterListener,
	}
	native.showPopup( "social", options )
end


function public.email( subject, msg, isBodyHtml, to, cc, attachment )
	local isBodyHtml = isBodyHtml or false
	if( isBodyHtml ) then
		msg = "<html><body>" .. msg .. "</body></html>"
	end
	if( type(to) == "string" ) then
		to = { to }
	end

	if( type(cc) == "string" ) then
		cc = { cc }
	end

	local options =
	{
		to = to,
		cc = cc,
		subject = subject,
		isBodyHtml = isBodyHtml,
		body = msg,
		listener = genericListener,
		attachment = attachment,
	}
	native.showPopup("mail", options)		
	return true
end


return public