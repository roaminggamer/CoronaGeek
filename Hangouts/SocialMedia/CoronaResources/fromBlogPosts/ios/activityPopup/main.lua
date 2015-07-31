-- =============================================================
-- Activity (Utility) Popup for iOS Example
-- =============================================================
--
-- Code extracted from Corona Blog Post and (slightly modified):
--
-- http://coronalabs.com/blog/2015/03/17/tutorial-utilizing-the-activity-popup-plugin-ios/
--
-- =============================================================
display.setStatusBar(display.HiddenStatusBar)  
io.output():setvbuf("no") -- Don't use buffer for console messages

local shareButton -- will define later

--
-- See this page for more details on following table:
-- http://docs.coronalabs.com/daily/plugin/CoronaProvider_native_popup_activity/showPopup.html
--
local items =
{
	{ type = "image", value = { filename = "smiley.png", baseDir = system.ResourceDirectory, } },
	{ type = "string", value = "Sharing on iOS via Activity Popup." },
	{ type = "string", value = "Some targets support text (Twitter)." },
	{ type = "string", value = "Some do not (Facebook)." },
	{ type = "url", value = "http://www.coronalabs.com" },
}

local function showShare()
	local popupName = "activity"
	local isAvailable = native.canShowPopup( popupName )
	local isSimulator = "simulator" == system.getInfo( "environment" )

	-- If it is possible to show the popup
	if isAvailable then
		local listener = {}
		function listener:popup( event )
			print( "name(" .. event.name .. ") type(" .. event.type .. ") activity(" .. tostring(event.activity) .. ") action(" .. tostring(event.action) .. ")" )
		end

		-- Show the popup
		native.showPopup( popupName,
		{
			items = items,
			-- excludedActivities = { "UIActivityTypeCopyToPasteboard", },
			listener = listener,
			origin = shareButton.contentBounds, 
			permittedArrowDirections={ "up", "down" }
		})
	else
		if isSimulator then
			native.showAlert( "Build for device", "This plugin is not supported on the Corona Simulator, please build for an iOS/Android device or the Xcode simulator", { "OK" } )
		else
			-- Popup isn't available.. Show error message
			native.showAlert( "Error", "Can't display the view controller. Are you running iOS 7 or later?", { "OK" } )
		end
	end
end

--
-- Show a 'Share' button in middle of screen.
--
local widget = require( "widget" )
shareButton = widget.newButton({
	label = "Share",
	onRelease = showShare,
})
shareButton.x = display.contentCenterX
shareButton.y = display.contentCenterY
