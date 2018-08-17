local Project = require 'class.project'

function love.directorydropped(path)
	love.filesystem.mount(path, 'project')
	assert(love.filesystem.getInfo 'project/config.lua', 'not a project folder')
end
