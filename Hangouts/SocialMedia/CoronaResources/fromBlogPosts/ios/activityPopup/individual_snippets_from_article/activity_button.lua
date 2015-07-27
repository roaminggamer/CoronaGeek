widget = require( "widget" )
shareButton = widget.newButton({
	label = "Share",
	onRelease = showShare,
})
shareButton.x = display.contentCenterX
shareButton.y = display.contentCenterY
