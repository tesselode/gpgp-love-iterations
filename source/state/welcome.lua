local gamestate = require 'lib.gamestate'
local mainEditor = require 'state.main-editor'
local Project = require 'class.project'

local welcome = {}

function welcome:directorydropped(path)
	local success = love.filesystem.mount(path, 'project')
	if not success then return end
	local project = Project(path, 'project')
	gamestate.switch(mainEditor, project)
end

function welcome:draw()
	love.graphics.push 'all'
	love.graphics.print 'drag a project folder onto the window to begin'
	love.graphics.pop()
end

return welcome
