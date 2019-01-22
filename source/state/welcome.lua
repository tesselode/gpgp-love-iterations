local boxer = require 'lib.boxer'
local Button = require 'class.ui.button'
local image = require 'image'
local mainEditor = require 'state.main-editor'
local Project = require 'class.project'

local welcome = {}

function welcome:enter()
	self.button = Button {
		x = 50,
		y = 50,
		content = {
			boxer.image {image = image.pencil, transparent = true},
		},
		onPress = function() print 'hi!' end,
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
