local Object = require 'lib.classic'

local Stamp = Object:extend()

function Stamp:new(width, height, tiles)
	self.width = width or 1
	self.height = height or 1
	self.tiles = tiles or {{x = 0, y = 0, tileX = 0, tileY = 0}}
end

function Stamp:getTileAt(x, y)
	for _, tile in ipairs(self.tiles) do
		if tile.x == x and tile.y == y then
			return tile.tileX, tile.tileY
		end
	end
	return false
end

return Stamp
