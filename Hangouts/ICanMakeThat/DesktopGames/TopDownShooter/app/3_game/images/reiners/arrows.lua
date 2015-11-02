--
-- created with TexturePacker (http://www.codeandweb.com/texturepacker)
--
-- $TexturePacker:SmartUpdate:9757d04a7e4de95c8dcde558bf9ae87d:ad7ea9b14cf648b1be11bbcbe8bcc9eb:9ec3029cfa2d8fb68c0907400c512fae$
--
-- local sheetInfo = require("mysheet")
-- local myImageSheet = graphics.newImageSheet( "mysheet.png", sheetInfo:getSheet() )
-- local sprite = display.newSprite( myImageSheet , {frames={sheetInfo:getFrameIndex("sprite")}} )
--

local SheetInfo = {}

SheetInfo.sheet =
{
    frames = {
    
        {
            -- pfeil mit schatten0000
            x=2,
            y=2,
            width=32,
            height=64,

        },
        {
            -- pfeil mit schatten0001
            x=36,
            y=2,
            width=32,
            height=64,

        },
        {
            -- pfeil mit schatten0002
            x=70,
            y=2,
            width=32,
            height=64,

        },
        {
            -- pfeil mit schatten0003
            x=2,
            y=68,
            width=32,
            height=64,

        },
        {
            -- pfeil mit schatten0004
            x=36,
            y=68,
            width=32,
            height=64,

        },
        {
            -- pfeil mit schatten0005
            x=70,
            y=68,
            width=32,
            height=64,

        },
        {
            -- pfeil mit schatten0006
            x=2,
            y=134,
            width=32,
            height=64,

        },
        {
            -- pfeil mit schatten0007
            x=36,
            y=134,
            width=32,
            height=64,

        },
        {
            -- pfeil mit schatten0008
            x=70,
            y=134,
            width=32,
            height=64,

        },
        {
            -- pfeil mit schatten0009
            x=2,
            y=200,
            width=32,
            height=64,

        },
        {
            -- pfeil mit schatten0010
            x=36,
            y=200,
            width=32,
            height=64,

        },
        {
            -- pfeil mit schatten0011
            x=70,
            y=200,
            width=32,
            height=64,

        },
        {
            -- pfeil mit schatten0012
            x=2,
            y=266,
            width=32,
            height=64,

        },
        {
            -- pfeil mit schatten0013
            x=36,
            y=266,
            width=32,
            height=64,

        },
        {
            -- pfeil mit schatten0014
            x=70,
            y=266,
            width=32,
            height=64,

        },
        {
            -- pfeil mit schatten0015
            x=2,
            y=332,
            width=32,
            height=64,

        },
        {
            -- pfeil mit schatten0016
            x=36,
            y=332,
            width=32,
            height=64,

        },
        {
            -- pfeil mit schatten0017
            x=70,
            y=332,
            width=32,
            height=64,

        },
        {
            -- pfeil mit schatten0018
            x=2,
            y=398,
            width=32,
            height=64,

        },
        {
            -- pfeil mit schatten0019
            x=36,
            y=398,
            width=32,
            height=64,

        },
        {
            -- pfeil mit schatten0020
            x=70,
            y=398,
            width=32,
            height=64,

        },
        {
            -- pfeil mit schatten0021
            x=2,
            y=464,
            width=32,
            height=64,

        },
        {
            -- pfeil mit schatten0022
            x=36,
            y=464,
            width=32,
            height=64,

        },
        {
            -- pfeil mit schatten0023
            x=70,
            y=464,
            width=32,
            height=64,

        },
        {
            -- pfeil mit schatten0024
            x=2,
            y=530,
            width=32,
            height=64,

        },
        {
            -- pfeil mit schatten0025
            x=36,
            y=530,
            width=32,
            height=64,

        },
        {
            -- pfeil mit schatten0026
            x=70,
            y=530,
            width=32,
            height=64,

        },
        {
            -- pfeil mit schatten0027
            x=2,
            y=596,
            width=32,
            height=64,

        },
        {
            -- pfeil mit schatten0028
            x=2,
            y=662,
            width=32,
            height=64,

        },
        {
            -- pfeil mit schatten0029
            x=36,
            y=596,
            width=32,
            height=64,

        },
        {
            -- pfeil mit schatten0030
            x=36,
            y=662,
            width=32,
            height=64,

        },
        {
            -- pfeil mit schatten0031
            x=70,
            y=596,
            width=32,
            height=64,

        },
    },
    
    sheetContentWidth = 104,
    sheetContentHeight = 728
}

SheetInfo.frameIndex =
{

    ["pfeil mit schatten0000"] = 1,
    ["pfeil mit schatten0001"] = 2,
    ["pfeil mit schatten0002"] = 3,
    ["pfeil mit schatten0003"] = 4,
    ["pfeil mit schatten0004"] = 5,
    ["pfeil mit schatten0005"] = 6,
    ["pfeil mit schatten0006"] = 7,
    ["pfeil mit schatten0007"] = 8,
    ["pfeil mit schatten0008"] = 9,
    ["pfeil mit schatten0009"] = 10,
    ["pfeil mit schatten0010"] = 11,
    ["pfeil mit schatten0011"] = 12,
    ["pfeil mit schatten0012"] = 13,
    ["pfeil mit schatten0013"] = 14,
    ["pfeil mit schatten0014"] = 15,
    ["pfeil mit schatten0015"] = 16,
    ["pfeil mit schatten0016"] = 17,
    ["pfeil mit schatten0017"] = 18,
    ["pfeil mit schatten0018"] = 19,
    ["pfeil mit schatten0019"] = 20,
    ["pfeil mit schatten0020"] = 21,
    ["pfeil mit schatten0021"] = 22,
    ["pfeil mit schatten0022"] = 23,
    ["pfeil mit schatten0023"] = 24,
    ["pfeil mit schatten0024"] = 25,
    ["pfeil mit schatten0025"] = 26,
    ["pfeil mit schatten0026"] = 27,
    ["pfeil mit schatten0027"] = 28,
    ["pfeil mit schatten0028"] = 29,
    ["pfeil mit schatten0029"] = 30,
    ["pfeil mit schatten0030"] = 31,
    ["pfeil mit schatten0031"] = 32,
}

function SheetInfo:getSheet()
    return self.sheet;
end

function SheetInfo:getFrameIndex(name)
    return self.frameIndex[name];
end

return SheetInfo
