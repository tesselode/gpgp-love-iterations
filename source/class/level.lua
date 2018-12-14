local GeometryLayer = require 'class.layer.geometry'
local Object = require 'lib.classic'
local util = require 'util'

local Level = Object:extend()

function Level:new(project, data)
	self.project = project
	self.data = data or {
		width = project.defaultLevelWidth,
		height = project.defaultLevelHeight,
		layers = {GeometryLayer()},
	}
end

function Level:setLayer(layerIndex, layer)
	local data = util.shallowCopy(self.data)
	data.layers = util.shallowCopy(data.layers)
	data.layers[layerIndex] = layer
	return Level(self.project, data)
end

function Level:draw()
	for _, layer in ipairs(self.data.layers) do
		layer:draw()
	end
end

return Level
