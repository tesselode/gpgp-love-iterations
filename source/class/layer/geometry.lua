local Object = require 'lib.classic'
local util = require 'util'

local GeometryLayer = Object:extend()

function GeometryLayer:new()
	self.name = 'New geometry layer'
	self.items = {}
end

function GeometryLayer:place(l, t, r, b)
	local layer = GeometryLayer()
	layer.name = self.name
	for _, item in ipairs(self.items) do
		table.insert(layer.items, item)
	end
	for x = l, r do
		for y = t, b do
			table.insert(layer.items, {x = x, y = y})
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

return GeometryLayer
