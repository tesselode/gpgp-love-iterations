local Layer = require 'class.layer.layer'

local GeometryLayer = Layer:extend()

function GeometryLayer:new(...)
	self.super.new(self, ...)
	self.tiles = {}
end

function GeometryLayer:draw()
	love.graphics.print 'hi im a geometry layer'
end

return GeometryLayer
