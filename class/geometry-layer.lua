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
  self.data   = data
  self.name   = data.name
  --[[NOTE TO SELF: IS THIS WRONG? SINCE SELF.BLOCKS IS A REFERENCE TO
  SELF.DATA.BLOCKS, CHANGING SELF.BLOCKS MIGHT CHANGE SELF.DATA.BLOCKS,
  WHICH MIGHT BE UNWANTED BEHAVIOR]]
  self.blocks = self.data.blocks or {}
end

function GeometryLayer:save()
  return {
    name   = self.name,
    type   = 'geometry',
    blocks = self.blocks,
  }
end

function GeometryLayer:openPalette() end

function GeometryLayer:drawCursorImage(x, y) end

function GeometryLayer:draw(alpha)
  for _, block in pairs(self.blocks) do
    love.graphics.setColor(230, 230, 230, alpha)
    love.graphics.rectangle('fill', block.x - 1, block.y - 1, 1, 1)
  end
end

return GeometryLayer
