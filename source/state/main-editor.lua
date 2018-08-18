local Editor = require 'class.editor'
local Layer = require 'class.layer'
local Map = require 'class.map'
local suit = require 'lib.suit'

local mainEditor = {}

function mainEditor:enter(previous, project)
	self.project = project
	self.map = Map(self.project)
	self.editor = Editor(self.map)
	self.showSidebar = true
	self.layerRenameText = ''
	self.mapNameInput = {text = self.map.name}
	self.mapWidthInput = {text = tostring(self.map.width)}
	self.mapHeightInput = {text = tostring(self.map.height)}
	self.scrollbar = {value = 0}
end

function mainEditor:createMapPropertiesGui()
	suit.Label('Map', {align = 'left'}, suit.layout:row(300, 30))
	suit.layout:push(suit.layout:row())
	suit.Label('Name:', {align = 'left'}, suit.layout:col(50, 30))
	suit.Input(self.mapNameInput, suit.layout:col(250, 30))
	self.map.name = self.mapNameInput.text
	suit.layout:pop()
	suit.layout:push(suit.layout:row())
	suit.Label('Size:', {align = 'left'}, suit.layout:col(50, 30))
	suit.Input(self.mapWidthInput, suit.layout:col(125, 30))
	suit.Input(self.mapHeightInput, suit.layout:col())
	if tonumber(self.mapWidthInput.text) then
		self.map.width = math.max(1, tonumber(self.mapWidthInput.text))
	end
	if tonumber(self.mapHeightInput.text) then
		self.map.height = math.max(1, tonumber(self.mapHeightInput.text))
	end
	suit.layout:pop()
end

function mainEditor:createLayerListGui()
	suit.Label('Layers', {align = 'left'}, suit.layout:row(300, 30))
	for _, layer in ipairs(self.map.layers) do
		local label = layer.name .. ' (' .. layer.type .. ')'
		if suit.Button(label, {id = layer}, suit.layout:row(300, 30)).hit then
			self.editor:setCurrentLayer(layer)
		end
	end
end

function mainEditor:createLayerPropertiesGui()
	if suit.Button('Add geometry layer', suit.layout:row(300, 30)).hit then
		self.map:addLayer(self.editor.currentLayer, 'Geometry')
	end
end

function mainEditor:updateGui()
	suit.layout:reset(10, 10)
	suit.layout:padding(10, 10)

	self:createMapPropertiesGui()
	self:createLayerListGui()
	self:createLayerPropertiesGui()
end

function mainEditor:update(dt)
	self.editor:update(dt)
	self:updateGui()
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
	suit.draw()
end

return mainEditor
