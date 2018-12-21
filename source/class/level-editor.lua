local GeometryLayer = require 'class.layer.geometry'
local Grid = require 'class.grid'
local Level = require 'class.level'
local Object = require 'lib.classic'
local Rect = require 'class.rect'
local serpent = require 'lib.serpent'
local Stamp = require 'class.stamp'
local TileLayer = require 'class.layer.tile'

local LevelEditor = Object:extend()

function LevelEditor:initGrid()
	local level = self:getCurrentLevelState()
	self.grid = Grid(level.data.width, level.data.height)
	function self.grid.onMoveCursor(...) self:onMoveCursor(...) end
end

function LevelEditor:new(project, levelName, level)
	self.project = project
	self.levelHistory = {
		{
			level = level or Level(project),
			description = level and 'Open level' or 'New level',
		}
	}
	self.levelName = levelName
	self.levelHistoryPosition = 1
	self.selectedLayerIndex = 1
	self.tool = 'box'
	self.cursorRect = Rect(0, 0)
	self.cursorState = 'idle'
	self.tileStamp = Stamp()
	self:initGrid()
end

function LevelEditor:getCurrentLevelState()
	return self.levelHistory[self.levelHistoryPosition].level
end

function LevelEditor:getSelectedLayer()
	return self:getCurrentLevelState().data.layers[self.selectedLayerIndex]
end

function LevelEditor:setTileStamp(stamp)
	self.tileStamp = stamp
end

function LevelEditor:modifyLevel(level, description)
	self.levelHistoryPosition = self.levelHistoryPosition + 1
	for i = self.levelHistoryPosition + 1, #self.levelHistory do
		self.levelHistory[i] = nil
	end
	self.levelHistory[self.levelHistoryPosition] = {
		level = level,
		description = description,
	}
end

function LevelEditor:undo()
	if self.levelHistoryPosition > 1 then
		self.levelHistoryPosition = self.levelHistoryPosition - 1
	end
end

function LevelEditor:redo()
	if self.levelHistoryPosition < #self.levelHistory then
		self.levelHistoryPosition = self.levelHistoryPosition + 1
	end
end

function LevelEditor:addLayer(layerType, ...)
	local level = self:getCurrentLevelState()
	self:modifyLevel(
		level:addLayer(self.selectedLayerIndex, layerType, ...),
		'Add layer'
	)
end

function LevelEditor:removeLayer()
	local level = self:getCurrentLevelState()
	local layer = level.data.layers[self.selectedLayerIndex]
	if #level.data.layers <= 1 then return end
	self:modifyLevel(level:removeLayer(self.selectedLayerIndex),
		'Remove layer "' .. layer.data.name .. '"')
	if self.selectedLayerIndex > #level.data.layers - 1 then
		self.selectedLayerIndex = #level.data.layers - 1
	end
end

function LevelEditor:moveLayerUp()
	local level = self:getCurrentLevelState()
	local layer = level.data.layers[self.selectedLayerIndex]
	if self.selectedLayerIndex <= 1 then return end
	self:modifyLevel(level:moveLayerUp(self.selectedLayerIndex),
		'Move layer "' .. layer.data.name .. '" up')
	self.selectedLayerIndex = self.selectedLayerIndex - 1
end

function LevelEditor:moveLayerDown()
	local level = self:getCurrentLevelState()
	local layer = level.data.layers[self.selectedLayerIndex]
	if self.selectedLayerIndex >= #level.data.layers then return end
	self:modifyLevel(level:moveLayerDown(self.selectedLayerIndex),
		'Move layer "' .. layer.data.name .. '" down')
	self.selectedLayerIndex = self.selectedLayerIndex + 1
end

function LevelEditor:renameLayer(name)
	local level = self:getCurrentLevelState()
	local layer = level.data.layers[self.selectedLayerIndex]
	self:modifyLevel(
		level:setLayer(
			self.selectedLayerIndex,
			layer:setName(name)
		),
		'Rename layer "' .. layer.data.name .. '" to "' .. name .. '"'
	)
