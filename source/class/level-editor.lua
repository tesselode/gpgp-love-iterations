local GeometryLayer = require 'class.layer.geometry'
local Grid = require 'class.grid'
local Level = require 'class.level'
local Object = require 'lib.classic'
local serpent = require 'lib.serpent'
local Stamp = require 'class.stamp'
local TileLayer = require 'class.layer.tile'

local LevelEditor = Object:extend()

function LevelEditor:initGrid()
	local level = self:getCurrentLevelState()
	self.grid = Grid(level.data.width, level.data.height)

	function self.grid.onMoveCursor(x, y)
		local cursorX, cursorY = self.grid:getCursorPosition()
		if love.mouse.isDown(1) then
			self:place(cursorX, cursorY, cursorX, cursorY)
		elseif love.mouse.isDown(2) then
			self:remove(cursorX, cursorY, cursorX, cursorY)
		end
	end
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

function LevelEditor:place(l, t, r, b)
	local level = self:getCurrentLevelState()
	local selectedLayer = level.data.layers[self.selectedLayerIndex]
	if selectedLayer:is(GeometryLayer) then
		self:modifyLevel(level:setLayer(self.selectedLayerIndex,
				selectedLayer:place(l, t, r, b)),
			'Place geometry')
	elseif selectedLayer:is(TileLayer) then
		self:modifyLevel(level:setLayer(self.selectedLayerIndex,
				selectedLayer:place(l, t, r, b, self.tileStamp)),
			'Place tiles')
	end
end

function LevelEditor:remove(l, t, r, b)
	local level = self:getCurrentLevelState()
	local selectedLayer = level.data.layers[self.selectedLayerIndex]
	if selectedLayer:is(GeometryLayer) then
		self:modifyLevel(level:setLayer(self.selectedLayerIndex,
				selectedLayer:remove(l, t, r, b)),
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

function LevelEditor:mousepressed(x, y, button, istouch, presses)
	local cursorX, cursorY = self.grid:getCursorPosition()
	if button == 1 then
		self:place(cursorX, cursorY, cursorX, cursorY)
	elseif button == 2 then
		self:remove(cursorX, cursorY, cursorX, cursorY)
	end
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
	local cursorX, cursorY = self.grid:getCursorPosition()
	love.graphics.push 'all'
	local color = love.mouse.isDown(2) and {234/255, 30/255, 108/255, 1/3} or {116/255, 208/255, 232/255, 1/3}
	love.graphics.setColor(color)
	love.graphics.rectangle('fill', cursorX, cursorY, 1, 1)
	love.graphics.pop()
end

function LevelEditor:draw()
	self.grid:draw(function()
		self:getCurrentLevelState():draw()
		self:drawCursor()
	end)
end

return LevelEditor
