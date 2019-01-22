local mainEditor = require 'state.main-editor'
local Project = require 'class.project'
local MainToolbar = require 'class.ui.main-toolbar'

local welcome = {}

function welcome:enter()
	self.toolbar = MainToolbar {}
end

function welcome:directorydropped(path)
	local success = love.filesystem.mount(path, 'project')
	if not success then return end
	local project = Project(path, 'project')
	screenManager:switch(mainEditor, project)
end

function welcome:mousemoved(...)
	self.toolbar:mousemoved(...)
end

function welcome:mousepressed(...)
	self.toolbar:mousepressed(...)
end

function welcome:mousereleased(...)
	self.toolbar:mousereleased(...)
end

function welcome:draw()
	love.graphics.push 'all'
	love.graphics.print 'drag a project folder onto the window to begin'
	self.toolbar:draw()
	love.graphics.pop()
end

return welcome
