local onFacebook6
local onTwitter5
local onTwitter6
local onMail

local function twitterListener( event )
	table.print_r( event )
	if(event and event.action == "sent") then 
		print("AWESOME!  Successfully tweeted!  90 more seconds for you!")

	elseif(event and event.action == "cancelled") then 
		print("NOPE!  You cancelled the tweet.  No 90 seconds for you!")
	end
end

local function facebookListener( event )
	table.print_r( event )
	if(event and event.action == "sent") then 
		print("AWESOME!  Successfully posted to Facebook!  90 more seconds for you!")

	elseif(event and event.action == "cancelled") then 
		print("NOPE!  You cancelled the post to faceBook.  No 90 seconds for you!")
	end
end



local function genericListener( event )
	table.dump( event )
end

local platVer = tonumber(string.sub(system.getInfo("platformVersion"),1,1)) or 1

onFacebook6 = function( msg, url )
	print("In onFacebook6 can show popup?", native.canShowPopup( "facebook" ))
	local msg = msg or "Test Twitter Msg"

	local options = {
		service = "facebook",
		message = msg,
		url = url,
		listener = facebookListener,
	}
	native.showPopup( "social", options )
end

onTwitter5 = function( msg )
	local msg = msg or "Test Twitter Msg"

	local options = {
   		message = msg,
   		listener = twitterListener,
	}
	native.showPopup( "twitter", options )
end


onTwitter6 = function( msg, url )
	local msg = msg or "Test Twitter Msg"

	local options = {
	   	service = "twitter",
	   	message = msg,
	   	url = url,
		listener = twitterListener,
	}
	native.showPopup( "social", options )
end

--[[
 -- Worked! Requires 5+

	--if( oniOS ) then 
		local options = {
	   		message = msg
		}
		native.showPopup( "twitter", options )
	--end

-- Worked! (for iOS and sort of for Android) Requires 6+
		local options = {
		   service = "twitter",
		   message = msg,
		   url = "http://mobileapps.reelfx.com/reelfx/shaving-face"
		}
		native.showPopup( "social", options )

-- Worked! (for iOS but not for Android) Requires 6+

		local options = {
		   service = "facebook",
		   message = msg,
		   url = "http://mobileapps.reelfx.com/reelfx/shaving-face"
		}
		native.showPopup( "social", options )
--]]



onMail = function( subject, msg, isBodyHtml, to, attachment )

	local isBodyHtml = isBodyHtml or false
	if( isBodyHtml ) then
		msg = "<html><body>" .. msg .. "</body></html>"
	end
	local to = to
	if( type(to) == "string" ) then
		to = { to }
	end

	local options =
	{
		to = to,
		subject = subject,
		isBodyHtml = isBodyHtml,
		body = msg,
		listener = genericListener,
		attachment = attachment,
	}
	native.showPopup("mail", options)		
	return true
end


local function dummyFB() print("Facebook not supported on this platform/OS version yet.") end
local function dummyTwitter() print("Twitter not supported on this platform/OS version yet.") end
local function dummyEmail() print("E-mail not supported on this platform/OS version yet.") end


local RGEasySocial = {}

if( oniOS and platVer >= 6 ) then
	print(">>>>>>>> RGEasySocial: oniOS and platVer >= 6")
	RGEasySocial.onFacebook = onFacebook6
	RGEasySocial.onTwitter = onTwitter6
	RGEasySocial.onEmail = onMail

elseif( oniOS and platVer >= 5 ) then
	print(">>>>>>>> RGEasySocial: oniOS and platVer >= 5")
	RGEasySocial.onFacebook = dummyFB
	RGEasySocial.onTwitter = onTwitter5
	RGEasySocial.onEmail = onMail

elseif( onAndroid ) then
	print(">>>>>>>> RGEasySocial: onAndroid")
	RGEasySocial.onFacebook = dummyFB
	RGEasySocial.onTwitter = onTwitter6
	RGEasySocial.onEmail = onMail
else
	print(">>>>>>>> RGEasySocial: Other")
	RGEasySocial.onFacebook = dummyFB
	RGEasySocial.onTwitter = dummyTwitter
	RGEasySocial.onEmail = onMail
end	

if( not _G.ssk ) then
	_G.ssk = {}
end

if( not ssk.social ) then
	ssk.social = RGEasySocial
end

return RGEasySocial