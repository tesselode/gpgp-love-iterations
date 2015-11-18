local lg = love.graphics
local lm = love.mouse

local Grid = require 'ui.grid'

local Editor = {}

function Editor:enter()
  self.grid           = Grid()
  self.selectedGroup  = Project.level.groups[1]
  self.selectedLayer  = self.selectedGroup.layers[1]
  self.selectedEntity = Project.entities[1]
end

function Editor:place()
  self:remove()
  table.insert(self.selectedLayer.entities, {
    x    = self.grid.cursor.x,
    y    = self.grid.cursor.y,
    name = self.selectedEntity.name,
  })
end

function Editor:remove()
  for n, entity in pairs(self.selectedLayer.entities) do
    if entity.x == self.grid.cursor.x and entity.y == self.grid.cursor.y then
      table.remove(self.selectedLayer.entities, n)
    end
  end
end

function Editor:update(dt)
  self.grid:update(dt)

  --place objects
  if self.grid:getCursorWithinMap() then
    if love.mouse.isDown('l') then
      self:place()
    end
    if love.mouse.isDown('r') then
      self:remove()
    end
  end
end

function Editor:mousepressed(x, y, button)
  self.grid:mousepressed(x, y, button)
end

function Editor:draw()
  self.grid:drawTransformed(function()
    self.grid:drawBorder()
    self.grid:drawGrid()

    --draw layers
    lg.setColor(255, 255, 255)
    for _, group in pairs(Project.level.groups) do
      for _, layer in pairs(group.layers) do
        for _, entity in pairs(layer.entities) do
          --find the entity to draw
          local e
          for _, entityDef in pairs(Project.entities) do
            if entityDef.name == entity.name then
              e = entityDef
              break
            end
          end
          if e then
            local i  = e.image
            local x  = entity.x
            local y  = entity.y
            local sx = (e.width or 1) / i:getWidth()
            local sy = (e.height or 1) / i:getHeight()
            lg.draw(i, x, y, 0, sx, sy)
          end
        end
      end
    end

    local e = self.selectedEntity
    self.grid:drawCursor(e.image, e.width, e.height)
  end)
end

return Editor
