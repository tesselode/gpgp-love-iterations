local Object = require 'lib.classic'

local Layer = Object:extend()

function Layer:new(map, name)
	self.map = map
	self.name = name
end

function Layer:place(x, y, item) end
function Layer:remove(x, y) end
function Layer:save() end
function Layer:load(data) end
function Layer:drawCursor(x, y, item) end
function Layer:draw() end

return Layer
