local boxer = require 'lib.boxer'

local defaultButtonPadding = 4

return function(options)
	local button
	if options.content then
		button = boxer.wrap {
			children = options.content,
			padding = options.padding or defaultButtonPadding,
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
		idle = {fillColor = function()
			if options.isActive and options.isActive() then
				return .8, .8, .8
			end
			return .2, .2, .2
		end},
		hovered = {fillColor = function()
			if options.isActive and options.isActive() then
				return .8, .8, .8
			end
			return .4, .4, .4
		end},
		pressed = {fillColor = function()
			if options.isActive and options.isActive() then
				return .8, .8, .8
			end
			return .15, .15, .15
		end},
	}
	button.onPress = options.onPress
	return button
end
