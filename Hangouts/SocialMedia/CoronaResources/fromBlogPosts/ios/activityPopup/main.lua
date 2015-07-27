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
		+ Activity Popup (on iOS) - http://coronalabs.com/blog/2015/03/17/tutorial-utilizing-the-activity-popup-plugin-ios/
]]
display.setStatusBar(display.HiddenStatusBar)  
io.output():setvbuf("no") -- Don't use buffer for console messages
-- =============================================================
-- IGNORE CODE ABOVE THIS LINE
-- =============================================================

local shareButton -- will define later

local items =
{
	{ type = "image", value = { filename = "Icon.png", baseDir = system.ResourceDirectory, } },
	{ type = "string", value = "Hello, World" },
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

-- Not Using this snippet (getting error)
--[[ 
widget = require( "widget" )
shareButton = widget.newButton({
	label = "Share",
	onRelease = showShare,
})
shareButton.x = display.contentCenterX
shareButton.y = display.contentCenterY
--]]

-- Replaces above snippet w/ single button
require "scripts.pushButtonClass"
require "scripts.toggleButtonClass"
local w = display.contentWidth
local h = display.contentHeight
local centerX = display.contentCenterX
local centerY = display.contentCenterY
shareButton = PushButton( sceneGroup, centerX, centerY, "Share", showShare,  { labelColor = {0,1,0}, labelSize = 18, width = 250 } )
