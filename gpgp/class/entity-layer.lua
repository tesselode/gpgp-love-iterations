local currentFolder = (...):gsub('%.[^%.]+$', '')

local Class     = require currentFolder..'.lib.classic'
local Gamestate = require currentFolder..'.lib.gamestate'
local vector    = require currentFolder..'.lib.vector'

local EntityPalette = require currentFolder..'.state.entity-palette'

local EntityLayer = Class:extend()

function EntityLayer:new(data)
  self.entities = {}
  self.selected = Project.entities[1]
  self:load(data)
end

function EntityLayer:getAt(pos)
  for _, entity in pairs(self.entities) do
    if entity.pos == pos then
      return entity
    end
  end
end

function EntityLayer:place(a, b)
  self:remove(a, b)
  for i = a.x, b.x do
    for j = a.y, b.y do
      table.insert(self.entities, {pos = vector(i, j), entity = self.selected})
    end
  end
end

function EntityLayer:remove(a, b)
  for i = #self.entities, 1, -1 do
    local entity = self.entities[i]
    --don't use math.between for this.
    if entity.pos.x >= a.x and entity.pos.x < b.x + 1
      and entity.pos.y >= a.y and entity.pos.y < b.y + 1 then
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
          table.insert(self.entities, {
            pos = vector(entity.x, entity.y),
            entity = e
          })
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
    local entity = self.entities[i]
    table.insert(toSave.entities, {
      x = entity.pos.x,
      y = entity.pos.y,
      entity = entity.entity.name
    })
  end
  return toSave
end

function EntityLayer:openPalette()
  Gamestate.push(EntityPalette, self)
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
    local i    = entity.entity.image
    local x, y = entity.pos:unpack()
    local sx   = (entity.entity.width or 1) / i:getWidth()
    local sy   = (entity.entity.height or 1) / i:getHeight()
    love.graphics.draw(i, x - 1, y - 1, 0, sx, sy)
  end
end

return EntityLayer
