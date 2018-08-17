local Object = require 'lib.classic'

local Project = Object:extend()

function Project:loadEntityImages()
	self.entityImages = {}
	for _, entity in ipairs(self.config.entities) do
		local imagePath = self.mountPoint .. '/' .. entity.image
		self.images[imagePath] = self.images[imagePath] or love.graphics.newImage(imagePath)
		self.entityImages[entity] = self.images[imagePath]
	end
end

function Project:new(mountPoint)
	self.mountPoint = mountPoint
	self.config = require(mountPoint .. '.config')
	self.images = {}
	self:loadEntityImages()
end

return Project
