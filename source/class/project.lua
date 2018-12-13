local Object = require 'lib.classic'

local Project = Object:extend()

function Project:new()
	self.tileSize = 16
	self.defaultLevelWidth = 16
	self.defaultLevelHeight = 9
	self.maxLevelWidth = 1000
	self.maxLevelHeight = 1000
end

return Project
