local Object = require 'lib.classic'

local Button = Object:extend()

Button.padding = 2
Button.scale = 2
Button.color = {
	idle = {1, 1, 1, 1/2},
	hovered = {1, 1, 1, 2/3},
	pressed = {1, 1, 1, 1/3},
	bg = {1/4, 1/4, 1/4},
}

function Button:new(x, y, image, onPress)
	self.x = x
	self.y = y
	self.image = image
	self.onPress = onPress
	self.hovered = false
	self.pressed = false
end

function Button:getSize()
	return self.scale * (self.image:getWidth() + self.padding * 2),
		self.scale * (self.image:getHeight() + self.padding * 2)
end

function Button:pointInBounds(x, y)
	local width, height = self:getSize()
	return x >= self.x
	   and x <= self.x + width
	   and y >= self.y
	   and y <= self.y + height
end

function Button:mousemoved(x, y, dx, dy, istouch)
	self.hovered = self:pointInBounds(x, y)
end

function Button:mousepressed(x, y, button, istouch, presses)
	if button == 1 and self:pointInBounds(x, y) then
		self.pressed = true
	end
end

function Button:mousereleased(x, y, button, istouch, presses)
	if button == 1 and self.pressed and self:pointInBounds(x, y) then
		if self.onPress then self.onPress() end
	end
	self.pressed = false
end

function Button:draw()
	love.graphics.push 'all'
	if self.pressed or self.hovered then
		love.graphics.setColor(self.color.bg)
		love.graphics.rectangle('fill', self.x, self.y, self:getSize())
	end
	love.graphics.setColor(self.pressed and self.color.pressed
		or self.hovered and self.color.hovered
		or self.color.idle)
	love.graphics.setLineWidth(self.scale)
	love.graphics.rectangle('line', self.x, self.y, self:getSize())
	love.graphics.draw(self.image, self.x + self.padding * self.scale,
		self.y + self.padding * self.scale, 0, self.scale)
	love.graphics.pop()
end

return Button
