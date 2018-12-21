local font = require 'font'
local Object = require 'lib.classic'
local style = require 'class.menu.style'
local util = require 'util'

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

return Column
