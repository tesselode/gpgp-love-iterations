local Editor = require 'class.editor'
local Layer = require 'class.layer'
local Map = require 'class.map'

local mapEditor = {}

function mapEditor:enter(previous, project)
	self.project = project
	self.map = Map(self.project)
	self.editor = Editor(self.map)
end

function mapEditor:update(dt)
	self.editor:update(dt)
end

function mapEditor:wheelmoved(...)
	self.editor:wheelmoved(...)
end

function mapEditor:drawGui()
	if imgui.BeginMainMenuBar() then
		if imgui.BeginMenu('Layers [' .. self.editor.selectedLayer.name .. ']') then
			for _, layer in ipairs(self.map.layers) do
				local layerNameString = ''
				if self.editor.selectedLayer == layer then
					layerNameString = layerNameString .. '* '
				end
				layerNameString = layerNameString .. layer.name
				if imgui.MenuItem(layerNameString) then
					self.editor:switchLayer(layer)
				end
			end
			imgui.EndMenu()
		end
		if self.editor.selectedLayer:is(Layer.Entity) then
			local selected = self.editor.paletteSelection[self.editor.selectedLayer]
			if imgui.BeginMenu('Entities [' .. self.project.config.entities[selected].name .. ']') then
				for i, entity in ipairs(self.project.config.entities) do
					local entityNameString = i == selected and '* ' or ''
					entityNameString = entityNameString .. entity.name
					if imgui.MenuItem(entityNameString) then
						self.editor:setSelected(i)
					end
				end
				imgui.EndMenu()
			end
		end
		imgui.EndMainMenuBar()
	end
	imgui.Render()
end

function mapEditor:draw()
	self.editor:draw()
	self:drawGui()
end

return mapEditor
