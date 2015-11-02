--
-- created with TexturePacker (http://www.codeandweb.com/texturepacker)
--
-- $TexturePacker:SmartUpdate:100779d7aa73edbe09f033c8302b1305:ad0a354485f12aaf68d4b30210237838:92884f4926f66802db5324436e58d5aa$
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
            -- white lasercannon0000
            x=2,
            y=2,
            width=64,
            height=80,

        },
        {
            -- white lasercannon0001
            x=2,
            y=84,
            width=64,
            height=80,

        },
        {
            -- white lasercannon0002
            x=2,
            y=166,
            width=64,
            height=80,

        },
        {
            -- white lasercannon0003
            x=68,
            y=2,
            width=64,
            height=80,

        },
        {
            -- white lasercannon0004
            x=68,
            y=84,
            width=64,
            height=80,

        },
        {
            -- white lasercannon0005
            x=68,
            y=166,
            width=64,
            height=80,

        },
        {
            -- white lasercannon0006
            x=134,
            y=2,
            width=64,
            height=80,

        },
        {
            -- white lasercannon0007
            x=134,
            y=84,
            width=64,
            height=80,

        },
        {
            -- white lasercannon0008
            x=134,
            y=166,
            width=64,
            height=80,

        },
        {
            -- white lasercannon0009
            x=200,
            y=2,
            width=64,
            height=80,

        },
        {
            -- white lasercannon0010
            x=200,
            y=84,
            width=64,
            height=80,

        },
        {
            -- white lasercannon0011
            x=200,
            y=166,
            width=64,
            height=80,

        },
        {
            -- white lasercannon0012
            x=266,
            y=2,
            width=64,
            height=80,

        },
        {
            -- white lasercannon0013
            x=266,
            y=84,
            width=64,
            height=80,

        },
        {
            -- white lasercannon0014
            x=266,
            y=166,
            width=64,
            height=80,

        },
        {
            -- white lasercannon0015
            x=332,
            y=2,
            width=64,
            height=80,

        },
        {
            -- white lasercannon0016
            x=332,
            y=84,
            width=64,
            height=80,

        },
        {
            -- white lasercannon0017
            x=332,
            y=166,
            width=64,
            height=80,

        },
        {
            -- white lasercannon0018
            x=398,
            y=2,
            width=64,
            height=80,

        },
        {
            -- white lasercannon0019
            x=398,
            y=84,
            width=64,
            height=80,

        },
        {
            -- white lasercannon0020
            x=398,
            y=166,
            width=64,
            height=80,

        },
        {
            -- white lasercannon0021
            x=464,
            y=2,
            width=64,
            height=80,

        },
        {
            -- white lasercannon0022
            x=464,
            y=84,
            width=64,
            height=80,

        },
        {
            -- white lasercannon0023
            x=464,
            y=166,
            width=64,
            height=80,

        },
        {
            -- white lasercannon0024
            x=530,
            y=2,
            width=64,
            height=80,

        },
        {
            -- white lasercannon0025
            x=596,
            y=2,
            width=64,
            height=80,

        },
        {
            -- white lasercannon0026
            x=662,
            y=2,
            width=64,
            height=80,

        },
        {
            -- white lasercannon0027
            x=530,
            y=84,
            width=64,
            height=80,

        },
        {
            -- white lasercannon0028
            x=530,
            y=166,
            width=64,
            height=80,

        },
        {
            -- white lasercannon0029
            x=596,
            y=84,
            width=64,
            height=80,

        },
        {
            -- white lasercannon0030
            x=596,
            y=166,
            width=64,
            height=80,

        },
        {
            -- white lasercannon0031
            x=662,
            y=84,
            width=64,
            height=80,

        },
    },
    
    sheetContentWidth = 728,
    sheetContentHeight = 248
}

SheetInfo.frameIndex =
{

    ["white lasercannon0000"] = 1,
    ["white lasercannon0001"] = 2,
    ["white lasercannon0002"] = 3,
    ["white lasercannon0003"] = 4,
    ["white lasercannon0004"] = 5,
    ["white lasercannon0005"] = 6,
    ["white lasercannon0006"] = 7,
    ["white lasercannon0007"] = 8,
    ["white lasercannon0008"] = 9,
    ["white lasercannon0009"] = 10,
    ["white lasercannon0010"] = 11,
    ["white lasercannon0011"] = 12,
    ["white lasercannon0012"] = 13,
    ["white lasercannon0013"] = 14,
    ["white lasercannon0014"] = 15,
    ["white lasercannon0015"] = 16,
    ["white lasercannon0016"] = 17,
    ["white lasercannon0017"] = 18,
    ["white lasercannon0018"] = 19,
    ["white lasercannon0019"] = 20,
    ["white lasercannon0020"] = 21,
    ["white lasercannon0021"] = 22,
    ["white lasercannon0022"] = 23,
    ["white lasercannon0023"] = 24,
    ["white lasercannon0024"] = 25,
    ["white lasercannon0025"] = 26,
    ["white lasercannon0026"] = 27,
    ["white lasercannon0027"] = 28,
    ["white lasercannon0028"] = 29,
    ["white lasercannon0029"] = 30,
    ["white lasercannon0030"] = 31,
    ["white lasercannon0031"] = 32,
}

function SheetInfo:getSheet()
    return self.sheet;
end

function SheetInfo:getFrameIndex(name)
    return self.frameIndex[name];
end

return SheetInfo
