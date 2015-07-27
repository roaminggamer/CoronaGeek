
local widget = require( "widget" )


function widget.newPanel( options )

    local customOptions = options or {}
    local opt = {}
    opt.location = customOptions.location or "top"
    local default_width, default_height
	 
    if ( opt.location == "top" or opt.location == "bottom" ) then
        default_width = display.contentWidth
        default_height = display.contentHeight * 0.33
    else
        default_width = display.contentWidth * 0.33
        default_height = display.contentHeight
    end
    opt.width = customOptions.width or default_width
    opt.height = customOptions.height or default_height
    opt.speed = customOptions.speed or 500
    opt.inEasing = customOptions.inEasing or easing.linear
    opt.outEasing = customOptions.outEasing or easing.linear
	 
    if ( customOptions.onComplete and type(customOptions.onComplete) == "function" ) then
        opt.listener = customOptions.onComplete
    else 
        opt.listener = nil
    end
	 
    local container = display.newContainer( opt.width, opt.height )
	 
    if ( opt.location == "left" ) then
        container.anchorX = 1.0
        container.x = display.screenOriginX
        container.anchorY = 0.5
        container.y = display.contentCenterY
    elseif ( opt.location == "right" ) then
        container.anchorX = 0.0
        container.x = display.actualContentWidth
        container.anchorY = 0.5
        container.y = display.contentCenterY
    elseif ( opt.location == "top" ) then
        container.anchorX = 0.5
        container.x = display.contentCenterX
        container.anchorY = 1.0
        container.y = display.screenOriginY
    else
        container.anchorX = 0.5
        container.x = display.contentCenterX
        container.anchorY = 0.0
        container.y = display.actualContentHeight
    end
	 
    function container:show()
        local options = {
            time = opt.speed,
            transition = opt.inEasing
        }
        if ( opt.listener ) then
            options.onComplete = opt.listener
            self.completeState = "shown"
        end
        if ( opt.location == "top" ) then
            options.y = display.screenOriginY + opt.height
        elseif ( opt.location == "bottom" ) then
            options.y = display.actualContentHeight - opt.height
        elseif ( opt.location == "left" ) then
            options.x = display.screenOriginX + opt.width
        else
            options.x = display.actualContentWidth - opt.width
        end 
        transition.to( self, options )
    end
	 
    function container:hide()
        local options = {
            time = opt.speed,
            transition = opt.outEasing
        }
        if ( opt.listener ) then
            options.onComplete = opt.listener
            self.completeState = "hidden"
        end
        if ( opt.location == "top" ) then
            options.y = display.screenOriginY
        elseif ( opt.location == "bottom" ) then
            options.y = display.actualContentHeight
        elseif ( opt.location == "left" ) then
            options.x = display.screenOriginX
        else
            options.x = display.actualContentWidth
        end 
        transition.to( self, options )
    end
	 
    return container
end


function widget.newSharingPanel()
    local function onRowRender( event )
        local row = event.row
        local id = row.index
        local params = event.row.params

        if row.isCategory then
            row.text = display.newText("Share", 0, 0, native.systemFont, 14)
            row.text:setFillColor( 0.67 )
            row.text.x = display.contentCenterX
            row.text.y = row.contentHeight * 0.5
            row:insert(row.text)
        else
            row.text = display.newText(params.label, 0, 0, native.systemFont, 18)
            row.text:setFillColor( 0.5, 0.5, 1.0 )
            row.text.x = display.contentCenterX
            row.text.y = row.contentHeight * 0.5
            row:insert(row.text)
        end

    end
    local function onRowTouch( event )
        local popupName = event.row.params.popupName
        local service = event.row.params.service

        if popupName == nil then -- the cancel button
            local myPanel = event.row.params.parent
            myPanel:hide()
            return true
        end

        if popupName == "mail" then
            native.showPopup( popupName, 
            {
                body = event.row.params.body,
                attachment = event.row.params.attachment,
            })
        elseif popupName == "sms" then
            native.showPopup( popupName, 
            {
                body = event.row.params.body,
            })
        elseif popupName == "social" then
            local isAvailable = native.canShowPopup( popupName, event.row.params.service )
            if isAvailable then
                native.showPopup( popupName, 
                {
                    service = event.row.params.service,
                    message = event.row.params.message,
                    image = event.row.params.image,
                    url = event.row.params.url
                })
            else
                if system.getInfo("environment") == "simulator" then
                    native.showAlert( "Build for device", "This plugin is not supported on the Corona Simulator, please build for an iOS/Android device or the Xcode simulator", { "OK" } )
                else
                    -- Popup is not available.. Show error message
                    native.showAlert( "Cannot send " .. event.row.params.service .. " message.", "Please setup your " .. event.row.params.service .. " account or check your network connection (on android this means that the package/app (i.e. Twitter) is not installed on the device)", { "OK" } )
                end
            end
        end

        return true
    end

    local panel = widget.newPanel({
        location = "bottom",
        width = display.contentWidth,
        height = 240,
        speed = 500,
		  inEasing = easing.outCubic,
		  outEasing = easing.outCubic
    })

    local tableView = widget.newTableView({
        top = 0, 
        left = 0,
        width = display.contentWidth - 16, 
        height = 240, 
        backgroundColor = { 0.9 }, 
        noLines = true,
        onRowRender = onRowRender,
        onRowTouch = onRowTouch 
    })
    tableView.x = 0
    tableView.y = 0

    panel:insert( tableView )
    tableView:insertRow{
        rowHeight = 40,
        isCategory = true,
        rowColor = { 1, 1, 1 },
    }
    tableView:insertRow{
        rowHeight = 40,
        isCategory = false,
        rowColor = { 1, 1, 1 },
        params = {
            popupName = "social",
            service = "facebook",
            label = "Facebook",
            message = "Some text to post to facebook",
            image = nil,  -- See the native.showPopup("social") plugin for image parameters.
            url = nil,    -- See the native.showPopup("social") plugin for url parameters.
        }
    }
    tableView:insertRow{
        rowHeight = 40,
        isCategory = false,
        rowColor = { 1, 1, 1 },
        params = {
            popupName = "social",
            service = "twitter",
            label = "Twitter",
            message = "Some text to post to twitter",
            image = nil,  -- See the native.showPopup("social") plugin for image parameters.
            url = nil,    -- See the native.showPopup("social") plugin for url parameters.
        }
    }
    tableView:insertRow{
        rowHeight = 40,
        isCategory = false,
        rowColor = { 1, 1, 1 },
        params = {
            popupName = "mail",
            label = "Email",
            body = "Some text to email",
            attachment = nil, -- See the native.showPopup("mail") API for attachment parameters.
        }
    }
    tableView:insertRow{
        rowHeight = 40,
        isCategory = false,
        rowColor = { 1, 1, 1 },
        params = {
            popupName = "sms",
            label = "Message",
            body = "Some text to text",
        }
    }
    tableView:insertRow{
        rowHeight = 40,
        isCategory = false,
        rowColor = { 1, 1, 1 },
        params = {
            label = "Cancel",
            parent = panel
        }
    }
    return panel
end


local sharePanel = widget.newSharingPanel()

sharePanel:show()

--[[
local function hideIt()
	sharePanel:hide()
end
timer.performWithDelay( 2000, hideIt )
]]
