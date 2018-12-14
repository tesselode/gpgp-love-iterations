local Object = require 'lib.classic'

local Project = Object:extend()

function Project:new(data)
	self.data = data
end

return Project
