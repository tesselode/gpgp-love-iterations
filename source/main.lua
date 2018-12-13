local Grid = require 'class.grid'
local Level = require 'class.level'
local Project = require 'class.project'

local project = Project()
local level = Level(project)
local grid = Grid(level)

function love.keypressed(key, scancode, isrepeat)
	if key == 'escape' then love.event.quit() end
end

function love.draw()
	grid:draw()
end
