local lg = love.graphics
local lm = love.mouse

local function lerp(a, b, x)
  return a + (b - a) * x
end

local Editor = {}

function Editor:enter()
  self.mousePos  = Vector()
  self.mousePrev = Vector()

  self.pan            = Vector(lg.getWidth() / 2, lg.getHeight() / 2)
  self.scale          = 25
  self.displayPan     = self.pan
  self.displayScale   = self.scale
  self.cursor         = Vector()

  self.selectedGroup  = Project.level.groups[1]
  self.selectedLayer  = self.selectedGroup.layers[1]
  self.selectedEntity = Project.entities[1]
end

function Editor:getRelativeMousePos()
  local pos   = Vector()
  local level = Project.level
  pos.x = (lm.getX() - self.displayPan.x) / self.scale + level.width / 2
  pos.y = (lm.getY() - self.displayPan.y) / self.scale + level.height / 2
  return pos
end

function Editor:getCursorWithinMap()
  local c = self.cursor
  return c.x >= 0
     and c.x < Project.level.width
     and c.y >= 0
     and c.y < Project.level.height
end

function Editor:place()
  self:remove()
  table.insert(self.selectedLayer.entities, {
    x    = self.cursor.x,
    y    = self.cursor.y,
    name = self.selectedEntity.name,
  })
end

function Editor:remove()
  for n, entity in pairs(self.selectedLayer.entities) do
    if entity.x == self.cursor.x and entity.y == self.cursor.y then
      table.remove(self.selectedLayer.entities, n)
    end
  end
end

function Editor:update(dt)
  --track mouse movement
  self.mousePrev = self.mousePos
  self.mousePos  = Vector(love.mouse.getX(), love.mouse.getY())
  local mouseDelta = self.mousePos - self.mousePrev

  --panning
  if love.mouse.isDown 'm' then
    self.pan        = self.pan + mouseDelta
    self.displayPan = self.pan
  end

  self.displayPan.x = lerp(self.displayPan.x, self.pan.x, 1 - (10^-5) ^ dt)
  self.displayPan.y = lerp(self.displayPan.y, self.pan.y, 1 - (10^-5) ^ dt)
  self.displayScale = lerp(self.displayScale, self.scale, 1 - (10^-5) ^ dt)

  --cursor
  local relativeMousePos = self:getRelativeMousePos()
  self.cursor.x          = math.floor(relativeMousePos.x)
  self.cursor.y          = math.floor(relativeMousePos.y)

  --place objects
  if self:getCursorWithinMap() then
    if love.mouse.isDown('l') then
      self:place()
    end
    if love.mouse.isDown('r') then
      self:remove()
    end
  end
end

function Editor:mousepressed(x, y, button)
  if button == 'wu' then
    self.scale = self.scale * 1.1
  end
  if button == 'wd' then
    self.scale = self.scale / 1.1
  end
end

function Editor:draw()
  lg.push()
  lg.translate(self.displayPan.x, self.displayPan.y)
  lg.scale(self.displayScale)
  lg.translate(-Project.level.width / 2, -Project.level.height / 2)

    love.graphics.setLineWidth(1 / self.displayScale)

    --draw border
    love.graphics.setColor(255, 255, 255)
    lg.line(0, 0, Project.level.width, 0)
    lg.line(0, Project.level.height, Project.level.width, Project.level.height)
    lg.line(0, 0, 0, Project.level.height)
    lg.line(Project.level.width, 0, Project.level.width, Project.level.height)

    --draw gridlines
    lg.setColor(255, 255, 255, 100)
    for i = 1, Project.level.width - 1 do
      lg.line(i, 0, i, Project.level.height)
    end
    for i = 1, Project.level.height - 1 do
      lg.line(0, i, Project.level.width, i)
    end

    --draw layers
    lg.setColor(255, 255, 255)
    for _, group in pairs(Project.level.groups) do
      for _, layer in pairs(group.layers) do
        for _, entity in pairs(layer.entities) do
          --find the entity to draw
          local e
          for _, entityDef in pairs(entities) do
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

    --draw cursor
    if self:getCursorWithinMap() then
      lg.setColor(255, 255, 255, 100)
      lg.rectangle('fill', self.cursor.x, self.cursor.y, 1, 1)

      local i  = self.selectedEntity.image
      local x  = self.cursor.x
      local y  = self.cursor.y
      local sx = (self.selectedEntity.width or 1) / i:getWidth()
      local sy = (self.selectedEntity.height or 1) / i:getHeight()
      lg.draw(i, x, y, 0, sx, sy)
    end

  lg.pop()

  lg.setColor(255, 255, 255)
  lg.print(self.cursor.x..' '..self.cursor.y)
end

return Editor
