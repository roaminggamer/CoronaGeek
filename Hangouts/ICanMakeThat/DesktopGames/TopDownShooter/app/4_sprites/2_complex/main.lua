-- =============================================================
-- Copyright Roaming Gamer, LLC. 2009-2015
-- =============================================================
-- =============================================================
-- main.lua
-- =============================================================

----------------------------------------------------------------------
--  Misc Configuration & Initialization
----------------------------------------------------------------------
display.setStatusBar(display.HiddenStatusBar)  
io.output():setvbuf("no") 


----------------------------------------------------------------------
--  Zombie Examples
----------------------------------------------------------------------
local redZombieMaker = require "redZombieMaker"

local group = display.newGroup()

--display.setDefault( "minTextureFilter", "nearest" )
--display.setDefault( "magTextureFilter", "nearest" )

-- Zombie 1
local aZombie = redZombieMaker.create( group, 150, display.contentCenterY, 1 )
aZombie:playAngleAnim( "walking", 180 )		

-- Zombie 2
local aZombie = redZombieMaker.create( group, 250, display.contentCenterY, 3 )
aZombie:playAngleAnim( "walking", 180 )		

-- Zombie 3
local aZombie = redZombieMaker.create( group, 350, display.contentCenterY, 0.5 )
aZombie:playAngleAnim( "walking", 180 )		

-- Zombie 4
local aZombie = redZombieMaker.create( group, 450, display.contentCenterY, 2 )
aZombie:playAngleAnim( "walking", 235 )		

-- Zombie 5
local aZombie = redZombieMaker.create( group, 550, display.contentCenterY, 2 )
aZombie:playAngleAnim( "attack", 180 )		

-- Zombie 6
local aZombie = redZombieMaker.create( group, 650, display.contentCenterY, 2 )
aZombie:playAngleAnim( "been hit", 90 )		
timer.performWithDelay( 1500, function() aZombie:play() end, -1 )

-- Zombie 7
local aZombie = redZombieMaker.create( group, 750, display.contentCenterY, 2 )
aZombie:playAngleAnim( "disintegrate", 270 )		
timer.performWithDelay( 1500, function() aZombie:play() end, -1 )

-- Zombie 7
local aZombie = redZombieMaker.create( group, display.contentCenterX, display.contentCenterY + 200, 2 )
aZombie:playAngleAnim( "walking", 0 )		
timer.performWithDelay( 1500, function() aZombie:playAngleAnim( "walking", math.random(0,359) )	 end, -1 )