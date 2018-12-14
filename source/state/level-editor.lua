local GeometryLayer = require 'class.layer.geometry'
local Grid = require 'class.grid'
local Level = require 'class.level'

local levelEditor = {}

function levelEditor:initGrid()
	local level = self:getCurrentLevelState()
	self.grid = Grid(level.width, level.height)

	function self.grid.onMoveCursor(x, y)
		local cursorX, cursorY = self.grid:getCursorPosition()
		if love.mouse.isDown(1) then
			self:place(cursorX, cursorY, cursorX, cursorY)
		elseif love.mouse.isDown(2) then
			self:remove(cursorX, cursorY, cursorX, cursorY)
		end
	end
end

function levelEditor:enter(_, project, level)
	self.levelHistory = {
		{
			level = level or Level(project),
			description = level and 'Open level' or 'New level',
		}
	}
	self.levelHistoryPosition = 1
	self.selectedLayerIndex = 1
	self:initGrid()
end

function levelEditor:getCurrentLevelState()
	return self.levelHistory[self.levelHistoryPosition].level
end

function levelEditor:modifyLevel(level, description)
	self.levelHistoryPosition = self.levelHistoryPosition + 1
	for i = self.levelHistoryPosition + 1, #self.levelHistory do
		self.levelHistory[i] = nil
	end
	self.levelHistory[self.levelHistoryPosition] = {
		level = level,
		description = description,
	}
end

function levelEditor:undo()
	if self.levelHistoryPosition > 1 then
		self.levelHistoryPosition = self.levelHistoryPosition - 1
	end
end

function levelEditor:redo()
	if self.levelHistoryPosition < #self.levelHistory then
		self.levelHistoryPosition = self.levelHistoryPosition + 1
	end
end

function levelEditor:place(l, t, r, b)
	local level = self:getCurrentLevelState()
	local selectedLayer = level.layers[self.selectedLayerIndex]
	if selectedLayer:is(GeometryLayer) then
		self:modifyLevel(level:setLayer(self.selectedLayerIndex,
				selectedLayer:place(l, t, r, b)),
			'Place tiles')
	end
end

function levelEditor:remove(l, t, r, b)
	local level = self:getCurrentLevelState()
	local selectedLayer = level.layers[self.selectedLayerIndex]
	if selectedLayer:is(GeometryLayer) then
		self:modifyLevel(level:setLayer(self.selectedLayerIndex,
				selectedLayer:remove(l, t, r, b)),
			'Remove tiles')
	end
end

function levelEditor:mousemoved(x, y, dx, dy, istouch)
	self.grid:mousemoved(x, y, dx, dy, istouch)
end

function levelEditor:mousepressed(x, y, button, istouch, presses)
	local cursorX, cursorY = self.grid:getCursorPosition()
	if button == 1 then
		self:place(cursorX, cursorY, cursorX, cursorY)
	elseif button == 2 then
		self:remove(cursorX, cursorY, cursorX, cursorY)
	end
end

function levelEditor:wheelmoved(x, y)
	self.grid:wheelmoved(x, y)
end

function levelEditor:keypressed(key, scancode, isrepeat)
	if key == 'z' and love.keyboard.isDown 'lctrl' then
		self:undo()
	end
	if key == 'y' and love.keyboard.isDown 'lctrl' then
		self:redo()
	end
end

function levelEditor:drawCursor()
	local cursorX, cursorY = self.grid:getCursorPosition()
	love.graphics.push 'all'
	local color = love.mouse.isDown(2) and {234/255, 30/255, 108/255, 1/3} or {116/255, 208/255, 232/255, 1/3}
	love.graphics.setColor(color)
	love.graphics.rectangle('fill', cursorX, cursorY, 1, 1)
	love.graphics.pop()
end

function levelEditor:draw()
	self.grid:draw(function()
		self:getCurrentLevelState():draw()
		self:drawCursor()
	end)
end

return levelEditor
