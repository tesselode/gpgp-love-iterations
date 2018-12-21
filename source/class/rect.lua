local Object = require 'lib.classic'

local Rect = Object:extend()

function Rect:new(left, top, right, bottom)
	self.left = left
	self.top = top
	self.right = right or left
	self.bottom = bottom or top
end

function Rect:containsPoint(x, y)
	return x >= self.left
	   and x <= self.right
	   and y >= self.top
	   and y <= self.bottom
end

function Rect:normalized()
	local left = math.min(self.left, self.right)
	local top = math.min(self.top, self.bottom)
	local right = math.max(self.left, self.right)
	local bottom = math.max(self.top, self.bottom)
	return Rect(left, top, right, bottom)
end

function Rect:getGraphicsRect()
	return self.left,
		   self.top,
		   self.right - self.left + 1,
		   self.bottom - self.top + 1
end

return Rect
