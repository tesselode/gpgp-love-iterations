local Layer = require 'class.layer.layer'

local GeometryLayer = Layer:extend()

GeometryLayer.type = 'Geometry'

function GeometryLayer:new(...)
	self.super.new(self, ...)
	self.tiles = {}
end

function GeometryLayer:remove(x, y)
	for i = #self.tiles, 1, -1 do
		local tile = self.tiles[i]
		if tile.x == x and tile.y == y then
			table.remove(self.tiles, i)
		end
	end
end

function GeometryLayer:place(x, y)
	self:remove(x, y)
	table.insert(self.tiles, {x = x, y = y})
end

function GeometryLayer:save()
	return self.tiles
end

function GeometryLayer:load(data)
	self.tiles = data
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
	for _, tile in ipairs(self.tiles) do
		love.graphics.rectangle('fill', tile.x, tile.y, 1, 1)
	end
	love.graphics.pop()
end

return GeometryLayer
