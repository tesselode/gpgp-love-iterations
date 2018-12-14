local Grid = require 'class.grid'
local Level = require 'class.level'

local levelEditor = {}

function levelEditor:enter(_, project, level)
	self.level = level or Level(project)
	self.grid = Grid(self.level)
end

function levelEditor:mousemoved(x, y, dx, dy, istouch)
	self.grid:mousemoved(x, y, dx, dy, istouch)
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
		self:drawCursor()
	end)
end

return levelEditor
