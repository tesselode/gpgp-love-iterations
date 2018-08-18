local Editor = require 'class.editor'
local Layer = require 'class.layer'
local Map = require 'class.map'

local mapEditor = {}

function mapEditor:enter(previous, project)
	self.project = project
	self.map = Map(self.project)
	self.editor = Editor(self.map)
	self.showLayersWindow = false
	self.layerRenameText = ''
end

function mapEditor:update(dt)
	self.editor:update(dt)
end

function mapEditor:wheelmoved(...)
	self.editor:wheelmoved(...)
end

function mapEditor:leave()
	self.map:leave()
end

function mapEditor:createLayerMenu()
	if imgui.BeginMenu('Layers [' .. self.editor:getCurrentLayer().name .. ']') then
		for _, layer in ipairs(self.map.layers) do
			local layerNameString = self.editor:getCurrentLayer() == layer and '* ' or ''
			layerNameString = layerNameString .. layer.name
			if imgui.MenuItem(layerNameString) then
				self.editor:setCurrentLayer(layer)
			end
		end
		imgui.EndMenu()
	end
end

function mapEditor:createEntitiesMenu()
	if imgui.BeginMenu('Entities [' .. self.editor:getCurrentItem().name .. ']') then
		for _, entity in ipairs(self.project.config.entities) do
			local entityNameString = entity == self.editor:getCurrentItem() and '* ' or ''
			entityNameString = entityNameString .. entity.name
			if imgui.MenuItem(entityNameString) then
				self.editor:setCurrentItem(entity)
			end
		end
		imgui.EndMenu()
	end
end

function mapEditor:createWindowsMenu()
	if imgui.BeginMenu 'Windows' then
		if imgui.MenuItem 'Layers' then
			self.showLayersWindow = true
		end
		imgui.EndMenu()
	end
end

function mapEditor:createLayersWindow()
	if self.showLayersWindow then
		self.showLayersWindow = imgui.Begin('Layers', true)

		-- layer select
		imgui.PushItemWidth(-1)
		local layers = {}
		for _, layer in ipairs(self.map.layers) do
			table.insert(layers, layer.name .. ' (' .. layer.type .. ')')
		end
		local newSelection = imgui.ListBox('', self.editor.currentLayer, layers, #layers, 10)
		if newSelection ~= self.editor.currentLayer then
			self.editor:setCurrentLayer(self.map.layers[newSelection])
		end
		imgui.PopItemWidth()

		-- buttons
		if imgui.Button('Move up', -1, 0) then
			self.map:moveLayerUp(self.editor:getCurrentLayer())
		end
		if imgui.Button('Move down', -1, 0) then
			self.map:moveLayerDown(self.editor:getCurrentLayer())
		end
		imgui.PushItemWidth(-100)
		self.layerRenameText = imgui.InputText('', self.layerRenameText, 100)
		imgui.PopItemWidth()
		imgui.SameLine()
		if imgui.Button('Rename', 91, 0) then
			self.map:renameLayer(self.editor:getCurrentLayer(), self.layerRenameText)
			self.layerRenameText = ''
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
		imgui.End()
	end
end

function mapEditor:drawGui()
	if imgui.BeginMainMenuBar() then
		self:createLayerMenu()
		if self.editor:getCurrentLayer():is(Layer.Entity) then
			self:createEntitiesMenu()
		end
		self:createWindowsMenu()
		imgui.EndMainMenuBar()
	end
	if self.showLayersWindow then
		self:createLayersWindow()
	end
	imgui.Render()
end

function mapEditor:draw()
	self.editor:draw()
	self:drawGui()
end

return mapEditor
