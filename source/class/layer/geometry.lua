local Object = require 'lib.classic'
local util = require 'util'

local GeometryLayer = Object:extend()

function GeometryLayer.Import(exportedData)
	return GeometryLayer {
		name = exportedData.name,
		items = exportedData.items,
	}
end

function GeometryLayer:new(project, data)
	self.project = project
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
	return GeometryLayer(self.project, data)
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
	return GeometryLayer(self.project, data)
end

function GeometryLayer:remove(l, t, r, b)
	local data = util.shallowCopy(self.data)
	data.items = {}
	for _, item in ipairs(self.data.items) do
		if not util.pointInRect(item.x, item.y, l, t, r, b) then
			table.insert(data.items, item)
		end
	end
	return GeometryLayer(self.project, data)
end

function GeometryLayer:export()
	return {
		name = self.data.name,
		type = 'geometry',
		items = self.data.items,
	}
end

function GeometryLayer:drawCursor(cursorX, cursorY, removing)
	love.graphics.push 'all'
	local color = love.mouse.isDown(2) and {234/255, 30/255, 108/255, 1/3} or {116/255, 208/255, 232/255, 1/3}
	love.graphics.setColor(color)
	love.graphics.rectangle('fill', cursorX, cursorY, 1, 1)
	love.graphics.pop()
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
