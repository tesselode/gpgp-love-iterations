local boxer = require 'lib.boxer'
local Button = require 'class.ui.button'

local toolbarButtonHeight = 24

return function(options)
	local image = boxer.image {
		image = options.image,
		transparent = true,
		style = {idle = {
			color = function()
				if options.isActive and options.isActive() then
					return 0, 0, 0
				end
				return 1, 1, 1
			end,
		}}
	}
	image.height = toolbarButtonHeight
	image.scaleX = image.scaleY

	local button = Button {
		content = {image},
		onPress = options.onPress,
		isActive = options.isActive,
	}
	if options.x then button.x = options.x end
	if options.left then button.left = options.left end
	if options.center then button.center = options.center end
	if options.right then button.right = options.right end
	if options.y then button.y = options.y end
	if options.top then button.top = options.top end
	if options.middle then button.middle = options.middle end
	if options.bottom then button.bottom = options.bottom end
	return button
end
