local Editor = require 'class.editor'
local Layer = require 'class.layer'
local Map = require 'class.map'

local mapEditor = {}

function mapEditor:enter(previous, project)
	self.project = project
	self.map = Map(self.project)
	self.editor = Editor(self.map)
	self.showSidebar = false
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

function mapEditor:createViewMenu()
	if imgui.BeginMenu 'View' then
		if imgui.MenuItem('Sidebar ' .. (self.showSidebar and '*' or '')) then
			self.showSidebar = not self.showSidebar
		end
		imgui.EndMenu()
	end
end

function mapEditor:createSidebar()
	imgui.SetNextWindowPos(0, 24)
	imgui.SetNextWindowSize(300, 0)
	self.showSidebar = imgui.Begin('Layers', true, {
		'ImGuiWindowFlags_NoTitleBar',
		'ImGuiWindowFlags_NoResize',
		'ImGuiWindowFlags_NoMove',
	})

	-- layer select
	local showEntitySelect = self.editor:getCurrentLayer():is(Layer.Entity)
	local listBoxHeight = showEntitySelect and 8 or 16

	do
		imgui.PushItemWidth(-1)
		imgui.Text 'Layers'
		local layers = {}
		for _, layer in ipairs(self.map.layers) do
			table.insert(layers, layer.name .. ' (' .. layer.type .. ')')
		end
		local newSelection = imgui.ListBox('Layers', self.editor.currentLayer, layers, #layers, listBoxHeight)
		if newSelection ~= self.editor.currentLayer then
			self.editor:setCurrentLayer(self.map.layers[newSelection])
		end
		imgui.PopItemWidth()
	end

	-- entity select
	if showEntitySelect then
		imgui.Text 'Entities'
		imgui.PushItemWidth(-1)
		local entities = {}
		for _, entity in ipairs(self.project.config.entities) do
			table.insert(entities, entity.name)
		end
		local currentItem = self.editor.currentItem[self.editor:getCurrentLayer()]
		local newSelection = imgui.ListBox('Entities', currentItem, entities, #entities, listBoxHeight)
		if newSelection ~= currentItem then
			self.editor:setCurrentItem(self.project.config.entities[newSelection])
		end
		imgui.PopItemWidth()
	end

	-- layer options
	imgui.Text 'Layer options'
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

function mapEditor:drawGui()
	if imgui.BeginMainMenuBar() then
		self:createLayerMenu()
		if self.editor:getCurrentLayer():is(Layer.Entity) then
			self:createEntitiesMenu()
		end
		self:createViewMenu()
		imgui.EndMainMenuBar()
	end
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
