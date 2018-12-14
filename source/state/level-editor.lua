local GeometryLayer = require 'class.layer.geometry'
local Grid = require 'class.grid'
local Level = require 'class.level'

local levelEditor = {}

function levelEditor:enter(_, project, level)
	self.level = level or Level(project)
	self.selectedLayerIndex = 1
	self.grid = Grid(self.level)
	function self.grid.onMoveCursor(x, y)
		if love.mouse.isDown(1) then
			local selectedLayer = self.level.layers[self.selectedLayerIndex]
			if selectedLayer:is(GeometryLayer) then
				local cursorX, cursorY = self.grid:getCursorPosition()
				self.level = self.level:setLayer(self.selectedLayerIndex,
					selectedLayer:place(cursorX, cursorY, cursorX, cursorY))
			end
		end
	end
end

function levelEditor:mousemoved(x, y, dx, dy, istouch)
	self.grid:mousemoved(x, y, dx, dy, istouch)
end

function levelEditor:mousepressed(x, y, button, istouch, presses)
	if button == 1 then
		local selectedLayer = self.level.layers[self.selectedLayerIndex]
		if selectedLayer:is(GeometryLayer) then
			local cursorX, cursorY = self.grid:getCursorPosition()
			self.level = self.level:setLayer(self.selectedLayerIndex,
				selectedLayer:place(cursorX, cursorY, cursorX, cursorY))
		end
	end
end

function levelEditor:wheelmoved(x, y)
	self.grid:wheelmoved(x, y)
end

function levelEditor:drawCursor()
	local cursorX, cursorY = self.grid:getCursorPosition()
	love.graphics.push 'all'
	love.graphics.setColor(116/255, 208/255, 232/255, 1/3)
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
