local Object = require 'lib.classic'

local Level = Object:extend()

function Level:new(project)
	self.project = project
	self.width = project.defaultLevelWidth
	self.height = project.defaultLevelHeight
end

return Level
