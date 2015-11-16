-- =============================================================
-- Copyright Roaming Gamer, LLC. 2009-2015 
-- =============================================================
-- This content produced for Corona Geek Hangouts audience.
-- You may use any and all contents in this example to make a game or app.
-- =============================================================
local public = {}

local physics 			   = require "physics"
local common 			   = require "scripts.common"

-- Makers (builder)
local layersMaker		   = require "scripts.layersMaker"
local lostGarden		   = require "scripts.lostGarden"

-- Localizations
local mRand             = math.random
local getTimer          = system.getTimer
local pairs             = pairs

function public.showPlayerMovementLimit()
   local layers = layersMaker.get()
   
   local width = common.rightLimit - common.leftLimit
   local height = common.downLimit - common.upLimit
   
   local limit = display.newRect( layers.underlay, common.centerX, common.centerY, width, height )
   limit:setFillColor(0,0,0,0)
   limit:setStrokeColor(1,0,0)
   limit.strokeWidth = 4
   
   local viewLimit = display.newRect( layers.underlay, common.centerX, common.centerY, width * 3, height * 3 )
   viewLimit:setFillColor(0,0,0,0)
   viewLimit:setStrokeColor(1,0,1)
   viewLimit.strokeWidth = 3
end

return public