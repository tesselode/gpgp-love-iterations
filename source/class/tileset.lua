local Object = require 'lib.classic'

local Tileset = Object:extend()

function Tileset:new(mountPoint, data)
	self.name = data.name
	self.tileSize = data.tileSize
	self.image = love.graphics.newImage(mountPoint .. '/images/' .. data.imagePath)
end

function Tileset:drawFullImage()
	love.graphics.push 'all'
	love.graphics.draw(self.image, 0, 0, 0, 1 / self.tileSize)
	love.graphics.pop()
end

function Tileset:drawTile(x, y, tileX, tileY)
	love.graphics.push 'all'
	love.graphics.setColor(1, 1, 1)
	local quad = love.graphics.newQuad(tileX * self.tileSize, tileY * self.tileSize,
		self.tileSize, self.tileSize,
		self.image:getWidth(), self.image:getHeight())
	love.graphics.draw(self.image, quad, x, y, 0, 1 / self.tileSize)
	love.graphics.pop()
end

return Tileset
