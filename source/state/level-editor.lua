local GeometryLayer = require 'class.layer.geometry'
local Grid = require 'class.grid'
local Level = require 'class.level'

local levelEditor = {}

function levelEditor:initGrid()
	self.grid = Grid(self.level)

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
	self.level = level or Level(project)
	self.selectedLayerIndex = 1
	self:initGrid()
end

function levelEditor:place(l, t, r, b)
	local selectedLayer = self.level.layers[self.selectedLayerIndex]
	if selectedLayer:is(GeometryLayer) then
		self.level = self.level:setLayer(self.selectedLayerIndex,
			selectedLayer:place(l, t, r, b))
	end
end

function levelEditor:remove(l, t, r, b)
	local selectedLayer = self.level.layers[self.selectedLayerIndex]
	if selectedLayer:is(GeometryLayer) then
		self.level = self.level:setLayer(self.selectedLayerIndex,
			selectedLayer:remove(l, t, r, b))
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
		self.level:draw()
		self:drawCursor()
	end)
end

return levelEditor
