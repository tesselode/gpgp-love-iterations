local Layer = require 'class.layer.layer'

local EntityLayer = Layer:extend()

EntityLayer.type = 'Entity'

function EntityLayer:new(...)
	self.super.new(self, ...)
	self.entities = {}
	self.palette = self.map.project.config.entities
end

function EntityLayer:_getEntityAt(x, y)
	for entity, _ in pairs(self.entities) do
		if entity.x == x and entity.y == y then
			return entity
		end
	end
	return false
end

function EntityLayer:_removeEntity(entity)
	self.entities[entity] = nil
end

function EntityLayer:remove(x, y)
	local entity = self:_getEntityAt(x, y)
	if entity then self:_removeEntity(entity) end
end

function EntityLayer:place(x, y, item)
	self:remove(x, y)
	local entity = {
		x = x,
		y = y,
		entity = item,
	}
	self.entities[entity] = true
end

function EntityLayer:_drawEntity(x, y, entity)
	local tileSize = self.map.project.config.tileSize
	love.graphics.draw(self.map.project.entityImages[entity], x, y, 0, 1 / tileSize, 1 / tileSize)
end

function EntityLayer:draw()
	for entity, _ in pairs(self.entities) do
		self:_drawEntity(entity.x, entity.y, entity.entity)
	end
end

function EntityLayer:drawCursor(x, y, item)
	love.graphics.push 'all'
	love.graphics.setColor(1, 1, 1, 2/3)
	self:_drawEntity(x, y, item)
	love.graphics.pop()
end

return EntityLayer
