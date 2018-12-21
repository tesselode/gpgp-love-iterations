local Column = require 'class.menu.column'
local font = require 'font'
local Object = require 'lib.classic'
local style = require 'class.menu.style'

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

return Screen
