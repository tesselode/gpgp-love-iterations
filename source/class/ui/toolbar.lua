local Button = require 'class.ui.button'
local image = require 'image'
local Object = require 'lib.classic'

local Toolbar = Object:extend()

Toolbar.padding = 8

function Toolbar:new(callbacks)
	self.buttons = {}
	self.buttons.pencil = Button(self.padding, self.padding,
		image.pencil, callbacks.onSelectPencilTool)
	self.buttons.box = Button(self.buttons.pencil:getRight(),
		self.padding, image.box, callbacks.onSelectBoxTool)
end

function Toolbar:getWidth()
	return self.buttons.pencil:getWidth() + self.buttons.box:getWidth() + 2 * self.padding
end

function Toolbar:getHeight()
	return self.buttons.pencil:getHeight() + 2 * self.padding
end

function Toolbar:getX()
	return (love.graphics.getWidth() - self:getWidth()) / 2
end

function Toolbar:getY()
	return 0
end

function Toolbar:getPosition()
	return self:getX(), self:getY()
end

function Toolbar:getRect()
	return self:getX(), self:getY(), self:getWidth(), self:getHeight()
end

function Toolbar:pointInBounds(x, y)
	local tx, ty, tw, th = self:getRect()
	return x >= tx
	   and x <= tx + tw
	   and y >= ty
	   and y <= ty + th
end

function Toolbar:mousemoved(x, y, dx, dy, istouch)
	for _, b in pairs(self.buttons) do
		b:mousemoved(x - self:getX(), y - self:getY(), dx, dy, istouch)
	end
end

function Toolbar:mousepressed(x, y, button, istouch, presses)
	for _, b in pairs(self.buttons) do
		b:mousepressed(x - self:getX(), y - self:getY(), button, istouch, presses)
	end
end

function Toolbar:mousereleased(x, y, button, istouch, presses)
	for _, b in pairs(self.buttons) do
		b:mousereleased(x - self:getX(), y - self:getY(), button, istouch, presses)
	end
end

function Toolbar:drawBackground()
	love.graphics.push 'all'
	love.graphics.setColor(1/5, 1/5, 1/5)
	local x, y, w, h = self:getRect()
	love.graphics.rectangle('fill', x, y, w, h)
	love.graphics.pop()
end

function Toolbar:drawButtons(tool)
	love.graphics.push 'all'
	love.graphics.translate(self:getPosition())
	self.buttons.pencil:draw(tool == 'pencil')
	self.buttons.box:draw(tool == 'box')
	love.graphics.pop()
end

function Toolbar:draw(tool)
	self:drawBackground()
	self:drawButtons(tool)
end

return Toolbar
