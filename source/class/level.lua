local GeometryLayer = require 'layer.geometry'
local Object = require 'lib.classic'

local Level = Object:extend()

function Level:new(project)
	self.project = project
	self.width = project.defaultLevelWidth
	self.height = project.defaultLevelHeight
	self.layers = {GeometryLayer()}
end

function Level:setLayer(layerIndex, layer)
	local level = Level()
	level.project = self.project
	level.width = self.width
	level.height = self.height
	for i, v in ipairs(self.layers) do
		if i == layerIndex then
			level.layers[i] = layer
		else
			level.layers[i] = v
		end
	end
	return level
end

return Level
