local Button = require 'class.ui.button'
local image = require 'image'
local Object = require 'lib.classic'

local Toolbar = Object:extend()

Toolbar.padding = 8
Toolbar.separatorMargin = 16
Toolbar.separatorColor = {4/5, 4/5, 4/5}

function Toolbar:new(callbacks)
	self.buttons = {}
	self.separators = {}
	self.buttons.hamburger = Button(self.padding, self.padding,
		image.hamburger, callbacks.onShowMenu)
	table.insert(self.separators, self.buttons.hamburger:getRight() + self.separatorMargin)
	self.buttons.pencil = Button(self.separators[#self.separators] + self.separatorMargin, self.padding,
		image.pencil, callbacks.onSelectPencilTool)
	self.buttons.box = Button(self.buttons.pencil:getRight(),
		self.padding, image.box, callbacks.onSelectBoxTool)
end

function Toolbar:getHeight()
	return (16 + 2 * Button.padding) * Button.scale + 2 * self.padding
end

function Toolbar:mousemoved(x, y, dx, dy, istouch)
	for _, b in pairs(self.buttons) do
		b:mousemoved(x, y, dx, dy, istouch)
	end
end

function Toolbar:mousepressed(x, y, button, istouch, presses)
	for _, b in pairs(self.buttons) do
		b:mousepressed(x, y, button, istouch, presses)
	end
end

function Toolbar:mousereleased(x, y, button, istouch, presses)
	for _, b in pairs(self.buttons) do
		b:mousereleased(x, y, button, istouch, presses)
	end
end

function Toolbar:drawBackground()
	love.graphics.push 'all'
	love.graphics.setColor(1/5, 1/5, 1/5)
	love.graphics.rectangle('fill', 0, 0,love.graphics.getWidth(), self:getHeight())
	love.graphics.pop()
end

function Toolbar:draw(tool)
	self:drawBackground()
	self.buttons.hamburger:draw()
	self.buttons.pencil:draw(tool == 'pencil')
	self.buttons.box:draw(tool == 'box')
	love.graphics.push 'all'
	love.graphics.setColor(self.separatorColor)
	for _, x in ipairs(self.separators) do
		love.graphics.line(x, self.padding, x, self:getHeight() - self.padding)
	end
	love.graphics.pop()
end

return Toolbar
