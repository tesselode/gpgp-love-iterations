local Map = require 'class.map'

local editor = {}

function editor:enter(previous, project)
	self.project = project
	self.map = Map(self.project)
end

function editor:draw()
	self.map:draw()
end

return editor
