local Object = require 'lib.classic'

local Editor = Object:extend()

function Editor:new(map)
	self.map = map
	self.panX = love.graphics.getWidth() / 2
	self.panY = love.graphics.getHeight() / 2
	self.scale = 32
	self.transform = love.math.newTransform(self.panX, self.panY,
		0,
		self.scale, self.scale,
		self.map.width / 2, self.map.height / 2)
end

function Editor:update(dt)
	self.transform:setTransformation(self.panX, self.panY,
		0,
		self.scale, self.scale,
		self.map.width / 2, self.map.height / 2)
end

function Editor:drawGrid()
	love.graphics.setLineWidth(1/16)
	love.graphics.rectangle('line', 0, 0, self.map.width, self.map.height)
	for x = 1, self.map.width - 1 do
		love.graphics.line(x, 0, x, self.map.height)
	end
	for y = 1, self.map.height - 1 do
		love.graphics.line(0, y, self.map.width, y)
	end
end

function Editor:draw()
	love.graphics.push()
	love.graphics.applyTransform(self.transform)
	self:drawGrid()
	love.graphics.pop()
end

return Editor
