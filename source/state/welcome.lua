local font = require 'font'
local gamestate = require 'lib.gamestate'
local mainEditor = require 'state.main-editor'
local Project = require 'class.project'

local welcome = {}

function welcome:enter()
	self.text = love.graphics.newText(font.big)
	local string = [[Welcome to Mini Grid Placer.
	Drag a project folder onto this window to open it.]]
	self.text:setf(string, love.graphics.getWidth(), 'center')
end

function welcome:directorydropped(path)
	love.filesystem.mount(path, 'project')
	if not love.filesystem.getInfo 'project/config.lua' then return end
	local project = Project 'project'
	gamestate.switch(mainEditor, project)
end

function welcome:resize()
	local string = [[Welcome to Mini Grid Placer.
	Drag a project folder onto this window to open it.]]
	self.text:setf(string, love.graphics.getWidth(), 'center')
end

function welcome:draw()
	love.graphics.draw(self.text,
		0, love.graphics.getHeight() / 2,
		0,
		1, 1,
		0, self.text:getHeight() / 2)
end

return welcome
