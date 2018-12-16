local Object = require 'lib.classic'
local util = require 'util'

local GeometryLayer = Object:extend()

function GeometryLayer:new(data)
	self.data = data or {
		name = 'New geometry layer',
		items = {},
	}
end

function GeometryLayer:hasItemAt(x, y)
	for _, item in ipairs(self.data.items) do
		if item.x == x and item.y == y then return true end
	end
	return false
end

function GeometryLayer:setName(name)
	local data = util.shallowCopy(self.data)
	data.name = name
	return GeometryLayer(data)
end

function GeometryLayer:place(l, t, r, b)
	local data = util.shallowCopy(self.data)
	data.items = util.shallowCopy(data.items)
	for x = l, r do
		for y = t, b do
			if not self:hasItemAt(x, y) then
				table.insert(data.items, {x = x, y = y})
			end
		end
	end
	return GeometryLayer(data)
end

function GeometryLayer:remove(l, t, r, b)
	local data = util.shallowCopy(self.data)
	data.items = {}
	for _, item in ipairs(self.data.items) do
		if not util.pointInRect(item.x, item.y, l, t, r, b) then
			table.insert(data.items, item)
		end
	end
	return GeometryLayer(data)
end

function GeometryLayer:draw()
	love.graphics.push 'all'
	love.graphics.setColor(116/255, 208/255, 232/255, 1/3)
	for _, item in ipairs(self.data.items) do
		love.graphics.rectangle('fill', item.x, item.y, 1, 1)
	end
	love.graphics.pop()
end

return GeometryLayer
