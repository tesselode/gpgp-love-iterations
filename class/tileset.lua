local Tileset = Class:extend()

function Tileset:new(data)
  self.data     = data
  self.name     = data.name
  self.image    = love.graphics.newImage('project/images/'..data.image)
  self.tileSize = data.tileSize
end

function Tileset:draw()
  love.graphics.draw(self.image)
end
