local Grid = require 'class.grid'

local tilePicker = {}

function tilePicker:enter(previous, tileset, onSelect)
	self.tileset = tileset
	self.onSelect = onSelect
	local width = math.ceil(tileset.image:getWidth() / tileset.tileSize)
	local height = math.ceil(tileset.image:getHeight() / tileset.tileSize)
	self.grid = Grid(width, height)
end

function tilePicker:mousemoved(x, y, dx, dy, istouch)
	self.grid:mousemoved(x, y, dx, dy, istouch)
end

function tilePicker:mousepressed(x, y, button, istouch, presses)
end

function tilePicker:wheelmoved(x, y)
	self.grid:wheelmoved(x, y)
end

function tilePicker:draw()
	self.grid:draw(function()
		self.tileset:drawFullImage()
	end)
end

return tilePicker
