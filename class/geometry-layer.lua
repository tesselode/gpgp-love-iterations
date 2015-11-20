local GeometryLayer = Class:extend()

function GeometryLayer:new(data)
  self.blocks = {}
  self:load(data)
end

function GeometryLayer:place(x, y)
  self:remove(x, y)
  table.insert(self.blocks, {x = x, y = y})
end

function GeometryLayer:remove(x, y)
  for n, block in pairs(self.blocks) do
    if block.x == x and block.y == y then
      table.remove(self.blocks, n)
    end
  end
end

function GeometryLayer:load(data)
  self.data = data
  self.name = data.name
end

function GeometryLayer:openPalette() end

function GeometryLayer:drawCursorImage(x, y) end

function GeometryLayer:draw()
  for _, block in pairs(self.blocks) do
    love.graphics.setColor(230, 230, 230)
    love.graphics.rectangle('fill', block.x - 1, block.y - 1, 1, 1)
  end
end

return GeometryLayer
