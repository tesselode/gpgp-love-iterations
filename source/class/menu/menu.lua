local Button = require 'class.ui.button'
local Object = require 'lib.classic'
local Screen = require 'class.menu.screen'
local style = require 'class.menu.style'
local Toolbar = require 'class.ui.toolbar'
local util = require 'util'

local Menu = Object:extend()

function Menu:new(title, columns)
	assert(type(title) == 'string', 'Must provide a title')
	assert(type(columns) == 'table', 'Must provide menu content')
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
	local menuX = 0
	local menuY = Button.padding * 2 + Button.imageSize + Toolbar.padding * 2
	local menuWidth = self.width
	local menuHeight = love.graphics.getHeight() - menuY
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
