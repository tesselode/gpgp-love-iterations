local GeometryLayer = Class:extend()

function GeometryLayer:new(data)
  self.blocks = {}
  self:load(data)
end

function GeometryLayer:place(a, b)
  self:remove(a, b)
  for i = a.x, b.x, math.sign(b.x - a.x) do
    for j = a.y, b.y, math.sign(b.y - a.y) do
      table.insert(self.blocks, {x = i, y = j})
    end
  end
end

function GeometryLayer:remove(a, b)
  for i = a.x, b.x, math.sign(b.x - a.x) do
    for j = a.y, b.y, math.sign(b.y - a.y) do
      for n, block in pairs(self.blocks) do
        if block.x == i and block.y == j then
          table.remove(self.blocks, n)
        end
      end
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

function GeometryLayer:drawCursorImage(a, b) end

function GeometryLayer:draw(alpha)
  for _, block in pairs(self.blocks) do
    love.graphics.setColor(129, 187, 209, (alpha or 255) * .5)
    love.graphics.rectangle('fill', block.x - 1, block.y - 1, 1, 1)
  end
end

return GeometryLayer
