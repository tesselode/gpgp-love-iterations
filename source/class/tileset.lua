local Object = require 'lib.classic'
local Stamp = require 'class.stamp'

local Tileset = Object:extend()

function Tileset:new(mountPoint, data)
	self.name = data.name
	self.tileSize = data.tileSize
	self.image = love.graphics.newImage(mountPoint .. '/images/' .. data.imagePath)
	self.image:setFilter('nearest', 'nearest')
end

function Tileset:getStamp(rect)
	local width = rect.right - rect.left + 1
	local height = rect.bottom - rect.top + 1
	local tiles = {}
	for tileX = rect.left, rect.right do
		for tileY = rect.top, rect.bottom do
			local x = tileX - rect.left
			local y = tileY - rect.top
			table.insert(tiles, {x = x, y = y, tileX = tileX, tileY = tileY})
		end
	end
	return Stamp(width, height, tiles)
end

function Tileset:drawFullImage()
	love.graphics.push 'all'
	love.graphics.draw(self.image, 0, 0, 0, 1 / self.tileSize)
	love.graphics.pop()
end

function Tileset:drawTile(x, y, tileX, tileY)
	local quad = love.graphics.newQuad(tileX * self.tileSize, tileY * self.tileSize,
		self.tileSize, self.tileSize,
		self.image:getWidth(), self.image:getHeight())
	love.graphics.draw(self.image, quad, x, y, 0, 1 / self.tileSize)
end

return Tileset
