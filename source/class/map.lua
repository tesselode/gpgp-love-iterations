local bitser = require 'lib.bitser'
local inspect = require 'lib.inspect'
local Layer = require 'class.layer'
local Object = require 'lib.classic'
local signal = require 'lib.signal'

local Map = Object:extend()

function Map:new(project)
	self.project = project
	self.name = 'New map'
	self.width = self.project.config.defaultSettings.width
	self.height = self.project.config.defaultSettings.height
	self.layers = {}
	for _, layer in ipairs(self.project.config.defaultSettings.layers) do
		table.insert(self.layers, Layer[layer.type](self, layer.name))
	end
end

function Map:save()
	local data = {
		name = self.name,
		width = self.width,
		height = self.height,
		layers = {},
	}
	for _, layer in ipairs(self.layers) do
		table.insert(data.layers, {
			type = layer.type,
			name = layer.name,
			data = layer:save(),
		})
	end
	local path = self.project.path .. '/maps/' .. self.name .. '.map'
	local file = io.open(path, 'w')
	file:write(bitser.dumps(data))
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

function Map:addLayer(position, type)
	local layer = Layer[type](self, type)
	table.insert(self.layers, position, layer)
	signal.emit('added layer', layer)
end

function Map:removeLayer(layer)
	if #self.layers == 1 then return end
	table.remove(self.layers, self:getLayerPosition(layer))
	signal.emit('removed layer', layer)
end

function Map:draw()
	for i = #self.layers, 1, -1 do
		self.layers[i]:draw()
	end
end

return Map
