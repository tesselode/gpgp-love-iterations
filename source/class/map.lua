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

function Map:moveLayerUp(layer)
	if layer == self.layers[1] then return end
	for i = 1, #self.layers - 1 do
		if layer == self.layers[i + 1] then
			local a = self.layers[i]
			local b = self.layers[i + 1]
			self.layers[i] = b
			self.layers[i + 1] = a
		end
	end
end

function Map:moveLayerDown(layer)
	if layer == self.layers[#self.layers] then return end
	for i = #self.layers, 2, -1 do
		if layer == self.layers[i - 1] then
			local a = self.layers[i]
			local b = self.layers[i - 1]
			self.layers[i] = b
			self.layers[i - 1] = a
		end
	end
end

function Map:renameLayer(layer, name)
	layer.name = name
end

function Map:draw()
	for i = #self.layers, 1, -1 do
		self.layers[i]:draw()
	end
end

return Map
