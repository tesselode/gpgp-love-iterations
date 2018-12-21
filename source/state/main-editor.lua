local Button = require 'class.ui.button'
local gamestate = require 'lib.gamestate'
local GeometryLayer = require 'class.layer.geometry'
local image = require 'image'
local LevelEditor = require 'class.level-editor'
local Menu = require 'class.menu'
local textInputModal = require 'state.text-input-modal'
local TileLayer = require 'class.layer.tile'
local tilePicker = require 'state.tile-picker'
local Toolbar = require 'class.ui.toolbar'
local util = require 'util'

local main = {}

main.menuEnterSpeed = 20

function main:createLevelsMenu()
	local function levelList()
		local levels = {}
		for editorIndex, editor in ipairs(self.editors) do
			local text = editor.levelName or 'New level'
			if editorIndex == self.selectedEditor then
				text = text .. ' (current)'
			end
			table.insert(levels, {
				text = text,
				onSelect = function()
					self.selectedEditor = editorIndex
				end,
			})
		end
		return levels
	end
	local levelActions = {
		{
			text = 'New level',
			onSelect = function()
				table.insert(self.editors, LevelEditor(self.project))
				self.selectedEditor = #self.editors
			end,
		},
		{
			text = 'Save level...',
			onSelect = function()
				self:save()
			end,
		},
		{
			text = 'Save level as...',
			onSelect = function()
				self:save(true)
			end,
		},
	}
	return {levelList, levelActions}
end

function main:createAddTileLayerMenu()
	local editor = self.editors[self.selectedEditor]
	return {function()
		local tilesets = {}
		for _, tileset in ipairs(editor.project.tilesets) do
			table.insert(tilesets, {
				text = tileset.name,
				onSelect = function(menu)
					editor:addLayer('tile', tileset.name)
					menu:pop()
				end,
			})
		end
		return tilesets
	end}
end

function main:createLayersMenu()
	local editor = self.editors[self.selectedEditor]
	local function layerList()
		local level = editor:getCurrentLevelState()
		local layers = {}
		for layerIndex, layer in ipairs(level.data.layers) do
			local text = ''
			if layerIndex == editor.selectedLayerIndex then
				text = text .. '*'
			end
			text = text .. layer.data.name
			if layer:is(GeometryLayer) then
				text = text .. ' (geometry)'
			elseif layer:is(TileLayer) then
				text = text .. ' (tile - ' .. layer.data.tilesetName .. ')'
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
				editor:addLayer 'geometry'
			end,
		},
		{
			text = 'Add tile layer...',
			onSelect = function(menu)
				menu:push('Select tileset', self:createAddTileLayerMenu())
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
			text = 'Rename layer',
			onSelect = function()
				gamestate.push(textInputModal,
					'Enter a new name for the layer',
					'',
					function(name) editor:renameLayer(name) end)
			end,
		},
		{
			text = 'Remove layer',
			onSelect = function() editor:removeLayer() end,
		},
	}
	return {layerList, layerActions}
end

function main:createHistoryMenu()
	local editor = self.editors[self.selectedEditor]
	return {function()
		local history = {}
		for i = #editor.levelHistory, 1, -1 do
			local step = editor.levelHistory[i]
			local text = step.description
			if i == editor.levelHistoryPosition then
				text = text .. ' (current)'
			end
			table.insert(history, {
				text = text,
				onSelect = function()
					editor.levelHistoryPosition = i
				end,
			})
		end
		return history
	end}
end

function main:initMenu()
	self.menu = Menu('Main menu', {
		{
			{
				text = 'Levels...',
				onSelect = function(menu)
					menu:push('Levels', self:createLevelsMenu())
				end,
			},
			{
				text = 'Layers...',
				onSelect = function(menu)
					menu:push('Layers', self:createLayersMenu())
				end,
			},
			{
				text = 'History...',
				onSelect = function(menu)
					menu:push('History', self:createHistoryMenu())
				end,
			},
			{
				text = 'Close project',
				onSelect = function() gamestate.switch(require 'state.welcome') end,
			},
		}
	})
	self.showMenu = false
	self.menuTransitonPosition = 0
end

function main:initToolbar()
	self.toolbar = Toolbar {
		onSelectPencilTool = function()
			self:getCurrentEditor():setTool 'pencil'
		end,
		onSelectBoxTool = function()
			self:getCurrentEditor():setTool 'box'
		end,
	}
end

function main:enter(_, project)
	self.project = project
	self.editors = {}
	for levelName, level in self.project:getLevels() do
		table.insert(self.editors, LevelEditor(self.project, levelName, level))
	end
	if #self.editors == 0 then
		table.insert(self.editors, LevelEditor(self.project))
	end
	self.selectedEditor = 1
	self:initMenu()
	self:initToolbar()
end

function main:save(saveAs)
	local editor = self.editors[self.selectedEditor]
	if (not editor.levelName) or saveAs then
		gamestate.push(textInputModal,
			'Enter a name for the level',
			'',
			function(name)
				editor:save(name)
			end
		)
	else
		editor:save()
	end
end

function main:getCurrentEditor()
	return self.editors[self.selectedEditor]
end

function main:mousemoved(x, y, dx, dy, istouch)
	if not self.showMenu then
		self.toolbar:mousemoved(x, y, dx, dy, istouch)
		if not self.toolbar:pointInBounds(x, y) then
			self:getCurrentEditor():mousemoved(x, y, dx, dy, istouch)
		end
	end
end

function main:mousepressed(x, y, button, istouch, presses)
	if not self.showMenu then
		self.toolbar:mousepressed(x, y, button, istouch, presses)
		if not self.toolbar:pointInBounds(x, y) then
			self:getCurrentEditor():mousepressed(x, y, button, istouch, presses)
		end
	end
end

function main:mousereleased(x, y, button, istouch, presses)
	if not self.showMenu then
		self.toolbar:mousereleased(x, y, button, istouch, presses)
		if not self.toolbar:pointInBounds(x, y) then
			self:getCurrentEditor():mousereleased(x, y, button, istouch, presses)
		end
	end
end

function main:wheelmoved(x, y)
	if not self.showMenu then
		self:getCurrentEditor():wheelmoved(x, y)
	end
end

function main:keypressed(key, scancode, isrepeat)
	local selectedLayer = self:getCurrentEditor():getSelectedLayer()
	if key == 'tab' then
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
	else
		if key == 'space' and selectedLayer:is(TileLayer) then
			gamestate.push(
				tilePicker,
				self.project.tilesets[selectedLayer.data.tilesetName],
				function(stamp) self:getCurrentEditor():setTileStamp(stamp) end
			)
		else
			self:getCurrentEditor():keypressed(key, scancode, isrepeat)
		end
	end
end

function main:update(dt)
	self.menu:update(dt)
	local targetMenuTransitonPosition = self.showMenu and 1 or 0
	self.menuTransitonPosition = util.lerp(self.menuTransitonPosition,
		targetMenuTransitonPosition, self.menuEnterSpeed * dt)
end

function main:drawMenu()
	love.graphics.push 'all'
	love.graphics.setColor(0, 0, 0, self.menuTransitonPosition / 2)
	love.graphics.rectangle('fill', 0, 0, love.graphics.getWidth(), love.graphics.getHeight())
	love.graphics.translate(0, (self.menuTransitonPosition - 1) * love.graphics.getHeight())
	self.menu:draw()
	love.graphics.pop()
end

function main:draw()
	self:getCurrentEditor():draw()
	self.toolbar:draw(self:getCurrentEditor().tool)
	self:drawMenu()
end

return main
