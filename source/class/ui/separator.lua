local Object = require 'lib.classic'

local Separator = Object:extend()

Separator.margin = 8
Separator.color = {.5, .5, .5}

function Separator:new(x, y, height)
	self.x = x
	self.y = y
	self.height = height
end

function Separator:getRight()
	return self.x + self.margin * 2
end

function Separator:draw()
	love.graphics.push 'all'
	love.graphics.setColor(self.color)
	love.graphics.setLineWidth(1)
	love.graphics.line(self.x + self.margin, self.y,
		self.x + self.margin, self.y + self.height)
	love.graphics.pop()
end

return Separator
