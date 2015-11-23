local lg = love.graphics
local lm = love.mouse

local function lerp(a, b, x)
  return a + (b - a) * x
end

local function clamp(x, a, b)
  if x < a then
    return a
  elseif x > b then
    return b
  else
    return x
  end
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
  self.selectionA   = false
  self.selectionB   = false
  self.selectMode   = false
end

function Grid:getRelativeMousePos()
  local pos   = Vector()
  pos.x = (lm.getX() - self.displayPan.x) / self.scale + self.width / 2
  pos.y = (lm.getY() - self.displayPan.y) / self.scale + self.height / 2
  return pos
end

function Grid:getCursorWithinMap()
  local c = self.cursor
  return c.x > 0
     and c.x <= self.width
     and c.y > 0
     and c.y <= self.height
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
  if not love.keyboard.isDown('lctrl') then
    if love.keyboard.isDown('a') or love.keyboard.isDown('left') then
      self.pan.x = self.pan.x + 800 * dt
    end
    if love.keyboard.isDown('d') or love.keyboard.isDown('right') then
      self.pan.x = self.pan.x - 800 * dt
    end
    if love.keyboard.isDown('w') or love.keyboard.isDown('up') then
      self.pan.y = self.pan.y + 800 * dt
    end
    if love.keyboard.isDown('s') or love.keyboard.isDown('down') then
      self.pan.y = self.pan.y - 800 * dt
    end
    if love.keyboard.isDown('e') then
      self.scale = lerp(self.scale, self.scale * 1.1, 1 - (10^-5) ^ dt)
    end
    if love.keyboard.isDown('q') then
      self.scale = lerp(self.scale, self.scale / 1.1, 1 - (10^-5) ^ dt)
    end
  end

  self.displayPan.x = lerp(self.displayPan.x, self.pan.x, 1 - (10^-5) ^ dt)
  self.displayPan.y = lerp(self.displayPan.y, self.pan.y, 1 - (10^-5) ^ dt)
  self.displayScale = lerp(self.displayScale, self.scale, 1 - (10^-5) ^ dt)

  --cursor
  local relativeMousePos = self:getRelativeMousePos()
  self.cursor.x          = math.floor(relativeMousePos.x) + 1
  self.cursor.y          = math.floor(relativeMousePos.y) + 1
  local c1 = love.mouse.isDown('l') and self.selectMode == 1
  local c2 = love.mouse.isDown('r') and self.selectMode == 2
  if self.selectionA and (c1 or c2) then
    self.selectionB = Vector(self.cursor.x, self.cursor.y)
    self.selectionB.x = clamp(self.selectionB.x, self.selectionA.x, self.width)
    self.selectionB.y = clamp(self.selectionB.y, self.selectionA.y, self.height)
  end
end

function Grid:mousepressed(x, y, button)
  if (button == 'l' or button == 'r') and self:getCursorWithinMap() then
    if button == 'l' then
      self.selectMode = 1
    end
    if button == 'r' then
      self.selectMode = 2
    end
    self.selectionA = Vector(self.cursor.x, self.cursor.y)
  end

  if button == 'wu' then
    self.scale = self.scale * 1.1
  end
  if button == 'wd' then
    self.scale = self.scale / 1.1
  end
end

function Grid:mousereleased(x, y, button)
  local c1 = button == 'l' and self.selectMode == 1
  local c2 = button == 'r' and self.selectMode == 2
  if (c1 or c2) then
    if self.selectionA and self.selectionB then
      if c1 then
        self:place(self.selectionA, self.selectionB)
      end
      if c2 then
        self:remove(self.selectionA, self.selectionB)
      end
    end
    self.selectionA = false
    self.selectionB = false
    self.selectMode = false
  end
end

function Grid:place(a, b) end

function Grid:remove(a, b) end

function Grid:drawBorder()
  love.graphics.setColor(Color.AlmostWhite)
  love.graphics.setLineWidth(1 / self.displayScale)
  lg.line(0, 0, self.width, 0)
  lg.line(0, self.height, self.width, self.height)
  lg.line(0, 0, 0, self.height)
  lg.line(self.width, 0, self.width, self.height)
end

function Grid:drawGrid()
  lg.setColor(Color.AlmostWhiteTransparent)
  love.graphics.setLineWidth(1 / self.displayScale)
  for i = 1, self.width - 1 do
    lg.line(i, 0, i, self.height)
  end
  for i = 1, self.height - 1 do
    lg.line(0, i, self.width, i)
  end
end

function Grid:drawCursor(i, w, h)
  if self.selectionA and self.selectionB then
    if self.selectMode == 2 then
      lg.setColor(255, 0, 0, 100)
    else
      lg.setColor(255, 255, 255, 100)
    end
    local pos  = self.selectionA - Vector(1, 1)
    local size = self.selectionB - self.selectionA + Vector(1, 1)
    lg.rectangle('fill', pos.x, pos.y, size.x, size.y)
  elseif self:getCursorWithinMap() then
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
