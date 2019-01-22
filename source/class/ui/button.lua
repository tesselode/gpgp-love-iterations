local boxer = require 'lib.boxer'

return function(options)
	local button
	if options.content then
		button = boxer.wrap {
			children = options.content,
			padding = options.padding or 16,
		}
	else
		button = boxer.box()
	end
	if options.x then button.x = options.x end
	if options.left then button.left = options.left end
	if options.center then button.center = options.center end
	if options.right then button.right = options.right end
	if options.y then button.y = options.y end
	if options.top then button.top = options.top end
	if options.middle then button.middle = options.middle end
	if options.bottom then button.bottom = options.bottom end
	if options.width then button.width = options.width end
	if options.height then button.height = options.height end
	button.style = {
		idle = {fillColor = {.2, .2, .2}},
		hovered = {fillColor = {.4, .4, .4}},
		pressed = {fillColor = {.15, .15, .15}},
	}
	button.onPress = options.onPress
	return button
end
