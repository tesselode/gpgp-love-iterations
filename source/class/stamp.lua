local Object = require 'lib.classic'

local Stamp = Object:extend()

function Stamp:new(width, height, tiles)
	self.width = width or 1
	self.height = height or 1
	--[[
		self.tiles should be a 2D array (x, y)
		for example:
		tiles[1][1] = {tileX = 3, tileY = 5} -- top left is (1, 1)
		tiles[3][8] = {tileX = 10, tileY = 11}
	]]
	self.tiles = tiles or {{{tileX = 1, tileY = 1}}}
end

function Stamp:getTileAt(x, y)
	local tile = self.tiles[x][y]
	return tile.tileX, tile.tileY
end

return Stamp
