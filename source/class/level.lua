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

function Level:addLayer(layerIndex, layer)
	local data = util.shallowCopy(self.data)
	data.layers = util.shallowCopy(data.layers)
	table.insert(data.layers, layerIndex, layer)
	return Level(self.project, data)
end

function Level:removeLayer(layerIndex)
	if #self.data.layers <= 1 then return self end
	local data = util.shallowCopy(self.data)
	data.layers = util.shallowCopy(data.layers)
	table.remove(data.layers, layerIndex)
	return Level(self.project, data)
end

function Level:moveLayerUp(layerIndex)
	if layerIndex <= 1 then return self end
	local data = util.shallowCopy(self.data)
	data.layers = util.shallowCopy(data.layers)
	local a = data.layers[layerIndex]
	local b = data.layers[layerIndex - 1]
	data.layers[layerIndex - 1] = a
	data.layers[layerIndex] = b
	return Level(self.project, data)
end

function Level:moveLayerDown(layerIndex)
	if layerIndex >= #self.data.layers then return self end
	local data = util.shallowCopy(self.data)
	data.layers = util.shallowCopy(data.layers)
	local a = data.layers[layerIndex]
	local b = data.layers[layerIndex + 1]
	data.layers[layerIndex + 1] = a
	data.layers[layerIndex] = b
	return Level(self.project, data)
end

function Level:setLayer(layerIndex, layer)
	local data = util.shallowCopy(self.data)
	data.layers = util.shallowCopy(data.layers)
	data.layers[layerIndex] = layer
	return Level(self.project, data)
end

function Level:export()
	local data = {}
	data.width = self.data.width
	data.height = self.data.height
	data.layers = {}
	for _, layer in ipairs(self.data.layers) do
		table.insert(data.layers, layer:export())
	end
	return data
end

function Level:draw()
	for _, layer in ipairs(self.data.layers) do
		layer:draw()
	end
end

return Level
