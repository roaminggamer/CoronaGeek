local myCC = ssk.ccmgr:newCalculator()
myCC:addNames( "bullet", "target" )
myCC:collidesWith( "target", "bullet" )


return myCC