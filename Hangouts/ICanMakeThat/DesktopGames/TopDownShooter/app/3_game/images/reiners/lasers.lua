--
-- created with TexturePacker (http://www.codeandweb.com/texturepacker)
--
-- $TexturePacker:SmartUpdate:b1236f524560bdcf36604a7d82a87351:ada16242efb46d28d969eb423093224f:2fc2680368ee6a28e749849316f36e66$
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
            -- white laserray0000
            x=2,
            y=2,
            width=48,
            height=48,

        },
        {
            -- white laserray0001
            x=52,
            y=2,
            width=48,
            height=48,

        },
        {
            -- white laserray0002
            x=102,
            y=2,
            width=48,
            height=48,

        },
        {
            -- white laserray0003
            x=152,
            y=2,
            width=48,
            height=48,

        },
        {
            -- white laserray0004
            x=202,
            y=2,
            width=48,
            height=48,

        },
        {
            -- white laserray0005
            x=252,
            y=2,
            width=48,
            height=48,

        },
        {
            -- white laserray0006
            x=302,
            y=2,
            width=48,
            height=48,

        },
        {
            -- white laserray0007
            x=352,
            y=2,
            width=48,
            height=48,

        },
        {
            -- white laserray0008
            x=402,
            y=2,
            width=48,
            height=48,

        },
        {
            -- white laserray0009
            x=452,
            y=2,
            width=48,
            height=48,

        },
        {
            -- white laserray0010
            x=502,
            y=2,
            width=48,
            height=48,

        },
        {
            -- white laserray0011
            x=552,
            y=2,
            width=48,
            height=48,

        },
        {
            -- white laserray0012
            x=602,
            y=2,
            width=48,
            height=48,

        },
        {
            -- white laserray0013
            x=652,
            y=2,
            width=48,
            height=48,

        },
        {
            -- white laserray0014
            x=702,
            y=2,
            width=48,
            height=48,

        },
        {
            -- white laserray0015
            x=752,
            y=2,
            width=48,
            height=48,

        },
    },
    
    sheetContentWidth = 802,
    sheetContentHeight = 52
}

SheetInfo.frameIndex =
{

    ["white laserray0000"] = 1,
    ["white laserray0001"] = 2,
    ["white laserray0002"] = 3,
    ["white laserray0003"] = 4,
    ["white laserray0004"] = 5,
    ["white laserray0005"] = 6,
    ["white laserray0006"] = 7,
    ["white laserray0007"] = 8,
    ["white laserray0008"] = 9,
    ["white laserray0009"] = 10,
    ["white laserray0010"] = 11,
    ["white laserray0011"] = 12,
    ["white laserray0012"] = 13,
    ["white laserray0013"] = 14,
    ["white laserray0014"] = 15,
    ["white laserray0015"] = 16,
}

function SheetInfo:getSheet()
    return self.sheet;
end

function SheetInfo:getFrameIndex(name)
    return self.frameIndex[name];
end

return SheetInfo
