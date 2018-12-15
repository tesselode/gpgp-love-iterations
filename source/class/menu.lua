local Object = require 'lib.classic'

local Menu = Object:extend()

Menu.margin = 50
Menu.itemMargin = 2
Menu.bgColor = {.1, .1, .1}
Menu.textColor = {.9, .9, .9}
Menu.highlightColor = {39/255, 175/255, 229/255}

love.graphics.setFont(love.graphics.newFont(18))

function Menu:new(screen)
	self.screenStack = {screen}
	self.screenStackPosition = 1
	self.selection = {{row = 1, column = 1}}
end

function Menu:getScreen(screenIndex)
	return self.screenStack[screenIndex]()
end

function Menu:getCurrentScreen()
	return self:getScreen(self.screenStackPosition)
end

function Menu:drawColumn(columnIndex, columnWidth, column)
	local itemHeight = love.graphics.getFont():getHeight() + self.itemMargin * 2
	local selection = self.selection[self.screenStackPosition]
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
		self:drawColumn(columnIndex, columnWidth, column)
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
	self:drawScreen(menuWidth, self.screenStackPosition)
	love.graphics.pop()
end

return Menu
