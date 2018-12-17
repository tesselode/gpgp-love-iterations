local font = require 'font'
local Object = require 'lib.classic'
local util = require 'util'

local style = {
	minMenuWidth = 400,
	maxMenuWidth = 800,
	maxColumns = 3,
	mainPadding = 16,
	itemPadding = 4,
	bgColor = {.1, .1, .1},
	textColor = {.9, .9, .9},
	dividerColor = {.5, .5, .5},
	focusedHighlightColor = {39/255, 175/255, 229/255, 2/3},
	unfocusedHighlightColor = {98/255, 154/255, 175/255, 1/3},
	transitionSpeed = 15,
	scrollAnimationSpeed = 30,
	selectAnimationSpeed = 7.5,
}

local Column = Object:extend()

function Column:new(items)
	self.items = items
	self.selected = 1
	self.highlightY = (self.selected - 1) * self:getItemHeight()
	self.selectAnimationPosition = 1
end

function Column:getItems()
	local items = type(self.items) == 'function' and self.items() or self.items
	self.selected = math.min(#items, self.selected)
	return items
end

function Column:up()
	if self.selected > 1 then
		self.selected = self.selected - 1
	end
end

function Column:down()
	if self.selected < #self:getItems() then
		self.selected = self.selected + 1
	end
end

function Column:left()
	local item = self:getItems()[self.selected]
	if item.onLeft then
		item.onLeft()
		return true
	end
	return false
end

function Column:right()
	local item = self:getItems()[self.selected]
	if item.onRight then
		item.onRight()
		return true
	end
	return false
end

function Column:select(menu)
	local item = self:getItems()[self.selected]
	if item.onSelect then
		item.onSelect(menu)
	end
	self.selectAnimationPosition = 0
end

function Column:update(dt)
	self.highlightY = util.lerp(self.highlightY,
		(self.selected - 1) * self:getItemHeight(),
		style.scrollAnimationSpeed * dt)
	self.selectAnimationPosition = util.lerp(self.selectAnimationPosition,
		1, style.selectAnimationSpeed * dt)
end

function Column:getItemHeight()
	return font.normal:getHeight() + 2 * style.itemPadding
end

function Column:getScrollPosition(height)
	local itemHeight = self:getItemHeight()
	local scrollPosition = self.highlightY - height/2
	scrollPosition = math.min(#self:getItems() * itemHeight - height, scrollPosition)
	scrollPosition = math.max(scrollPosition, 0)
	return scrollPosition
end

function Column:drawItems(width, focused)
	local itemHeight = self:getItemHeight()
	love.graphics.push 'all'
	love.graphics.setColor(focused and style.focusedHighlightColor or style.unfocusedHighlightColor)
	love.graphics.rectangle('fill', style.mainPadding, self.highlightY,
		width - style.mainPadding * 2, itemHeight)
	love.graphics.setColor(1, 1, 1, (1 - self.selectAnimationPosition) / 3)
	love.graphics.rectangle('fill', style.mainPadding, self.highlightY,
		self.selectAnimationPosition * (width - style.mainPadding * 2), itemHeight)
	love.graphics.setColor(style.textColor)
	love.graphics.setFont(font.normal)
	for _, item in ipairs(self:getItems()) do
		love.graphics.print(item.text, style.mainPadding + style.itemPadding, style.itemPadding)
		love.graphics.translate(0, itemHeight)
	end
	love.graphics.pop()
end

function Column:draw(width, height, focused)
	love.graphics.push 'all'
	love.graphics.stencil(function()
		love.graphics.rectangle('fill', 0, 0, width, height)
	end, 'replace', 1)
	love.graphics.setStencilTest('greater', 0)
	love.graphics.translate(0, -self:getScrollPosition(height))
	self:drawItems(width, focused)
	love.graphics.pop()
end

local Screen = Object:extend()

function Screen:new(title, columns)
	self.title = title
	self.columns = {}
	for _, column in ipairs(columns) do
		table.insert(self.columns, Column(column))
	end
	self.selected = 1
end

function Screen:up()
	self.columns[self.selected]:up()
end

function Screen:down()
	self.columns[self.selected]:down()
end

function Screen:left()
	if (not self.columns[self.selected]:left()) and self.selected > 1 then
		self.selected = self.selected - 1
	end
end

function Screen:right()
	if (not self.columns[self.selected]:right()) and self.selected < #self.columns then
		self.selected = self.selected + 1
	end
end

function Screen:select(menu)
	self.columns[self.selected]:select(menu)
end

function Screen:update(dt)
	for _, column in ipairs(self.columns) do
		column:update(dt)
	end
end

function Screen:draw(width, height)
	local titleHeight = font.big:getHeight() + style.mainPadding * 3
	local columnWidth = width / #self.columns
	love.graphics.push 'all'
	love.graphics.setColor(style.textColor)
	love.graphics.setFont(font.big)
	love.graphics.print(self.title, style.mainPadding, style.mainPadding)
	love.graphics.translate(0, font.big:getHeight() + style.mainPadding * 2)
	love.graphics.setColor(style.dividerColor)
	love.graphics.line(style.mainPadding, 0, width - style.mainPadding, 0)
	love.graphics.translate(0, style.mainPadding)
	for columnIndex, column in ipairs(self.columns) do
		column:draw(columnWidth, height - titleHeight, columnIndex == self.selected)
		if columnIndex < #self.columns then
			love.graphics.setColor(style.dividerColor)
			love.graphics.line(columnWidth, 0, columnWidth, height - titleHeight)
			love.graphics.translate(columnWidth, 0)
		end
	end
	love.graphics.pop()
end

local Menu = Object:extend()

function Menu:new(title, columns)
	self.screenStack = {Screen(title, columns)}
	self.screenStackPosition = 1
	self.drawXOffset = 0
	self.width = self:getTargetWidth()
end

function Menu:getTargetWidth()
	local numColumns = #self:getCurrentScreen().columns
	return util.lerp(style.minMenuWidth, style.maxMenuWidth,
		math.min(1, (numColumns - 1) / (style.maxColumns - 1)))
end

function Menu:getScreen(screenIndex)
	return self.screenStack[screenIndex]
end

function Menu:getCurrentScreen()
	return self:getScreen(self.screenStackPosition)
end

function Menu:push(title, columns)
	self.screenStackPosition = self.screenStackPosition + 1
	self.screenStack[self.screenStackPosition] = Screen(title, columns)
end

function Menu:pop()
	if self.screenStackPosition == 1 then return false end
	self.screenStackPosition = self.screenStackPosition - 1
	return true
end

function Menu:up()
	self:getCurrentScreen():up()
end

function Menu:down()
	self:getCurrentScreen():down()
end

function Menu:left()
	self:getCurrentScreen():left()
end

function Menu:right()
	self:getCurrentScreen():right()
end

function Menu:select()
	self:getCurrentScreen():select(self)
end

function Menu:update(dt)
	for _, screen in ipairs(self.screenStack) do
		screen:update(dt)
	end
	self.width = util.lerp(self.width, self:getTargetWidth(), style.transitionSpeed * dt)
	self.drawXOffset = util.lerp(self.drawXOffset,
		self.screenStackPosition - 1,
		style.transitionSpeed * dt)
end

function Menu:draw()
	local menuWidth = self.width
	local menuHeight = love.graphics.getHeight() * .9
	local menuX = 50
	local menuY = (love.graphics.getHeight() - menuHeight) / 2
	love.graphics.push 'all'
	love.graphics.setScissor(menuX, menuY, menuWidth, menuHeight)
	love.graphics.translate(menuX, menuY)
	love.graphics.setColor(style.bgColor)
	love.graphics.rectangle('fill', 0, 0, menuWidth, menuHeight)
	love.graphics.translate(-self.drawXOffset * menuWidth, 0)
	for _, screen in ipairs(self.screenStack) do
		screen:draw(menuWidth, menuHeight)
		love.graphics.translate(menuWidth, 0)
	end
	love.graphics.pop()
end

return Menu
