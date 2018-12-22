local Object = require 'lib.classic'

local Button = Object:extend()

Button.imageSize = 24
Button.padding = 4
Button.color = {
	idle = {.5, .5, .5},
	hovered = {.8, .8, .8},
	pressed = {.65, .65, .65},
	bg = {1/3, 1/3, 1/3},
	activeBg = {.8, .8, .8},
}

function Button:new(x, y, image, onPress)
	self.x = x
	self.y = y
	self.image = image
	self.onPress = onPress
	self.hovered = false
	self.pressed = false
end

function Button:getWidth()
	return self.imageSize + self.padding * 2
end

function Button:getHeight()
	return self.imageSize + self.padding * 2
end

function Button:getSize()
	return self:getWidth(), self:getHeight()
end

function Button:getRight()
	return self.x + self:getWidth()
end

function Button:getBottom()
	return self.y + self:getHeight()
end

function Button:getRect()
	return self.x, self.y, self:getSize()
end

function Button:pointInBounds(x, y)
	return x >= self.x
	   and x <= self.x + self:getWidth()
	   and y >= self.y
	   and y <= self.y + self:getHeight()
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

function Button:draw(active)
	local imageScale = self.imageSize / self.image:getHeight()
	love.graphics.push 'all'
	if active then
		love.graphics.setColor(self.color.activeBg)
		love.graphics.rectangle('fill', self:getRect())
		love.graphics.setColor(0, 0, 0)
		love.graphics.draw(self.image, self.x + self.padding,
			self.y + self.padding, 0, imageScale)
		love.graphics.pop()
		return
	end
	if self.pressed or self.hovered then
		love.graphics.setColor(self.color.bg)
		love.graphics.rectangle('fill', self:getRect())
	end
	love.graphics.setColor(self.pressed and self.color.pressed
		or self.hovered and self.color.hovered
		or self.color.idle)
	love.graphics.draw(self.image, self.x + self.padding,
		self.y + self.padding, 0, imageScale)
	love.graphics.pop()
end

return Button
