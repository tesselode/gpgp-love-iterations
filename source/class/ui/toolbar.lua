local Button = require 'class.ui.button'
local image = require 'image'
local Object = require 'lib.classic'
local Row = require 'class.ui.row'
local Separator = require 'class.ui.separator'

local Toolbar = Object:extend()

Toolbar.padding = 8

function Toolbar:new(props, callbacks)
	self.row = Row(self.padding, self.padding)
		:addItem(Button, image.folder)
		:addItem(Button, image.layers)
		:addItem(Button, image.history)
		:addItem(Separator, Button.imageSize + Button.padding * 2)
		:addItem(Button, image.pencil, callbacks.onSelectPencilTool,
			function() return props.getTool() == 'pencil' end)
		:addItemCompact(Button, image.box, callbacks.onSelectBoxTool,
			function() return props.getTool() == 'box' end)
		:addItemCompact(Button, image.select)
end

function Toolbar:getHeight()
	return Button.imageSize + 2 * Button.padding + 2 * self.padding
end

function Toolbar:mousemoved(x, y, dx, dy, istouch)
	self.row:mousemoved(x, y, dx, dy, istouch)
end

function Toolbar:mousepressed(x, y, button, istouch, presses)
	self.row:mousepressed(x, y, button, istouch, presses)
end

function Toolbar:mousereleased(x, y, button, istouch, presses)
	self.row:mousereleased(x, y, button, istouch, presses)
end

function Toolbar:drawBackground()
	love.graphics.push 'all'
	love.graphics.setColor(1/5, 1/5, 1/5)
	love.graphics.rectangle('fill', 0, 0,love.graphics.getWidth(), self:getHeight())
	love.graphics.pop()
end

function Toolbar:draw()
	self:drawBackground()
	self.row:draw()
end

return Toolbar
