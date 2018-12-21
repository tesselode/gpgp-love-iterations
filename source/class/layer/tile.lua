local GeometryLayer = require 'class.layer.geometry'
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

function TileLayer:new(project, dataOrTilesetName)
	self.project = project
	self.data = type(dataOrTilesetName) == 'table' and dataOrTilesetName or {
		name = 'New tile layer',
		tilesetName = dataOrTilesetName,
		items = {},
	}
end

function TileLayer:getItemAt(x, y)
	for itemIndex, item in ipairs(self.data.items) do
		if item.x == x and item.y == y then
			return itemIndex, item
		end
	end
	return false
end

function TileLayer:setName(name)
	local data = util.shallowCopy(self.data)
	data.name = name
	return TileLayer(self.project, data)
end

function TileLayer:remove(l, t, r, b)
	local data = util.shallowCopy(self.data)
	data.items = {}
	for _, item in ipairs(self.data.items) do
		if not util.pointInRect(item.x, item.y, l, t, r, b) then
			table.insert(data.items, item)
		end
	end
	return TileLayer(self.project, data)
end

function TileLayer:place(l, t, r, b, stamp)
	local data = util.shallowCopy(self.data)
	data.items = util.shallowCopy(data.items)
	for stampX = 0, stamp.width - 1 do
		for stampY = 0, stamp.height - 1 do
			local x = l + stampX
			local y = t + stampY
			local tileX, tileY = stamp:getTileAt(stampX, stampY)
			if tileX and tileY then
				local _, existingItem = self:getItemAt(x, y)
				if existingItem then
					existingItem.tileX = tileX
					existingItem.tileY = tileY
				else
					table.insert(data.items, {x = x, y = y, tileX = tileX, tileY = tileY})
				end
			end
		end
	end
	return TileLayer(self.project, data)
end

function TileLayer:export()
	return {
		name = self.data.name,
		type = 'tile',
		items = self.data.items,
	}
end

function TileLayer:drawCursor(cursorX, cursorY, removing, stamp)
	GeometryLayer.drawCursor(self, cursorX, cursorY, removing)
	love.graphics.push 'all'
	love.graphics.setColor(1, 1, 1, 2/3)
	local tileset = self.project.tilesets[self.data.tilesetName]
	for _, tile in ipairs(stamp.tiles) do
		tileset:drawTile(cursorX + tile.x, cursorY + tile.y,
			tile.tileX, tile.tileY)
	end
	love.graphics.pop()
end

function TileLayer:draw()
	love.graphics.push 'all'
	love.graphics.setColor(1, 1, 1)
	for _, item in ipairs(self.data.items) do
		local tileset = self.project.tilesets[self.data.tilesetName]
		tileset:drawTile(item.x, item.y, item.tileX, item.tileY)
	end
	love.graphics.pop()
end

return TileLayer
