local Object = require 'lib.classic'
local util = require 'util'

local TileLayer = Object:extend()

function TileLayer.Import(exportedData)
	return TileLayer {
		name = exportedData.name,
		tilesetName = exportedData.tileset,
		items = exportedData.items,
	}
end

function TileLayer:new(dataOrTilesetName)
	self.data = type(dataOrTilesetName) == 'table' or {
		name = 'New tile layer',
		tilesetName = dataOrTilesetName,
		items = {},
	}
end

function TileLayer:hasItemAt(x, y)
	for _, item in ipairs(self.data.items) do
		if item.x == x and item.y == y then return true end
	end
	return false
end

function TileLayer:setName(name)
	local data = util.shallowCopy(self.data)
	data.name = name
	return TileLayer(data)
end

function TileLayer:remove(l, t, r, b)
	local data = util.shallowCopy(self.data)
	data.items = {}
	for _, item in ipairs(self.data.items) do
		if not util.pointInRect(item.x, item.y, l, t, r, b) then
			table.insert(data.items, item)
		end
	end
	return TileLayer(data)
end

function TileLayer:place(l, t, r, b, stamp)
	local layer = self:remove(l, t, r, b)
	local data = util.shallowCopy(layer.data)
	data.items = util.shallowCopy(data.items)
	for x = l, r do
		for y = t, b do
			local tileX, tileY = stamp:getTileAt(x - l, y - t)
			table.insert(data.items, {x = x, y = y, tileX = tileX, tileY = tileY})
		end
	end
	return TileLayer(data)
end

function TileLayer:export()
	return {
		name = self.data.name,
		type = 'tile',
		items = self.data.items,
	}
end

function TileLayer:draw(project)
	love.graphics.push 'all'
	love.graphics.setColor(116/255, 208/255, 232/255, 1/3)
	for _, item in ipairs(self.data.items) do
		project.tilesets[self.tilesetName]:drawTile(item.x, item.y, item.tileX, item.tileY)
	end
	love.graphics.pop()
end

return TileLayer
