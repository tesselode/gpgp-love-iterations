local Layer = require 'class.layer'
local Object = require 'lib.classic'

local Map = Object:extend()

function Map:new(project)
	self.project = project
	self.width = self.project.config.defaultSettings.width
	self.height = self.project.config.defaultSettings.height
	self.layers = {}
	for _, layer in ipairs(self.project.config.defaultSettings.layers) do
		table.insert(self.layers, Layer[layer.type](self, layer.name))
	end
end

function Map:draw()
	for _, layer in ipairs(self.layers) do
		layer:draw()
	end
end

return Map
