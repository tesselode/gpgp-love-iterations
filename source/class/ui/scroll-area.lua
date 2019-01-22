local boxer = require 'lib.boxer'
local Button = require 'class.ui.button'

local scrollbarWidth = 16
local minimumScrollbarHeight = 32

return function(options)
	local content = boxer.wrap {children = options.content}

	local contentArea = boxer.box {
		width = options.width - scrollbarWidth,
		height = options.height,
		children = {content},
		clipChildren = true,
	}

	local scrollbar = Button {
		x = contentArea.right,
		width = scrollbarWidth,
		height = function()
			local height = contentArea.height * (contentArea.height / content.height)
			if height < minimumScrollbarHeight then
				height = minimumScrollbarHeight
			end
			if height > contentArea.height then
				height = contentArea.height
			end
			return height
		end,
	}

	function scrollbar.onDrag(button, dx, dy)
		if button ~= 1 then return end
		if content.height <= contentArea.height then return end
		scrollbar.y = scrollbar.y + dy
		if scrollbar.y < 0 then
			scrollbar.y = 0
		end
		if scrollbar.bottom > contentArea.height then
			scrollbar.bottom = contentArea.height
		end
		content.y = -(content.height - contentArea.height) * (scrollbar.y / (contentArea.height - scrollbar.height))
	end

	local scrollArea = boxer.wrap {
		children = {contentArea, scrollbar},
	}
	if options.x then scrollArea.x = options.x end
	if options.left then scrollArea.left = options.left end
	if options.center then scrollArea.center = options.center end
	if options.right then scrollArea.right = options.right end
	if options.y then scrollArea.y = options.y end
	if options.top then scrollArea.top = options.top end
	if options.middle then scrollArea.middle = options.middle end
	if options.bottom then scrollArea.bottom = options.bottom end
	scrollArea.style = {idle = {fillColor = {.1, .1, .1}}}
	return scrollArea
end
