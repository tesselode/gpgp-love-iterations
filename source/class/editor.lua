local Object = require 'lib.classic'

local Editor = Object:extend()

function Editor:initCamera()
	self.panX = love.graphics.getWidth() / 2
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

function Editor:switchLayer(layer)
	self.selectedLayer = layer
	self.paletteSelection[layer] = self.paletteSelection[layer] or 1
end

function Editor:setSelected(selected)
	self.paletteSelection[self.selectedLayer] = selected
end

function Editor:new(map)
	self.map = map
	self:initCamera()
	self:initMouseTracking()
	self.paletteSelection = {}
	self:switchLayer(self.map.layers[#self.map.layers])
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
			self.selectedLayer:place(x, y, self.paletteSelection[self.selectedLayer])
		elseif love.mouse.isDown(2) then
			local x, y = self:getCursorPosition()
			self.selectedLayer:remove(x, y)
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
	else
		if y < 0 then
			self.paletteSelection[self.selectedLayer] = self.paletteSelection[self.selectedLayer] - 1
			if self.paletteSelection[self.selectedLayer] < 1 then
				self.paletteSelection[self.selectedLayer] = #self.selectedLayer.palette
			end
		elseif y > 0 then
			self.paletteSelection[self.selectedLayer] = self.paletteSelection[self.selectedLayer] + 1
			if self.paletteSelection[self.selectedLayer] > #self.selectedLayer.palette then
				self.paletteSelection[self.selectedLayer] = 1
			end
		end
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
	self.selectedLayer:drawCursor(x, y, self.paletteSelection[self.selectedLayer])
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
