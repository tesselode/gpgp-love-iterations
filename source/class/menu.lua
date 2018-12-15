local Object = require 'lib.classic'

local Menu = Object:extend()

Menu.margin = 50
Menu.itemMargin = 2
Menu.bgColor = {.1, .1, .1}
Menu.textColor = {.9, .9, .9}
Menu.highlightColor = {39/255, 175/255, 229/255}
Menu.transitionSpeed = 20

love.graphics.setFont(love.graphics.newFont(18))

function Menu:new(screen)
	self.screenStack = {screen}
	self.screenStackPosition = 1
	self.selection = {{row = 1, column = 1}}
	self.drawXOffset = 0
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
	if self.screenStackPosition > 1 then
		self.screenStackPosition = self.screenStackPosition - 1
	end
end

function Menu:up()
	local screen = self:getCurrentScreen()
	local selection = self.selection[self.screenStackPosition]
	selection.row = selection.row - 1
	if selection.row == 0 then
		selection.row = #screen[selection.column]
	end
end

function Menu:down()
	local screen = self:getCurrentScreen()
	local selection = self.selection[self.screenStackPosition]
	selection.row = selection.row + 1
	if selection.row == #screen[selection.column] + 1 then
		selection.row = 1
	end
end

function Menu:left()
	local screen = self:getCurrentScreen()
	local selection = self.selection[self.screenStackPosition]
	if selection.column > 1 then
		selection.column = selection.column - 1
	end
	if selection.row > #screen[selection.column] then
		selection.row = #screen[selection.column]
	end
end

function Menu:right()
	local screen = self:getCurrentScreen()
	local selection = self.selection[self.screenStackPosition]
	if selection.column < #screen then
		selection.column = selection.column + 1
	end
	if selection.row > #screen[selection.column] then
		selection.row = #screen[selection.column]
	end
end

function Menu:select()
	local screen = self:getCurrentScreen()
	local selection = self.selection[self.screenStackPosition]
	local item = screen[selection.column][selection.row]
	if item and item.onSelect then item.onSelect(self) end
end

function Menu:update(dt)
	self.drawXOffset = self.drawXOffset + (self.screenStackPosition - 1 - self.drawXOffset) * self.transitionSpeed * dt
end

function Menu:drawColumn(screenIndex, columnIndex, columnWidth, column)
	local itemHeight = love.graphics.getFont():getHeight() + self.itemMargin * 2
	local selection = self.selection[screenIndex]
	love.graphics.push 'all'
	for itemIndex, item in ipairs(column) do
		local y = itemHeight * (itemIndex - 1)
		if selection.column == columnIndex and selection.row == itemIndex then
			love.graphics.setColor(self.highlightColor)
			love.graphics.rectangle('fill', 0, y, columnWidth, itemHeight)
		end
		love.graphics.setColor(self.textColor)
		love.graphics.print(item.text, self.itemMargin, y + self.itemMargin)
	end
	love.graphics.pop()
end

function Menu:drawScreen(menuWidth, screenIndex)
	local screen = self:getScreen(screenIndex)
	local columnWidth = menuWidth / #screen
	for columnIndex, column in ipairs(screen) do
		love.graphics.push 'all'
		love.graphics.translate(columnWidth * (columnIndex - 1), 0)
		self:drawColumn(screenIndex, columnIndex, columnWidth, column)
		love.graphics.pop()
	end
end

function Menu:draw()
	local menuWidth = love.graphics.getWidth() - self.margin * 2
	local menuHeight = love.graphics.getHeight() - self.margin * 2
	love.graphics.push 'all'
	love.graphics.translate(self.margin, self.margin)
	love.graphics.setColor(self.bgColor)
	love.graphics.rectangle('fill', 0, 0, menuWidth, menuHeight)
	love.graphics.stencil(function()
		love.graphics.rectangle('fill', 0, 0, menuWidth, menuHeight)
	end, 'replace', 1)
	love.graphics.setStencilTest('greater', 0)
	love.graphics.translate(-self.drawXOffset * menuWidth, 0)
	for screenIndex = 1, #self.screenStack do
		love.graphics.push 'all'
		love.graphics.translate(menuWidth * (screenIndex - 1), 0)
		self:drawScreen(menuWidth, screenIndex)
		love.graphics.pop()
	end
	love.graphics.pop()
end

return Menu
