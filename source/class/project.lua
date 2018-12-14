local Object = require 'lib.classic'

local Project = Object:extend()

function Project:new(data)
	self.data = data or {
		tileSize = 16,
		defaultLevelWidth = 16,
		defaultLevelHeight = 9,
		maxLevelWidth = 1000,
		maxLevelHeight = 1000,
	}
end

return Project
