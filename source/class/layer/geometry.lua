local Object = require 'lib.classic'
local util = require 'util'

local GeometryLayer = Object:extend()

function GeometryLayer:new()
	self.name = 'New geometry layer'
	self.items = {}
end

function GeometryLayer:hasItemAt(x, y)
	for _, item in ipairs(self.items) do
		if item.x == x and item.y == y then return true end
	end
	return false
end

function GeometryLayer:place(l, t, r, b)
	local layer = GeometryLayer()
	layer.name = self.name
	for _, item in ipairs(self.items) do
		table.insert(layer.items, item)
	end
	for x = l, r do
		for y = t, b do
			if not layer:hasItemAt(x, y) then
				table.insert(layer.items, {x = x, y = y})
			end
		end
	end
	return layer
end

function GeometryLayer:remove(l, t, r, b)
	local layer = GeometryLayer()
	layer.name = self.name
	for _, item in ipairs(self.items) do
		if not util.pointInRect(item.x, item.y, l, t, r, b) then
			table.insert(layer.items, item)
		end
	end
	return layer
end

function GeometryLayer:draw()
	love.graphics.push 'all'
	love.graphics.setColor(116/255, 208/255, 232/255, 1/3)
	for _, item in ipairs(self.items) do
		love.graphics.rectangle('fill', item.x, item.y, 1, 1)
	end
	love.graphics.pop()
end

return GeometryLayer
