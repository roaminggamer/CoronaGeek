--
-- created with TexturePacker (http://www.codeandweb.com/texturepacker)
--
-- $TexturePacker:SmartUpdate:08eb611d8946ce6aaba154a6a24c2e04:bf493b847224f98e24996b146855db1c:10e38abeffdc5c6762e0dc0bdf12893d$
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
            -- mousetrap front 0000
            x=2,
            y=2,
            width=64,
            height=64,

        },
        {
            -- mousetrap front 0001
            x=68,
            y=2,
            width=64,
            height=64,

        },
        {
            -- mousetrap front 0002
            x=134,
            y=2,
            width=64,
            height=64,

        },
        {
            -- mousetrap front 0003
            x=200,
            y=2,
            width=64,
            height=64,

        },
        {
            -- mousetrap front 0004
            x=266,
            y=2,
            width=64,
            height=64,

        },
        {
            -- mousetrap front 0005
            x=332,
            y=2,
            width=64,
            height=64,

        },
        {
            -- mousetrap front 0006
            x=398,
            y=2,
            width=64,
            height=64,

        },
        {
            -- mousetrap front 0007
            x=464,
            y=2,
            width=64,
            height=64,

        },
        {
            -- mousetrap front 0008
            x=530,
            y=2,
            width=64,
            height=64,

        },
        {
            -- mousetrap iso left 0000
            x=596,
            y=2,
            width=64,
            height=64,

        },
        {
            -- mousetrap iso left 0001
            x=662,
            y=2,
            width=64,
            height=64,

        },
        {
            -- mousetrap iso left 0002
            x=728,
            y=2,
            width=64,
            height=64,

        },
        {
            -- mousetrap iso left 0003
            x=794,
            y=2,
            width=64,
            height=64,

        },
        {
            -- mousetrap iso left 0004
            x=860,
            y=2,
            width=64,
            height=64,

        },
        {
            -- mousetrap iso left 0005
            x=926,
            y=2,
            width=64,
            height=64,

        },
        {
            -- mousetrap iso left 0006
            x=992,
            y=2,
            width=64,
            height=64,

        },
        {
            -- mousetrap iso left 0007
            x=1058,
            y=2,
            width=64,
            height=64,

        },
        {
            -- mousetrap iso left 0008
            x=1124,
            y=2,
            width=64,
            height=64,

        },
        {
            -- mousetrap iso right 0000
            x=1190,
            y=2,
            width=64,
            height=64,

        },
        {
            -- mousetrap iso right 0001
            x=1256,
            y=2,
            width=64,
            height=64,

        },
        {
            -- mousetrap iso right 0002
            x=1322,
            y=2,
            width=64,
            height=64,

        },
        {
            -- mousetrap iso right 0003
            x=1388,
            y=2,
            width=64,
            height=64,

        },
        {
            -- mousetrap iso right 0004
            x=1454,
            y=2,
            width=64,
            height=64,

        },
        {
            -- mousetrap iso right 0005
            x=1520,
            y=2,
            width=64,
            height=64,

        },
        {
            -- mousetrap iso right 0006
            x=1586,
            y=2,
            width=64,
            height=64,

        },
        {
            -- mousetrap iso right 0007
            x=1652,
            y=2,
            width=64,
            height=64,

        },
        {
            -- mousetrap iso right 0008
            x=1718,
            y=2,
            width=64,
            height=64,

        },
    },
    
    sheetContentWidth = 1784,
    sheetContentHeight = 68
}

SheetInfo.frameIndex =
{

    ["mousetrap front 0000"] = 1,
    ["mousetrap front 0001"] = 2,
    ["mousetrap front 0002"] = 3,
    ["mousetrap front 0003"] = 4,
    ["mousetrap front 0004"] = 5,
    ["mousetrap front 0005"] = 6,
    ["mousetrap front 0006"] = 7,
    ["mousetrap front 0007"] = 8,
    ["mousetrap front 0008"] = 9,
    ["mousetrap iso left 0000"] = 10,
    ["mousetrap iso left 0001"] = 11,
    ["mousetrap iso left 0002"] = 12,
    ["mousetrap iso left 0003"] = 13,
    ["mousetrap iso left 0004"] = 14,
    ["mousetrap iso left 0005"] = 15,
    ["mousetrap iso left 0006"] = 16,
    ["mousetrap iso left 0007"] = 17,
    ["mousetrap iso left 0008"] = 18,
    ["mousetrap iso right 0000"] = 19,
    ["mousetrap iso right 0001"] = 20,
    ["mousetrap iso right 0002"] = 21,
    ["mousetrap iso right 0003"] = 22,
    ["mousetrap iso right 0004"] = 23,
    ["mousetrap iso right 0005"] = 24,
    ["mousetrap iso right 0006"] = 25,
    ["mousetrap iso right 0007"] = 26,
    ["mousetrap iso right 0008"] = 27,
}

function SheetInfo:getSheet()
    return self.sheet;
end

function SheetInfo:getFrameIndex(name)
    return self.frameIndex[name];
end

return SheetInfo
