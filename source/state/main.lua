local GeometryLayer = require 'class.layer.geometry'
local LevelEditor = require 'class.level-editor'
local Menu = require 'class.menu'

local main = {}

main.menuEnterSpeed = 20

function main:createLayersMenu()
	local editor = self.editors[self.selectedEditor]
	local function layerList()
		local level = editor:getCurrentLevelState()
		local layers = {}
		for layerIndex, layer in ipairs(level.data.layers) do
			local text = layer.data.name
			if layerIndex == editor.selectedLayerIndex then
				text = text .. ' (selected)'
			end
			table.insert(layers, {
				text = text,
				onSelect = function()
					editor.selectedLayerIndex = layerIndex
				end,
			})
		end
		return layers
	end
	local layerActions = {
		{
			text = 'Add geometry layer',
			onSelect = function()
				editor:addLayer(GeometryLayer())
			end,
		},
		{
			text = 'Move layer up',
			onSelect = function() editor:moveLayerUp() end,
		},
		{
			text = 'Move layer down',
			onSelect = function() editor:moveLayerDown() end,
		},
		{
			text = 'Remove layer',
			onSelect = function() editor:removeLayer() end,
		},
	}
	return {layerList, layerActions}
end

function main:initMenu()
	self.menu = Menu('Main menu', {
		{
			{
				text = 'Layers...',
				onSelect = function(menu)
					menu:push('Layers', self:createLayersMenu())
				end,
			}
		}
	})
	self.showMenu = false
	self.menuYOffset = -1
end

function main:enter(_, project)
	self.project = project
	self.editors = {}
	for _, level in ipairs(self.project:loadLevels()) do
		table.insert(self.editors, LevelEditor(self.project, level))
	end
	self.selectedEditor = 1
	self:initMenu()
end

function main:getCurrentEditor()
	return self.editors[self.selectedEditor]
end

function main:mousemoved(x, y, dx, dy, istouch)
	self:getCurrentEditor():mousemoved(x, y, dx, dy, istouch)
end

function main:mousepressed(x, y, button, istouch, presses)
	self:getCurrentEditor():mousepressed(x, y, button, istouch, presses)
end

function main:wheelmoved(x, y)
	self:getCurrentEditor():wheelmoved(x, y)
end

function main:keypressed(key, scancode, isrepeat)
	self:getCurrentEditor():keypressed(key, scancode, isrepeat)
	if key == 'space' then
		self.showMenu = not self.showMenu
	end
	if key == 'escape' then
		if not self.menu:pop() then
			self.showMenu = false
		end
	end
	if self.showMenu then
		if key == 'left' then self.menu:left() end
		if key == 'right' then self.menu:right() end
		if key == 'up' then self.menu:up() end
		if key == 'down' then self.menu:down() end
		if key == 'return' then self.menu:select() end
	end
end

function main:update(dt)
	self.menu:update(dt)
	local targetMenuYOffset = self.showMenu and 0 or -1
	self.menuYOffset = self.menuYOffset + (targetMenuYOffset - self.menuYOffset) * self.menuEnterSpeed * dt
end

function main:draw()
	self:getCurrentEditor():draw()
	love.graphics.push 'all'
	love.graphics.translate(0, self.menuYOffset * love.graphics.getHeight())
	self.menu:draw()
	love.graphics.pop()
end

return main
