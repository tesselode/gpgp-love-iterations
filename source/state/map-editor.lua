local Editor = require 'class.editor'
local Layer = require 'class.layer'
local Map = require 'class.map'

local mapEditor = {}

function mapEditor:enter(previous, project)
	self.project = project
	self.map = Map(self.project)
	self.editor = Editor(self.map)
	self.showSidebar = true
	self.layerRenameText = ''
end

function mapEditor:update(dt)
	self.editor:update(dt)
end

function mapEditor:keypressed(key)
	if key == 'tab' then self.showSidebar = not self.showSidebar end
end

function mapEditor:wheelmoved(...)
	self.editor:wheelmoved(...)
end

function mapEditor:leave()
	self.map:leave()
end

function mapEditor:createSidebar()
	imgui.SetNextWindowPos(0, 0)
	imgui.SetNextWindowSize(250, 0)
	self.showSidebar = imgui.Begin('Layers', true, {
		'ImGuiWindowFlags_NoTitleBar',
		'ImGuiWindowFlags_NoResize',
		'ImGuiWindowFlags_NoMove',
	})

	-- layer select
	do
		imgui.PushItemWidth(-1)
		imgui.Text 'Layers'
		local layers = {}
		for _, layer in ipairs(self.map.layers) do
			table.insert(layers, layer.name .. ' (' .. layer.type .. ')')
		end
		local newSelection = imgui.ListBox('Layers', self.editor.currentLayer, layers, #layers, 10)
		if newSelection ~= self.editor.currentLayer then
			self.editor:setCurrentLayer(self.map.layers[newSelection])
		end
		imgui.PopItemWidth()
	end

	-- layer options
	imgui.Text 'Layer options'
	imgui.PushItemWidth(-1)
	self.editor:getCurrentLayer().name = imgui.InputText('', self.editor:getCurrentLayer().name, 100)
	imgui.PopItemWidth()
	if imgui.Button('Move up', (imgui.GetWindowSize() - 25)/2, 0) then
		self.map:moveLayerUp(self.editor:getCurrentLayer())
	end
	imgui.SameLine()
	if imgui.Button('Move down', (imgui.GetWindowSize() - 25)/2, 0) then
		self.map:moveLayerDown(self.editor:getCurrentLayer())
	end
	if imgui.Button('Add geometry layer', -1, 0) then
		self.map:addLayer(self.editor.currentLayer, 'Geometry')
	end
	if imgui.Button('Add entity layer', -1, 0) then
		self.map:addLayer(self.editor.currentLayer, 'Entity')
	end
	if imgui.Button('Remove layer', -1, 0) then
		self.map:removeLayer(self.editor:getCurrentLayer())
	end

	-- entity select
	if self.editor:getCurrentLayer():is(Layer.Entity) then
		imgui.Text 'Entities'
		imgui.PushItemWidth(-1)
		local entities = {}
		for _, entity in ipairs(self.project.config.entities) do
			table.insert(entities, entity.name)
		end
		local currentItem = self.editor.currentItem[self.editor:getCurrentLayer()]
		local newSelection = imgui.ListBox('Entities', currentItem, entities, #entities, 10)
		if newSelection ~= currentItem then
			self.editor:setCurrentItem(self.project.config.entities[newSelection])
		end
		imgui.PopItemWidth()
	end

	imgui.End()
end

function mapEditor:drawGui()
	if self.showSidebar then
		self:createSidebar()
	end
	imgui.Render()
end

function mapEditor:draw()
	self.editor:draw()
	self:drawGui()
end

return mapEditor
