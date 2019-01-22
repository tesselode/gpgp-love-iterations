local Grid = require 'class.grid'
local Rect = require 'class.rect'

local tilePicker = {}

function tilePicker:enter(previous, tileset, onSelect)
	self.tileset = tileset
	self.onSelect = onSelect
	local width = math.ceil(tileset.image:getWidth() / tileset.tileSize)
	local height = math.ceil(tileset.image:getHeight() / tileset.tileSize)
	self.grid = Grid(width, height)
	self.grid.onMoveCursor = function(cursorX, cursorY)
		if self.selection and love.mouse.isDown(1) then
			self.selection.right = cursorX
			self.selection.bottom = cursorY
		end
	end
	self.selection = nil
end

function tilePicker:mousemoved(x, y, dx, dy, istouch)
	self.grid:mousemoved(x, y, dx, dy, istouch)
end

function tilePicker:mousepressed(x, y, button, istouch, presses)
	if button == 1 then
		local cursorX, cursorY = self.grid:getCursorPosition()
		self.selection = Rect(cursorX, cursorY)
	end
end

function tilePicker:mousereleased(x, y, button, istouch, presses)
	if button == 1 and self.onSelect then
		self.onSelect(self.tileset:getStamp(self.selection:normalized()))
	end
end

function tilePicker:wheelmoved(x, y)
	self.grid:wheelmoved(x, y)
end

function tilePicker:keypressed(key, scancode, isrepeat)
	if key == 'space' or key == 'escape' then
		screenManager:pop()
	end
end

function tilePicker:drawSelectionRect()
	if not self.selection then return end
	local rect = self.selection:normalized()
	love.graphics.push 'all'
	love.graphics.setColor(1, 0, 0)
	love.graphics.setLineWidth(2 / self.tileset.tileSize)
	love.graphics.rectangle('line', rect.left, rect.top,
		rect.right - rect.left + 1, rect.bottom - rect.top + 1)
	love.graphics.pop()
end

function tilePicker:draw()
	self.grid:draw(function()
		self.tileset:drawFullImage()
		self:drawSelectionRect()
	end)
end

return tilePicker
