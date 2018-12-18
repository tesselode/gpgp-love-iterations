local Object = require 'lib.classic'

local Tileset = Object:extend()

function Tileset:new(mountPoint, data)
	self.name = data.name
	self.tileSize = data.tileSize
	self.image = love.graphics.newImage(mountPoint .. '/images/' .. data.imagePath)
end

return Tileset
