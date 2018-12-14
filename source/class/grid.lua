local Object = require 'lib.classic'

local Grid = Object:extend()

function Grid:new(level)
	self.level = level
	self.zoom = 32
	self.transform = love.math.newTransform()
	self.transform:translate(love.graphics.getWidth() / 2,
		love.graphics.getHeight() / 2)
	self.transform:scale(self.zoom)
	self.transform:translate(-self.level.width / 2, -self.level.height / 2)
end

function Grid:mousemoved(x, y, dx, dy, istouch)
	if not love.mouse.isDown(3) then return end
	self.transform:translate(dx / self.zoom, dy / self.zoom)
end

function Grid:wheelmoved(x, y)
	if not love.keyboard.isDown 'lctrl' then return end
	if y < 0 then
		self.zoom = self.zoom / 1.1
		self.transform:scale(1 / 1.1)
	elseif y > 0 then
		self.zoom = self.zoom * 1.1
		self.transform:scale(1.1)
	end
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
	love.graphics.applyTransform(self.transform)
	self:drawGridlines()
	self:drawBorder()
	love.graphics.pop()
end

return Grid
