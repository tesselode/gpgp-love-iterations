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

function levelEditor:draw()
	self.grid:draw()
end

return levelEditor