end

function LevelEditor:place(rect)
	local level = self:getCurrentLevelState()
	local selectedLayer = level.data.layers[self.selectedLayerIndex]
	if selectedLayer:is(GeometryLayer) then
		self:modifyLevel(level:setLayer(self.selectedLayerIndex,
				selectedLayer:place(rect)),
			'Place geometry')
	elseif selectedLayer:is(TileLayer) then
		self:modifyLevel(level:setLayer(self.selectedLayerIndex,
				selectedLayer:place(rect, self.tileStamp, self.tool)),
			'Place tiles')
	end
end

function LevelEditor:remove(rect)
	local level = self:getCurrentLevelState()
	local selectedLayer = level.data.layers[self.selectedLayerIndex]
	if selectedLayer:is(GeometryLayer) then
		self:modifyLevel(level:setLayer(self.selectedLayerIndex,
				selectedLayer:remove(rect)),
			'Remove geometry')
	elseif selectedLayer:is(TileLayer) then
		self:modifyLevel(level:setLayer(self.selectedLayerIndex,
				selectedLayer:remove(rect)),
			'Remove tiles')
	end
end

function LevelEditor:save(levelName)
	self.levelName = levelName or self.levelName
	assert(self.levelName, 'cannot save level before setting a level name')
	local data = self:getCurrentLevelState():export()
	local filePath = self.project.directory .. '/levels/' .. self.levelName .. '.lua'
	local file = io.open(filePath, 'w')
	file:write('return ' .. serpent.block(data, {comment = false}))
	file:close()
end

function LevelEditor:mousemoved(x, y, dx, dy, istouch)
	self.grid:mousemoved(x, y, dx, dy, istouch)
end

function LevelEditor:onMoveCursor(cursorX, cursorY)
	if self.tool == 'pencil' then
		self.cursorRect = Rect(cursorX, cursorY)
		if self.cursorState == 'place' then
			self:place(self.cursorRect)
		elseif self.cursorState == 'remove' then
			self:remove(self.cursorRect)
		end
	elseif self.tool == 'box' then
		if self.cursorState == 'idle' then
			self.cursorRect = Rect(cursorX, cursorY)
		else
			self.cursorRect.right = cursorX
			self.cursorRect.bottom = cursorY
		end
	end
end

function LevelEditor:mousepressed(x, y, button, istouch, presses)
	if button == 1 then
		self.cursorState = 'place'
		if self.tool == 'pencil' then self:place(self.cursorRect) end
	elseif button == 2 then
		self.cursorState = 'remove'
		if self.tool == 'pencil' then self:remove(self.cursorRect) end
	end
end

function LevelEditor:mousereleased(x, y, button, istouch, presses)
	if self.tool == 'box' then
		if self.cursorState == 'place' then
			self:place(self.cursorRect:normalized())
		elseif self.cursorState == 'remove' then
			self:remove(self.cursorRect:normalized())
		end
		self.cursorRect = Rect(self.grid:getCursorPosition())
	end
	self.cursorState = 'idle'
end

function LevelEditor:wheelmoved(x, y)
	self.grid:wheelmoved(x, y)
end

function LevelEditor:keypressed(key, scancode, isrepeat)
	if key == 'z' and love.keyboard.isDown 'lctrl' then
		self:undo()
	end
	if key == 'y' and love.keyboard.isDown 'lctrl' then
		self:redo()
	end
end

function LevelEditor:drawCursor()
	local removing = love.mouse.isDown(2)
	local layer = self:getSelectedLayer()
	if layer:is(GeometryLayer) then
		layer:drawCursor(self.cursorRect:normalized(), removing)
	elseif layer:is(TileLayer) then
		layer:drawCursor(self.cursorRect:normalized(), removing, self.tileStamp, self.tool)
	end
end

function LevelEditor:draw()
	self.grid:draw(function()
		self:getCurrentLevelState():draw()
		self:drawCursor()
	end)
end

return LevelEditor
