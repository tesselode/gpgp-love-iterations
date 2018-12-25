local boxer = require 'lib.boxer'

local padding = 4
local imageHeight = 24

return function(options)
	local image = boxer.image {
		x = padding,
		y = padding,
		image = options.image,
		style = {
			idle = {
				color = function()
					return options.isActive and options.isActive() and {.1, .1, .1} or {.9, .9, .9}
				end,
			},
		},
		transparent = true,
	}
	image.height = imageHeight
	image.scaleX = image.scaleY
	local box = boxer.wrap {
		children = {image},
		padding = padding,
	}
	if options.x then box.x = options.x end
	if options.left then box.left = options.left end
	if options.center then box.center = options.center end
	if options.right then box.right = options.right end
	if options.y then box.y = options.y end
	if options.top then box.top = options.top end
	if options.middle then box.middle = options.middle end
	if options.bottom then box.bottom = options.bottom end
	box.onPress = options.onPress
	box.style = {
		idle = {
			fillColor = function()
				return options.isActive and options.isActive() and {.9, .9, .9} or {1, 1, 1, 0}
			end,
		},
		hovered = {
			fillColor = function()
				return options.isActive and options.isActive() and {.9, .9, .9} or {1, 1, 1, .2}
			end,
		},
		pressed = {
			fillColor = function()
				return options.isActive and options.isActive() and {.9, .9, .9} or {1, 1, 1, .1}
			end,
		},
	}
	return box
end
