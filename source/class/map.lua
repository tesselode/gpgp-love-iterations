local Layer = require 'class.layer'
local Object = require 'lib.classic'
local signal = require 'lib.signal'

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

function Map:getLayerPosition(layer)
	for i = 1, #self.layers do
		if self.layers[i] == layer then
			return i
		end
	end
end

function Map:moveLayerUp(layer)
	local position = self:getLayerPosition(layer)
	if position == 1 then return end
	local above = self.layers[position - 1]
	self.layers[position] = above
	self.layers[position - 1] = layer
	signal.emit('moved layer up')
end

function Map:moveLayerDown(layer)
	local position = self:getLayerPosition(layer)
	if position == #self.layers then return end
	local below = self.layers[position + 1]
	self.layers[position] = below
	self.layers[position + 1] = layer
	signal.emit('moved layer down')
end

function Map:renameLayer(layer, name)
	layer.name = name
end

function Map:addLayer(selectedLayer, type)
	local position = self:getLayerPosition(selectedLayer)
	table.insert(self.layers, position, Layer[type](self, type))
end

function Map:draw()
	for i = #self.layers, 1, -1 do
		self.layers[i]:draw()
	end
end

return Map
