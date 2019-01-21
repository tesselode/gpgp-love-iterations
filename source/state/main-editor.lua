local gamestate = require 'lib.gamestate'
local LevelEditor = require 'class.level-editor'
local textInputModal = require 'state.text-input-modal'
local TileLayer = require 'class.layer.tile'
local tilePicker = require 'state.tile-picker'

local main = {}

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
	self:getCurrentEditor():mousemoved(x, y, dx, dy, istouch)
end

function main:mousepressed(x, y, button, istouch, presses)
	self:getCurrentEditor():mousepressed(x, y, button, istouch, presses)
end

function main:mousereleased(x, y, button, istouch, presses)
	self:getCurrentEditor():mousereleased(x, y, button, istouch, presses)
end

function main:wheelmoved(x, y)
	self:getCurrentEditor():wheelmoved(x, y)
end

function main:keypressed(key, scancode, isrepeat)
	local selectedLayer = self:getCurrentEditor():getSelectedLayer()
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

function main:draw()
	self:getCurrentEditor():draw()
end

return main
