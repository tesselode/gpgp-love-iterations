local Class = require 'lib.classic'

local GeometryLayer = Class:extend()

function GeometryLayer:new(data)
  self.blocks = {}
  self:load(data)
end

function GeometryLayer:place(x1, y1, x2, y2)
  self:remove(x1, y1, x2, y2)
  for i = x1, x2 do
    for j = y1, y2 do
      table.insert(self.blocks, {x = i, y = j})
    end
  end
end

function GeometryLayer:remove(x1, y1, x2, y2)
  for i = #self.blocks, 1, -1 do
    local block = self.blocks[i]
    if block.x >= x1 and block.x < x2 + 1
      and block.y >= y1 and block.y < y2 + 1 then
      table.remove(self.blocks, i)
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
