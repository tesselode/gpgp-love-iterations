local Object = require 'lib.classic'

local Project = Object:extend()

function Project:new(mountPoint)
	self.mountPoint = mountPoint
	self.config = require(mountPoint .. '.config')
end

return Project
