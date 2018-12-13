local Object = require 'lib.classic'

local Grid = Object:extend()

function Grid:new(level)
	self.level = level
	self.zoom = 16
end

function Grid:drawBorder()
	love.graphics.push 'all'
	love.graphics.setColor(1, 1, 1)
	love.graphics.setLineWidth(2 / self.zoom)
	love.graphics.rectangle('line', 0, 0, self.level.width, self.level.height)
	love.graphics.pop()
end

function Grid:drawGridlines()
	love.graphics.push 'all'
	love.graphics.setColor(1, 1, 1, 1/3)
	love.graphics.setLineWidth(2 / self.zoom)
	for x = 1, self.level.width - 1 do
		love.graphics.line(x, 0, x, self.level.height)
	end
	for y = 1, self.level.height - 1 do
		love.graphics.line(0, y, self.level.width, y)
	end
	love.graphics.pop()
end

function Grid:draw()
	love.graphics.push 'all'
	love.graphics.scale(self.zoom)
	self:drawGridlines()
	self:drawBorder()
	love.graphics.pop()
end

return Grid
