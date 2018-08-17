local Layer = require 'class.layer.layer'

local GeometryLayer = Layer:extend()

function GeometryLayer:new(...)
	self.super.new(self, ...)
	self.tiles = {}
end

function GeometryLayer:drawCursor(x, y)
	love.graphics.push 'all'
	love.graphics.setColor(1, 1, 1, 1/2)
	love.graphics.rectangle('fill', x, y, 1, 1)
	love.graphics.pop()
end

function GeometryLayer:draw()
end

return GeometryLayer
