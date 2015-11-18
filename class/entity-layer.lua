local EntityLayer = require('class.layer'):extend()

function EntityLayer:new(data)
  EntityLayer.super.new(self, data)
  self.entities = {}
  table.insert(self.entities, {
    x      = 50,
    y      = 50,
    entity = Project.entities[1],
  })
end

function EntityLayer:draw()
  for _, entity in pairs(self.entities) do
    local i  = entity.entity.image
    local x  = entity.x
    local y  = entity.y
    local sx = (entity.entity.width or 1) / i:getWidth()
    local sy = (entity.entity.height or 1) / i:getHeight()
    love.graphics.draw(i, x, y, 0, sx, sy)
  end
end

return EntityLayer
