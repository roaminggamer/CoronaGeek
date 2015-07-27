local shareButton -- will define later

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