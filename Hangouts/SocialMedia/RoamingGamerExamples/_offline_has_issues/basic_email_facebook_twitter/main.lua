-- =============================================================
-- Copyright Roaming Gamer, LLC. 2009-2015
-- =============================================================
display.setStatusBar(display.HiddenStatusBar)  
io.output():setvbuf("no") -- Don't use buffer for console messages
-- =============================================================
-- IGNORE CODE ABOVE THIS LINE
-- =============================================================
local native_popup = require "native_popup"

require "scripts.pushButtonClass"
require "scripts.toggleButtonClass"

local w = display.contentWidth
local h = display.contentHeight
local centerX = display.contentCenterX
local centerY = display.contentCenterY


-- =============================================================
-- EFM
-- =============================================================
local function sendEmail()

	native_popup.email( "Test Message", -- Title
		                "Hello this is a test.",  -- Message
		                true, -- Is HTML
		                { "test@gmail.com", "test2@gmail.com" }, -- To addresses
		                { "test3@gmail.com", "test4@gmail.com" }, -- CC addresses
		                { -- Attachments
		                  { filename = "rg.png", baseDir = system.ResourceDir }, 
		                  { filename = "smiley.png", baseDir = system.ResourceDir } 
		                }
		              )
end

-- =============================================================
-- EFM
-- =============================================================
local function tweet()
	native_popup.twitter( "Hello this is a test tweet.", -- Message
		                  "http://www.roaminggamer.com/",  -- URL
		                  { -- Images
		                    { filename = "rg.png", baseDir = system.ResourceDir },
		                    { filename = "smiley.png", baseDir = system.ResourceDir } 
		                  }
		                )
end

-- =============================================================
-- EFM
-- =============================================================
local function postFB()
	native_popup.facebook( "Hello this is a test tweet.", -- Message
		                   "http://www.roaminggamer.com/",  -- URL
		                   { -- Images
		                     { filename = "rg.png", baseDir = system.ResourceDir },
		                     { filename = "smiley.png", baseDir = system.ResourceDir }
		                   }
		                 )

end

-- =============================================================
-- EFM
-- =============================================================
local function share()
	native_popup.facebook( "Hello this is a test share.", -- Message
		                   "http://www.roaminggamer.com/",  -- URL
		                   { -- Images
		                     { filename = "rg.png", baseDir = system.ResourceDir },
		                     { filename = "smiley.png", baseDir = system.ResourceDir }
		                   }
		                 )

end


-- =============================================================
-- EFM
-- =============================================================
-- Create some buttons to run specific functions
PushButton( sceneGroup, centerX, centerY - 75, "e-mail", sendEmail, { labelColor = {0,1,0}, labelSize = 18 } )
PushButton( sceneGroup, centerX, centerY - 25, "Share", share, { labelColor = {0,1,0}, labelSize = 18 } )
PushButton( sceneGroup, centerX, centerY + 25, "Facebook", postFB, { labelColor = {0,1,0}, labelSize = 18 } )
PushButton( sceneGroup, centerX, centerY + 75, "Twitter", tweet, { labelColor = {0,1,0}, labelSize = 18 } )


