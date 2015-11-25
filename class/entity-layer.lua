local Class     = require 'lib.classic'
local Gamestate = require 'lib.gamestate'

local EntityLayer = Class:extend()

function EntityLayer:new(data)
  self.entities = {}
  self.selected = Project.entities[1]
  self:load(data)
end

function EntityLayer:getAt(x, y)
  for _, entity in pairs(self.entities) do
    if entity.x == x and entity.y == y then
      return entity
    end
  end
end

function EntityLayer:place(a, b)
  self:remove(a, b)
  for i = a.x, b.x do
    for j = a.y, b.y do
      table.insert(self.entities, {x = i, y = j, entity = self.selected})
    end
  end
end

function EntityLayer:remove(a, b)
  for i = #self.entities, 1, -1 do
    local entity = self.entities[i]
    if entity.x >= a.x and entity.x < b.x + 1
      and entity.y >= a.y and entity.y < b.y + 1 then
      table.remove(self.entities, i)
    end
  end
end

function EntityLayer:load(data)
  self.data = data
  self.name = self.data.name
  if self.data.entities then
    for _, entity in pairs(self.data.entities) do
      for _, e in pairs(Project.entities) do
        if e.name == entity.entity then
          table.insert(self.entities, {x = entity.x, y = entity.y, entity = e})
          break
        end
      end
    end
  end
end

function EntityLayer:save()
  local toSave = {
    name     = self.name,
    type     = 'entity',
    entities = {},
  }
  for i = 1, #self.entities do
    local e = self.entities[i]
    table.insert(toSave.entities, {x = e.x, y = e.y, entity = e.entity.name})
  end
  return toSave
end

function EntityLayer:openPalette()
  Gamestate.push(require('state.entity-palette'), self)
end

function EntityLayer:drawCursorImage(a, b)
  if self.selected.image then
    for i = a.x, b.x do
      for j = a.y, b.y do
        local img  = self.selected.image
        local sx = (self.selected.width or 1) / img:getWidth()
        local sy = (self.selected.height or 1) / img:getHeight()
        love.graphics.draw(img, i - 1, j - 1, 0, sx, sy)
      end
    end
  end
end

function EntityLayer:draw(alpha)
  love.graphics.setColor(255, 255, 255, alpha)
  for _, entity in pairs(self.entities) do
    local i  = entity.entity.image
    local x  = entity.x
    local y  = entity.y
    local sx = (entity.entity.width or 1) / i:getWidth()
    local sy = (entity.entity.height or 1) / i:getHeight()
    love.graphics.draw(i, x - 1, y - 1, 0, sx, sy)
  end
end

return EntityLayer
