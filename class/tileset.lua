local Tileset = Class:extend()

function Tileset:new(data)
  self.data     = data
  self.name     = data.name
  self.image    = love.graphics.newImage('project/images/'..data.image)
  self.tileSize = data.tileSize
end

function Tileset:draw()
  local scale = 1 / self.tileSize
  love.graphics.draw(self.image, 0, 0, 0, 1 / self.tileSize)
end

return Tileset
