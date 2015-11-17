local lg = love.graphics
local lm = love.mouse

local function lerp(a, b, x)
  return a + (b - a) * x
end

local Editor = {}

function Editor:enter()
  self.mousePos  = Vector()
  self.mousePrev = Vector()

  self.pan          = Vector(lg.getWidth() / 2, lg.getHeight() / 2)
  self.scale        = 25
  self.displayPan   = self.pan
  self.displayScale = self.scale
  self.cursor       = Vector()
end

function Editor:getRelativeMousePos()
  local pos = Vector()
  pos.x = (lm.getX() - self.displayPan.x) / self.scale + level.width / 2
  pos.y = (lm.getY() - self.displayPan.y) / self.scale + level.height / 2
  return pos
end

function Editor:getCursorWithinMap()
  local c = self.cursor
  return c.x >= 0 and c.x < level.width and c.y >= 0 and c.y < level.height
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
  lg.translate(-level.width / 2, -level.height / 2)

    love.graphics.setLineWidth(1 / self.displayScale)

    --draw border
    love.graphics.setColor(255, 255, 255)
    lg.line(0, 0, level.width, 0)
    lg.line(0, level.height, level.width, level.height)
    lg.line(0, 0, 0, level.height)
    lg.line(level.width, 0, level.width, level.height)

    --draw gridlines
    lg.setColor(255, 255, 255, 100)
    for i = 1, level.width - 1 do
      lg.line(i, 0, i, level.height)
    end
    for i = 1, level.height - 1 do
      lg.line(0, i, level.width, i)
    end

    --draw cursor
    if self:getCursorWithinMap() then
      lg.rectangle('fill', self.cursor.x, self.cursor.y, 1, 1)
    end

  lg.pop()

  lg.setColor(255, 255, 255)
  lg.print(self.cursor.x..' '..self.cursor.y)
end

return Editor
