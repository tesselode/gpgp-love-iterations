local LevelEditor = require 'class.level-editor'
local Menu = require 'class.menu'

local main = {}

main.menuEnterSpeed = 20

function main:enter(_, project)
	self.project = project
	self.editors = {}
	for _, level in ipairs(self.project:loadLevels()) do
		table.insert(self.editors, LevelEditor(self.project, level))
	end
	self.selectedEditor = 1

	self.menu = Menu('Main menu', {
		{
			{text = 'New level'},
			{text = 'Save level...'},
			{text = 'Save level as...'},
			{text = 'Rename level...'},
			{text = 'Close project'},
		},
		{
			{text = 'Levels...'},
			{
				text = 'Layers...',
				onSelect = function(menu)
					menu:push('Layers', {
						{
							{text = 'Front tiles'},
							{text = 'Entities'},
							{text = 'Geometry'},
							{text = 'Back tiles'},
							{text = 'Front tiles'},
							{text = 'Entities'},
							{text = 'Geometry'},
							{text = 'Back tiles'},
							{text = 'Front tiles'},
							{text = 'Entities'},
							{text = 'Geometry'},
							{text = 'Back tiles'},
							{text = 'Front tiles'},
							{text = 'Entities'},
							{text = 'Geometry'},
							{text = 'Back tiles'},
							{text = 'Front tiles'},
							{text = 'Entities'},
							{text = 'Geometry'},
							{text = 'Back tiles'},
							{text = 'Front tiles'},
							{text = 'Entities'},
							{text = 'Geometry'},
							{text = 'Back tiles'},
							{text = 'Front tiles'},
							{text = 'Entities'},
							{text = 'Geometry'},
							{text = 'Back tiles'},
							{text = 'Front tiles'},
							{text = 'Entities'},
							{text = 'Geometry'},
							{text = 'Back tiles'},
							{text = 'Front tiles'},
							{text = 'Entities'},
							{text = 'Geometry'},
							{text = 'Back tiles'},
						},
						{
							{text = 'Add geometry layer'},
							{text = 'Add tile layer'},
							{text = 'Add entity layer'},
							{text = 'Move layer up'},
							{text = 'Move layer down'},
							{text = 'Remove layer'},
						}
					})
				end,
			},
			{text = 'Entities...'},
			{text = 'History...'},
		}
	})
	self.showMenu = false
	self.menuYOffset = -1
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
