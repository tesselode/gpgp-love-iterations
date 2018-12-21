local Object = require 'lib.classic'

local Rect = Object:extend()

function Rect:new(left, top, right, bottom)
	self.left = left
	self.top = top
	self.right = right or left
	self.bottom = bottom or top
end

function Rect:normalized()
	local left = math.min(self.left, self.right)
	local top = math.min(self.top, self.bottom)
	local right = math.max(self.left, self.right)
	local bottom = math.max(self.top, self.bottom)
	return Rect(left, top, right, bottom)
end

return Rect
