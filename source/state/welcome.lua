local mainEditor = require 'state.main-editor'
local Project = require 'class.project'
local Menu = require 'class.ui.menu'

local welcome = {}

function welcome:enter()
	self.menu = Menu(50, 50, 'test menu', {
		function()
			local options = {}
			for i = 1, 50 do
				table.insert(options, {
					text = i,
					onPress = function() print(i) end,
				})
			end
			return options
		end,
		function()
			local options = {}
			for i = 1, 5 do
				table.insert(options, {
					text = i,
					onPress = function() print 'hi!' end,
				})
			end
			return options
		end,
	})
end

function welcome:directorydropped(path)
	local success = love.filesystem.mount(path, 'project')
	if not success then return end
	local project = Project(path, 'project')
	screenManager:switch(mainEditor, project)
end

function welcome:mousemoved(...)
	self.menu:mousemoved(...)
end

function welcome:mousepressed(...)
	self.menu:mousepressed(...)
end

function welcome:mousereleased(...)
	self.menu:mousereleased(...)
end

function welcome:draw()
	love.graphics.push 'all'
	love.graphics.print 'drag a project folder onto the window to begin'
	self.menu:draw()
	love.graphics.pop()
end

return welcome
