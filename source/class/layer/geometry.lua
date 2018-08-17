local Layer = require 'class.layer.layer'

local GeometryLayer = Layer:extend()

function GeometryLayer:initTiles()
	self.tiles = {}
	for x = 0, self.map.width - 1 do
		self.tiles[x] = {}
	end
end

function GeometryLayer:new(...)
	self.super.new(self, ...)
	self:initTiles()
end

function GeometryLayer:place(x, y)
	self.tiles[x][y] = true
end

function GeometryLayer:remove(x, y)
	self.tiles[x][y] = nil
end

function GeometryLayer:drawCursor(x, y)
	love.graphics.push 'all'
	love.graphics.setColor(1, 1, 1, 1/2)
	love.graphics.rectangle('fill', x, y, 1, 1)
	love.graphics.pop()
end

function GeometryLayer:draw()
	love.graphics.push 'all'
	love.graphics.setColor(1, 1, 1, 1/3)
	for x = 0, self.map.width - 1 do
		for y = 0, self.map.height - 1 do
			if self.tiles[x][y] then
				love.graphics.rectangle('fill', x, y, 1, 1)
			end
		end
	end
	love.graphics.pop()
end

return GeometryLayer
