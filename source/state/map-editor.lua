local Editor = require 'class.editor'
local Map = require 'class.map'

local mapEditor = {}

function mapEditor:enter(previous, project)
	self.project = project
	self.map = Map(self.project)
	self.editor = Editor(self.map)
end

function mapEditor:draw()
	self.editor:draw()
end

return mapEditor
