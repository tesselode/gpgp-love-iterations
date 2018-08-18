local Object = require 'lib.classic'
local signal = require 'lib.signal'

local Editor = Object:extend()

function Editor:initCamera()
	self.panX = 250 + (love.graphics.getWidth() - 250) / 2
	self.panY = love.graphics.getHeight() / 2
	self.scale = 32
	self.transform = love.math.newTransform(self.panX, self.panY,
		0,
		self.scale, self.scale,
		self.map.width / 2, self.map.height / 2)
end

function Editor:initMouseTracking()
	self.mouseXPrevious, self.mouseYPrevious = love.mouse.getPosition()
	self.mouseX, self.mouseY = love.mouse.getPosition()
end

function Editor:getCurrentLayer()
	return self.map.layers[self.currentLayer]
end

function Editor:setCurrentLayer(layer)
	self.currentItem[layer] = self.currentItem[layer] or 1
	for i = 1, #self.map.layers do
		if self.map.layers[i] == layer then
			self.currentLayer = i
			return
		end
	end
end

function Editor:getCurrentItem()
	if self:getCurrentLayer().palette then
		return self:getCurrentLayer().palette[self.currentItem[self:getCurrentLayer()]]
	end
	return false
end

function Editor:setCurrentItem(item)
	for i = 1, #self:getCurrentLayer().palette do
		if self:getCurrentLayer().palette[i] == item then
			self.currentItem[self:getCurrentLayer()] = i
			return
		end
	end
end

function Editor:new(map)
	self.map = map
	self:initCamera()
	self:initMouseTracking()
	self.currentItem = {}
	self:setCurrentLayer(self.map.layers[#self.map.layers])

	self.listeners = {
		['moved layer up'] = signal.register('moved layer up', function()
			self.currentLayer = self.currentLayer - 1
		end),
		['moved layer down'] = signal.register('moved layer down', function()
			self.currentLayer = self.currentLayer + 1
		end),
		['added layer'] = signal.register('added layer', function(layer)
			self:setCurrentLayer(layer)
		end),
		['removed layer'] = signal.register('removed layer', function(layer)
			self.currentItem[layer] = nil
			if #self.map.layers == 0 then
				self.currentLayer = nil
			elseif self.currentLayer > #self.map.layers then
				self:setCurrentLayer(self.map.layers[#self.map.layers])
			end
		end),
	}
end

function Editor:trackMouse()
	self.mouseXPrevious, self.mouseYPrevious = self.mouseX, self.mouseY
	self.mouseX, self.mouseY = love.mouse.getPosition()
end

function Editor:panCamera()
	if love.mouse.isDown(3) then
		self.panX = self.panX + (self.mouseX - self.mouseXPrevious)
		self.panY = self.panY + (self.mouseY - self.mouseYPrevious)
	end
end

function Editor:updateCamera()
	self.transform:setTransformation(self.panX, self.panY,
		0,
		self.scale, self.scale,
		self.map.width / 2, self.map.height / 2)
end

function Editor:getCursorPosition()
	local x, y = self.transform:inverseTransformPoint(self.mouseX, self.mouseY)
	x, y = math.floor(x), math.floor(y)
	return x, y
end

function Editor:isCursorInBounds()
	local x, y = self:getCursorPosition()
	return x >= 0
	   and x < self.map.width
	   and y >= 0
	   and y < self.map.height
end

function Editor:update(dt)
	self:trackMouse()
	self:panCamera()
	self:updateCamera()

	if self:isCursorInBounds() then
		if love.mouse.isDown(1) then
			local x, y = self:getCursorPosition()
			self:getCurrentLayer():place(x, y, self:getCurrentItem())
		elseif love.mouse.isDown(2) then
			local x, y = self:getCursorPosition()
			self:getCurrentLayer():remove(x, y)
		end
	end
end

function Editor:zoomOut()
	self.scale = self.scale / 1.1
end

function Editor:zoomIn()
	self.scale = self.scale * 1.1
end

function Editor:wheelmoved(x, y)
	if love.keyboard.isDown 'lctrl' then
		if y < 0 then self:zoomOut() end
		if y > 0 then self:zoomIn() end
	end
end

function Editor:leave()
	for s, f in ipairs(self.listeners) do
		signal.remove(s, f)
	end
end

function Editor:drawGrid()
	love.graphics.setLineWidth(1 / self.scale)
	love.graphics.rectangle('line', 0, 0, self.map.width, self.map.height)
	for x = 1, self.map.width - 1 do
		love.graphics.line(x, 0, x, self.map.height)
	end
	for y = 1, self.map.height - 1 do
		love.graphics.line(0, y, self.map.width, y)
	end
end

function Editor:drawCursor()
	local x, y = self:getCursorPosition()
	self:getCurrentLayer():drawCursor(x, y, self:getCurrentItem())
end

function Editor:draw()
	love.graphics.push()
	love.graphics.applyTransform(self.transform)
	self:drawGrid()
	self.map:draw()
	if self:isCursorInBounds() then self:drawCursor() end
	love.graphics.pop()
end

return Editor
