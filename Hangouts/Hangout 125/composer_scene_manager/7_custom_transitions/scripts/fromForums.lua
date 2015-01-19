local composer 		= require( "composer" )

-- From this post: http://forums.coronalabs.com/topic/50598-ios-7-style-scene-transitions/
--
composer.effectList["iosSlideLeft"] = 
	{
        sceneAbove = true,
        concurrent = true,
        to = {
            xStart     = display.contentWidth,
            yStart     = 0,
            xEnd       = 0,
            yEnd       = 0,
            transition = easing.outQuad
        },
        from = {
            xStart     = 0,
            yStart     = 0,
            xEnd       = -display.contentWidth * 0.3,
            yEnd       = 0,
            transition = easing.outQuad
        }
    }

composer.effectList["iosSlideRight"] = {
    sceneAbove = false,
    concurrent = true,
    to = {
        xStart     = -display.contentWidth * 0.3,
        yStart     = 0,
        xEnd       = 0,
        yEnd       = 0,
        transition = easing.outQuad
    },
    from = {
        xStart     = 0,
        yStart     = 0,
        xEnd       = display.contentWidth,
        yEnd       = 0,
        transition = easing.outQuad
    }
}

composer.effectList["displaySceneFromLeft"] = {
    sceneAbove = true,
    concurrent = true,
    to = {
        xStart     = -display.contentWidth,
        yStart     = 0,
        xEnd       = 0,
        yEnd       = 0,
        transition = easing.outQuad
    },
    from = {
        xStart     = 0,
        yStart     = 0,
        xEnd       = display.contentWidth * 0.3,
        yEnd       = 0,
        transition = easing.outQuad
    }
}

composer.effectList["dismissSceneToLeft"] = {
    sceneAbove = false,
    concurrent = true,
    to = {
        xStart     = display.contentWidth * 0.3,
        yStart     = 0,
        xEnd       = 0,
        yEnd       = 0,
        transition = easing.outQuad
    },
    from = {
        xStart     = 0,
        yStart     = 0,
        xEnd       = -display.contentWidth,
        yEnd       = 0,
        transition = easing.outQuad
    }
}

-- From this post: http://forums.coronalabs.com/topic/48659-missing-composer-transition-effects/
--
composer.effectList["panelDown"] = {
  sceneAbove = false,
  concurrent = true,
  from = {
    yStart = 0,
    yEnd = display.contentHeight - display.screenOriginY*2,
    transition = easing.outQuad
  },
  to = {
    xStart = 0,
    xEnd = 0,
    yStart = 0,
    yEnd = 0
  }
}

