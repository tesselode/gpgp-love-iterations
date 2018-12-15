local font = require 'font'
local Object = require 'lib.classic'
local util = require 'util'

local Menu = Object:extend()

Menu.titlePadding = 16
Menu.columnPadding = 16
Menu.itemPadding = 4
Menu.bgColor = {.1, .1, .1}
Menu.textColor = {.9, .9, .9}
Menu.dividerColor = {.5, .5, .5}
Menu.highlightColor = {39/255, 175/255, 229/255}
Menu.transitionSpeed = 15

function Menu:new(screen)
	self.screenStack = {screen}
	self.screenStackPosition = 1
	self.selection = {{row = 1, column = 1}}
	self.drawXOffset = 0
	self.width = self:getTargetWidth()
end

function Menu:getTargetWidth()
	local numColumns = #self:getCurrentScreen().content
	return util.lerp(.5, .9, math.min(1, (numColumns - 1) / 2))
end

function Menu:getScreen(screenIndex)
	return self.screenStack[screenIndex]()
end

function Menu:getCurrentScreen()
	return self:getScreen(self.screenStackPosition)
end

function Menu:push(screen)
	self.screenStackPosition = self.screenStackPosition + 1
	self.screenStack[self.screenStackPosition] = screen
	self.selection[self.screenStackPosition] = {row = 1, column = 1}
end

function Menu:pop()
	if self.screenStackPosition == 1 then return false end
	self.screenStackPosition = self.screenStackPosition - 1
	return true
end

function Menu:up()
	local selection = self.selection[self.screenStackPosition]
	if selection.row > 1 then
		selection.row = selection.row - 1
	end
end

function Menu:down()
	local screen = self:getCurrentScreen()
	local selection = self.selection[self.screenStackPosition]
	if selection.row < #screen.content[selection.column] then
		selection.row = selection.row + 1
	end
end

function Menu:left()
	local screen = self:getCurrentScreen()
	local selection = self.selection[self.screenStackPosition]
	if selection.column > 1 then
		selection.column = selection.column - 1
	end
	if selection.row > #screen.content[selection.column] then
		selection.row = #screen.content[selection.column]
	end
end

function Menu:right()
	local screen = self:getCurrentScreen()
	local selection = self.selection[self.screenStackPosition]
	if selection.column < #screen.content then
		selection.column = selection.column + 1
	end
	if selection.row > #screen.content[selection.column] then
		selection.row = #screen.content[selection.column]
	end
end

function Menu:select()
	local screen = self:getCurrentScreen()
	local selection = self.selection[self.screenStackPosition]
	local item = screen.content[selection.column][selection.row]
	if item and item.onSelect then item.onSelect(self) end
end

function Menu:update(dt)
	self.width = util.lerp(self.width, self:getTargetWidth(), self.transitionSpeed * dt)
	self.drawXOffset = util.lerp(self.drawXOffset,
		self.screenStackPosition - 1,
		self.transitionSpeed * dt)
end

function Menu:drawColumn(screenIndex, columnIndex, columnWidth, columnHeight, column)
	local itemHeight = font.normal:getHeight() + self.itemPadding * 2
	local selection = self.selection[screenIndex]
	love.graphics.push 'all'
	local scroll = selection.row * itemHeight - columnHeight / 2
	scroll = math.min(#column * itemHeight - columnHeight, scroll)
	scroll = math.max(scroll, 0)
	love.graphics.translate(0, -scroll)
	for itemIndex, item in ipairs(column) do
		local y = itemHeight * (itemIndex - 1)
		if selection.column == columnIndex and selection.row == itemIndex then
			love.graphics.setColor(self.highlightColor)
			love.graphics.rectangle('fill', self.columnPadding, y,
				columnWidth - self.columnPadding * 2, itemHeight)
		end
		love.graphics.setColor(self.textColor)
		love.graphics.setFont(font.normal)
		love.graphics.print(item.text, self.itemPadding + self.columnPadding, y + self.itemPadding)
	end
	love.graphics.pop()
end

function Menu:drawScreen(menuWidth, menuHeight, screenIndex)
	local screen = self:getScreen(screenIndex)
	local columnWidth = menuWidth / #screen.content
	love.graphics.push 'all'
	love.graphics.setColor(self.textColor)
	love.graphics.setFont(font.big)
	love.graphics.print(screen.title, self.titlePadding, self.titlePadding)
	love.graphics.setColor(self.dividerColor)
	love.graphics.translate(0, font.big:getHeight() + 2 * self.titlePadding)
	love.graphics.line(self.titlePadding, 0, menuWidth - self.titlePadding, 0)
	love.graphics.translate(0, self.titlePadding)
	local columnContentHeight = menuHeight - (font.big:getHeight() + 3 * self.titlePadding)
	love.graphics.stencil(function()
		love.graphics.rectangle('fill', 0, 0, menuWidth, columnContentHeight)
	end, 'replace', 1)
	love.graphics.setStencilTest('greater', 0)
	for columnIndex, column in ipairs(screen.content) do
		love.graphics.push 'all'
		love.graphics.translate(columnWidth * (columnIndex - 1), 0)
		self:drawColumn(screenIndex, columnIndex, columnWidth, columnContentHeight, column)
		if columnIndex < #screen.content then
			love.graphics.setColor(self.dividerColor)
			love.graphics.line(columnWidth, 0, columnWidth, menuHeight)
		end
		love.graphics.pop()
	end
	love.graphics.pop()
end

function Menu:draw()
	local menuWidth = love.graphics.getWidth() * self.width
	local menuHeight = love.graphics.getHeight() * .9
	local menuX = (love.graphics.getWidth() - menuWidth) / 2
	local menuY = (love.graphics.getHeight() - menuHeight) / 2
	love.graphics.push 'all'
	love.graphics.setScissor(menuX, menuY, menuWidth, menuHeight)
	love.graphics.translate(menuX, menuY)
	love.graphics.setColor(self.bgColor)
	love.graphics.rectangle('fill', 0, 0, menuWidth, menuHeight)
	love.graphics.translate(-self.drawXOffset * menuWidth, 0)
	for screenIndex = 1, #self.screenStack do
		love.graphics.push 'all'
		love.graphics.translate(menuWidth * (screenIndex - 1), 0)
		self:drawScreen(menuWidth, menuHeight, screenIndex)
		love.graphics.pop()
	end
	love.graphics.pop()
end

return Menu
