local lg = love.graphics
local lm = love.mouse

local function lerp(a, b, x)
  return a + (b - a) * x
end

local Grid = Class:extend()

function Grid:new()
  self.mousePos  = Vector()
  self.mousePrev = Vector()

  self.pan            = Vector(lg.getWidth() / 2, lg.getHeight() / 2)
  self.scale          = 25
  self.displayPan     = self.pan
  self.displayScale   = self.scale
  self.cursor         = Vector()
end

function Grid:getRelativeMousePos()
  local pos   = Vector()
  local level = Project.level
  pos.x = (lm.getX() - self.displayPan.x) / self.scale + level.width / 2
  pos.y = (lm.getY() - self.displayPan.y) / self.scale + level.height / 2
  return pos
end

function Grid:getCursorWithinMap()
  local c = self.cursor
  return c.x >= 0
     and c.x < Project.level.width
     and c.y >= 0
     and c.y < Project.level.height
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
  self.cursor.x          = math.floor(relativeMousePos.x)
  self.cursor.y          = math.floor(relativeMousePos.y)
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
  lg.line(0, 0, Project.level.width, 0)
  lg.line(0, Project.level.height, Project.level.width, Project.level.height)
  lg.line(0, 0, 0, Project.level.height)
  lg.line(Project.level.width, 0, Project.level.width, Project.level.height)
end

function Grid:drawGrid()
  lg.setColor(255, 255, 255, 100)
  love.graphics.setLineWidth(1 / self.displayScale)
  for i = 1, Project.level.width - 1 do
    lg.line(i, 0, i, Project.level.height)
  end
  for i = 1, Project.level.height - 1 do
    lg.line(0, i, Project.level.width, i)
  end
end

function Grid:drawCursor()
  if self:getCursorWithinMap() then
    lg.setColor(255, 255, 255, 100)
    lg.rectangle('fill', self.cursor.x, self.cursor.y, 1, 1)
  end
end

function Grid:drawTransformed(f)
  lg.push()
  lg.translate(self.displayPan.x, self.displayPan.y)
  lg.scale(self.displayScale)
  lg.translate(-Project.level.width / 2, -Project.level.height / 2)
  f()
  lg.pop()
end

return Grid
