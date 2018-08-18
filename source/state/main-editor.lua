local Editor = require 'class.editor'
local Layer = require 'class.layer'
local Map = require 'class.map'

local mainEditor = {}

function mainEditor:enter(previous, project)
	self.project = project
	self.map = Map(self.project)
	self.editor = Editor(self.map)
	self.showSidebar = true
	self.layerRenameText = ''
end

function mainEditor:update(dt)
	self.editor:update(dt)
end

function mainEditor:keypressed(key)
	if key == 'tab' then self.showSidebar = not self.showSidebar end
end

function mainEditor:wheelmoved(...)
	self.editor:wheelmoved(...)
end

function mainEditor:leave()
	self.map:leave()
end

function mainEditor:draw()
	self.editor:draw()
end

return mainEditor
