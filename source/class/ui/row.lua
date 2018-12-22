local Object = require 'lib.classic'

local Row = Object:extend()

Row.padding = 8

function Row:new(x, y)
	self.x = x
	self.y = y
	self.items = {}
end

function Row:addItem(itemClass, ...)
	local previous = self.items[#self.items]
	local x = previous and previous:getRight() + self.padding or self.x
	local y = self.y
	table.insert(self.items, itemClass(x, y, ...))
	return self
end

function Row:addItemCompact(itemClass, ...)
	local previous = self.items[#self.items]
	local x = previous and previous:getRight() or self.x
	local y = self.y
	table.insert(self.items, itemClass(x, y, ...))
	return self
end

function Row:mousemoved(x, y, dx, dy, istouch)
	for _, item in ipairs(self.items) do
		if item.mousemoved then
			item:mousemoved(x, y, dx, dy, istouch)
		end
	end
end

function Row:mousepressed(x, y, button, istouch, presses)
	for _, item in ipairs(self.items) do
		if item.mousepressed then
			item:mousepressed(x, y, button, istouch, presses)
		end
	end
end

function Row:mousereleased(x, y, button, istouch, presses)
	for _, item in ipairs(self.items) do
		if item.mousereleased then
			item:mousereleased(x, y, button, istouch, presses)
		end
	end
end

function Row:draw()
	for _, item in ipairs(self.items) do
		item:draw()
	end
end

return Row
