local boxer = require 'lib.boxer'
local Button = require 'class.ui.button'
local font = require 'font'
local Object = require 'lib.classic'
local ScrollArea = require 'class.ui.scroll-area'

local Menu = Object:extend()

Menu.columnWidth = 400
Menu.height = 500

function Menu:new(x, y, title, columnFunctions)
	self.columnFunctions = columnFunctions

	local titleArea = boxer.wrap {
		children = {
			boxer.text {
				font = font.big,
				text = title,
			},
		},
		padding = 16,
	}
	titleArea.x = 0
	titleArea.y = 0

	self.container = boxer.box {
		x = x,
		y = y,
		width = #self.columnFunctions * self.columnWidth,
		height = self.height,
		children = {titleArea},
		clipChildren = true,
		style = {idle = {fillColor = {.1, .1, .1}}},
	}

	for columnNumber, columnFunction in ipairs(columnFunctions) do
		local columnData = columnFunction()
		local content = {}
		local previousButton
		for _, option in ipairs(columnData) do
			previousButton = Button {
				x = 0,
				y = previousButton and previousButton.bottom or 0,
				width = self.columnWidth,
				content = {
					boxer.text {
						font = font.normal,
						text = option.text,
					},
				},
				onPress = option.onPress,
			}
			table.insert(content, previousButton)
		end
		table.insert(self.container.children, ScrollArea {
			x = (columnNumber - 1) * self.columnWidth,
			y = titleArea.bottom,
			width = self.columnWidth,
			height = self.height - titleArea.height,
			content = content,
		})
	end
end

function Menu:refreshColumn(columnNumber)
end

function Menu:mousemoved(...)
	self.container:mousemoved(...)
end

function Menu:mousepressed(...)
	self.container:mousepressed(...)
end

function Menu:mousereleased(...)
	self.container:mousereleased(...)
end

function Menu:draw()
	self.container:draw()
end

return Menu
