local boxer = require 'lib.boxer'
local image = require 'image'
local mainEditor = require 'state.main-editor'
local Project = require 'class.project'
local ToolbarButton = require 'class.ui.toolbar-button'

local welcome = {}

function welcome:enter()
	self.button = ToolbarButton {
		x = 50,
		y = 50,
		image = image.pencil,
		onPress = function() print 'hi!' end,
		isActive = function() return love.keyboard.isDown 'space' end,
	}
end

function welcome:directorydropped(path)
	local success = love.filesystem.mount(path, 'project')
	if not success then return end
	local project = Project(path, 'project')
	screenManager:switch(mainEditor, project)
end

function welcome:mousemoved(...)
	self.button:mousemoved(...)
end

function welcome:mousepressed(...)
	self.button:mousepressed(...)
end

function welcome:mousereleased(...)
	self.button:mousereleased(...)
end

function welcome:draw()
	love.graphics.push 'all'
	love.graphics.print 'drag a project folder onto the window to begin'
	self.button:draw()
	love.graphics.pop()
end

return welcome
