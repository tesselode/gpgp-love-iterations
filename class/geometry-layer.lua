local Class  = require 'lib.classic'
local vector = require 'lib.vector'

local GeometryLayer = Class:extend()

function GeometryLayer:new(data)
  self.blocks = {}
  self:load(data)
end

function GeometryLayer:place(a, b)
  self:remove(a, b)
  for i = a.x, b.x do
    for j = a.y, b.y do
      table.insert(self.blocks, {pos = vector(i, j)})
    end
  end
end

function GeometryLayer:remove(a, b)
  for i = #self.blocks, 1, -1 do
    local block = self.blocks[i]
    if block.pos.x >= a.x and block.pos.x < b.x + 1
      and block.pos.y >= a.y and block.pos.y < b.y + 1 then
      table.remove(self.blocks, i)
    end
  end
end

function GeometryLayer:load(data)
  self.data = data
  self.name = data.name
  --[[for _, block in pairs(self.data.blocks or {}) do
    table.insert(self.blocks, {
      pos = vector(block.x, block.y)
    })
  end]]
  for _, rect in pairs(self.data.rectangles) do
    for i = rect.x, rect.x + rect.w do
      for j = rect.y, rect.y + rect.h do
        table.insert(self.blocks, {pos = vector(i, j)})
      end
    end
  end
end

function GeometryLayer:save()
  local blocks = {}
  for _, block in pairs(self.blocks) do
    table.insert(blocks, {x = block.pos.x, y = block.pos.y})
  end

  return {
    name       = self.name,
    type       = 'geometry',
    --blocks     = blocks,
    rectangles = self:convertToRectangles()
  }
end

function GeometryLayer:convertToRectangles()
  local blocks     = table.clone(self.blocks)
  local rectangles = {}

  local function getBlocks(a, b)
    local collectedBlocks = {}
    for i = a.x, b.x do
      for j = a.y, b.y do
        local foundBlock = false
        for _, block in pairs(blocks) do
          if block.pos.x == i and block.pos.y == j then
            foundBlock = true
            table.insert(collectedBlocks, block)
            break
          end
        end
        if not foundBlock then
          return false
        end
      end
    end
    return collectedBlocks
  end

  while blocks[1] do
    local a = blocks[1].pos:clone()
    local b = blocks[1].pos:clone()
    while getBlocks(a, b) do
      b.x = b.x + 1
    end
    b.x = b.x - 1
    while getBlocks(a, b) do
      b.y = b.y + 1
    end
    b.y = b.y - 1
    local collectedBlocks = getBlocks(a, b)
    for _, collectedBlock in pairs(collectedBlocks) do
      table.removeValue(blocks, collectedBlock)
    end
    table.insert(rectangles, {
      x = a.x,
      y = a.y,
      w = b.x - a.x,
      h = b.y - a.y,
    })
  end

  return rectangles
end

function GeometryLayer:openPalette() end

function GeometryLayer:drawCursorImage(a, b) end

function GeometryLayer:draw(alpha)
  for _, block in pairs(self.blocks) do
    love.graphics.setColor(129, 187, 209, (alpha or 255) * .5)
    love.graphics.rectangle('fill', block.pos.x - 1, block.pos.y - 1, 1, 1)
  end
end

return GeometryLayer
