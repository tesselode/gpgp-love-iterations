local Object = require 'lib.classic'

local Grid = Object:extend()

function Grid:initTransform()
	self.transform = love.math.newTransform()
	self.transform:translate(love.graphics.getWidth() / 2,
		love.graphics.getHeight() / 2)
	self.transform:scale(self.zoom)
	self.transform:translate(-self.width / 2, -self.height / 2)
end

function Grid:new(width, height)
	self.width = width
	self.height = height
	self.zoom = 32
	self.previousCursorX = 0
	self.previousCursorY = 0
	self:initTransform()
end

function Grid:getCursorPosition()
	local relativeX, relativeY = self.transform:inverseTransformPoint(love.mouse.getPosition())
	return math.floor(relativeX), math.floor(relativeY)
end

function Grid:mousemoved(x, y, dx, dy, istouch)
	if love.mouse.isDown(3) then
		self.transform:translate(dx / self.zoom, dy / self.zoom)
		return
	end
	local cursorX, cursorY = self:getCursorPosition()
	if cursorX ~= self.previousCursorX or cursorY ~= self.previousCursorY then
		if self.onMoveCursor then self.onMoveCursor(cursorX, cursorY) end
	end
	self.previousCursorX, self.previousCursorY = cursorX, cursorY
end

function Grid:wheelmoved(x, y)
	if not love.keyboard.isDown 'lctrl' then return end
	if y < 0 then
		self.zoom = self.zoom / 1.1
		self.transform:scale(1 / 1.1)
	elseif y > 0 then
		self.zoom = self.zoom * 1.1
		self.transform:scale(1.1)
	end
end

function Grid:drawBorder()
	love.graphics.push 'all'
	love.graphics.setColor(1, 1, 1)
	love.graphics.setLineWidth(2 / self.zoom)
	love.graphics.rectangle('line', 0, 0, self.width, self.height)
	love.graphics.pop()
end

function Grid:drawGridlines()
	love.graphics.push 'all'
	love.graphics.setColor(1, 1, 1, 1/3)
	love.graphics.setLineWidth(2 / self.zoom)
	for x = 1, self.width - 1 do
		love.graphics.line(x, 0, x, self.height)
	end
	for y = 1, self.height - 1 do
		love.graphics.line(0, y, self.width, y)
	end
	love.graphics.pop()
end

function Grid:draw(f)
	love.graphics.push 'all'
	love.graphics.applyTransform(self.transform)
	f()
	self:drawGridlines()
	self:drawBorder()
	love.graphics.pop()
end

return Grid
