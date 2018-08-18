local mainEditor = require 'state.main-editor'
local gamestate = require 'lib.gamestate'
local Project = require 'class.project'

local welcome = {}

function welcome:directorydropped(path)
	love.filesystem.mount(path, 'project')
	assert(love.filesystem.getInfo 'project/config.lua', 'not a project folder')
	local project = Project 'project'
	gamestate.switch(mainEditor, project)
end

function welcome:draw()
	love.graphics.print 'drop a project folder on this window to open it'
end

return welcome
