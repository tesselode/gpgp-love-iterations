local LevelEditor = require 'class.level-editor'
local Menu = require 'class.menu'

local main = {}

function main:enter(_, project)
	self.project = project
	self.editors = {}
	for _, level in ipairs(self.project:loadLevels()) do
		table.insert(self.editors, LevelEditor(self.project, level))
	end
	self.selectedEditor = 1
	self.menu = Menu(function() return {
		{
			{
				text = 'Layers...',
				onSelect = function(menu)
					menu:push(function() return {
						{
							{text = 'Front tiles'},
							{text = 'Entities'},
							{text = 'Geometry'},
							{text = 'Back tiles'},
						},
						{
							{text = 'New layer'},
							{text = 'Move layer up'},
							{text = 'Move layer down'},
						},
					} end)
				end,
			},
		},
	} end)
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
	if key == 'left' then self.menu:left() end
	if key == 'right' then self.menu:right() end
	if key == 'up' then self.menu:up() end
	if key == 'down' then self.menu:down() end
	if key == 'return' then self.menu:select() end
	if key == 'escape' then self.menu:pop() end
end

function main:update(dt)
	self.menu:update(dt)
end

function main:draw()
	self:getCurrentEditor():draw()
	self.menu:draw()
end

return main
