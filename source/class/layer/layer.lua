local Object = require 'lib.classic'

local Layer = Object:extend()

function Layer:new(map, name)
	self.map = map
	self.name = name
end

function Layer:draw() end

return Layer
