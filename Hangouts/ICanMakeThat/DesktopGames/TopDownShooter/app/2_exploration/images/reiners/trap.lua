--
-- created with TexturePacker (http://www.codeandweb.com/texturepacker)
--
-- $TexturePacker:SmartUpdate:7c6aabbe8e36213efc9bdf8ff90ba230:805eef0a28a2e49095fea0766acc801e:49d4495d11e66dc5f1ae7bea08ff4930$
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
            -- drehfalle kolllisionsstein
            x=2,
            y=2,
            width=128,
            height=128,

        },
        {
            -- stachelkopf0000
            x=2,
            y=132,
            width=128,
            height=128,

        },
        {
            -- stachelkopf0001
            x=2,
            y=262,
            width=128,
            height=128,

        },
        {
            -- stachelkopf0002
            x=132,
            y=2,
            width=128,
            height=128,

        },
        {
            -- stachelkopf0003
            x=132,
            y=132,
            width=128,
            height=128,

        },
        {
            -- stachelkopf0004
            x=132,
            y=262,
            width=128,
            height=128,

        },
        {
            -- stachelkopf0005
            x=262,
            y=2,
            width=128,
            height=128,

        },
        {
            -- stachelkopf0006
            x=262,
            y=132,
            width=128,
            height=128,

        },
        {
            -- stachelkopf0007
            x=262,
            y=262,
            width=128,
            height=128,

        },
        {
            -- stachelkopf0008
            x=392,
            y=2,
            width=128,
            height=128,

        },
        {
            -- stachelkopf0009
            x=392,
            y=132,
            width=128,
            height=128,

        },
        {
            -- stachelkopf0010
            x=392,
            y=262,
            width=128,
            height=128,

        },
        {
            -- stachelkopf0011
            x=522,
            y=2,
            width=128,
            height=128,

        },
        {
            -- stachelkopf0012
            x=652,
            y=2,
            width=128,
            height=128,

        },
        {
            -- stachelkopf0013
            x=522,
            y=132,
            width=128,
            height=128,

        },
        {
            -- stachelkopf0014
            x=522,
            y=262,
            width=128,
            height=128,

        },
        {
            -- stachelkopf0015
            x=652,
            y=132,
            width=128,
            height=128,

        },
        {
            -- stachelkopf0016
            x=2,
            y=132,
            width=128,
            height=128,

        },
    },
    
    sheetContentWidth = 782,
    sheetContentHeight = 392
}

SheetInfo.frameIndex =
{

    ["drehfalle kolllisionsstein"] = 1,
    ["stachelkopf0000"] = 2,
    ["stachelkopf0001"] = 3,
    ["stachelkopf0002"] = 4,
    ["stachelkopf0003"] = 5,
    ["stachelkopf0004"] = 6,
    ["stachelkopf0005"] = 7,
    ["stachelkopf0006"] = 8,
    ["stachelkopf0007"] = 9,
    ["stachelkopf0008"] = 10,
    ["stachelkopf0009"] = 11,
    ["stachelkopf0010"] = 12,
    ["stachelkopf0011"] = 13,
    ["stachelkopf0012"] = 14,
    ["stachelkopf0013"] = 15,
    ["stachelkopf0014"] = 16,
    ["stachelkopf0015"] = 17,
    ["stachelkopf0016"] = 18,
}

function SheetInfo:getSheet()
    return self.sheet;
end

function SheetInfo:getFrameIndex(name)
    return self.frameIndex[name];
end

return SheetInfo
