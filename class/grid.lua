local lg = love.graphics
local lm = love.mouse

local function lerp(a, b, x)
  return a + (b - a) * x
end

local Grid = Class:extend()

function Grid:new(width, height)
  self.mousePos     = Vector()
  self.mousePrev    = Vector()

  self.width        = width
  self.height       = height

  self.pan          = Vector(lg.getWidth() / 2, lg.getHeight() / 2)
  self.scale        = 25
  self.displayPan   = self.pan
  self.displayScale = self.scale
  self.cursor       = Vector()
end

function Grid:getRelativeMousePos()
  local pos   = Vector()
  pos.x = (lm.getX() - self.displayPan.x) / self.scale + self.width / 2
  pos.y = (lm.getY() - self.displayPan.y) / self.scale + self.height / 2
  return pos
end

function Grid:getCursorWithinMap()
  local c = self.cursor
  return c.x >= 0
     and c.x < self.width
     and c.y >= 0
     and c.y < self.height
end

function Grid:update(dt)
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
  self.cursor.x          = math.floor(relativeMousePos.x) + 1
  self.cursor.y          = math.floor(relativeMousePos.y) + 1
end

function Grid:mousepressed(x, y, button)
  if button == 'wu' then
    self.scale = self.scale * 1.1
  end
  if button == 'wd' then
    self.scale = self.scale / 1.1
  end
end

function Grid:drawBorder()
  love.graphics.setColor(255, 255, 255)
  love.graphics.setLineWidth(1 / self.displayScale)
  lg.line(0, 0, self.width, 0)
  lg.line(0, self.height, self.width, self.height)
  lg.line(0, 0, 0, self.height)
  lg.line(self.width, 0, self.width, self.height)
end

function Grid:drawGrid()
  lg.setColor(255, 255, 255, 100)
  love.graphics.setLineWidth(1 / self.displayScale)
  for i = 1, self.width - 1 do
    lg.line(i, 0, i, self.height)
  end
  for i = 1, self.height - 1 do
    lg.line(0, i, self.width, i)
  end
end

function Grid:drawCursor(i, w, h)
  if self:getCursorWithinMap() then
    lg.setColor(255, 255, 255, 100)
    lg.rectangle('fill', self.cursor.x - 1, self.cursor.y - 1, 1, 1)
  end
end

function Grid:drawTransformed(f)
  lg.push()
  lg.translate(self.displayPan.x, self.displayPan.y)
  lg.scale(self.displayScale)
  lg.translate(-self.width / 2, -self.height / 2)
  f()
  lg.pop()
end

return Grid
