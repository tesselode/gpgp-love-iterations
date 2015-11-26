local Mouse = require 'mouse-manager'
local Color = require 'colors'

local Class  = require 'lib.classic'
local vector = require 'lib.vector'

local lg = love.graphics

local Grid = Class:extend()

function Grid:new(width, height)
  self.width        = width
  self.height       = height

  self.pan          = vector()
  self.scale        = 25
  self.snap         = 1
  self.displayPan   = self.pan
  self.displayScale = self.scale
  self.cursor       = vector()
  self.selectionA   = false
  self.selectionB   = false
  self.selectMode   = false
end

function Grid:getRelativeMousePos()
  local pos = vector(Mouse:getPosition())
  pos = pos - vector(lg.getWidth() / 2, lg.getHeight() / 2)
  pos = pos / self.scale
  pos = pos + vector(self.width / 2, self.height / 2)
  pos = pos + self.displayPan
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
  --panning
  if love.mouse.isDown 'm' then
    self.pan        = self.pan - vector(Mouse:getDelta()) / self.displayScale
    self.displayPan = self.pan
  end
  if not love.keyboard.isDown('lctrl') then
    if love.keyboard.isDown('a') or love.keyboard.isDown('left') then
      self.pan.x = self.pan.x - 20 * dt
    end
    if love.keyboard.isDown('d') or love.keyboard.isDown('right') then
      self.pan.x = self.pan.x + 20 * dt
    end
    if love.keyboard.isDown('w') or love.keyboard.isDown('up') then
      self.pan.y = self.pan.y - 20 * dt
    end
    if love.keyboard.isDown('s') or love.keyboard.isDown('down') then
      self.pan.y = self.pan.y + 20 * dt
    end
    if love.keyboard.isDown('e') then
      self.scale = math.lerp(self.scale, self.scale * 1.1, 1 - (10^-5) ^ dt)
    end
    if love.keyboard.isDown('q') then
      self.scale = math.lerp(self.scale, self.scale / 1.1, 1 - (10^-5) ^ dt)
    end
  end

  self.displayPan.x = math.lerp(self.displayPan.x, self.pan.x, 1 - (10^-5) ^ dt)
  self.displayPan.y = math.lerp(self.displayPan.y, self.pan.y, 1 - (10^-5) ^ dt)
  self.displayScale = math.lerp(self.displayScale, self.scale, 1 - (10^-5) ^ dt)

  --cursor
  local relativeMousePos = self:getRelativeMousePos()
  self.cursor.x          = math.floor(relativeMousePos.x, self.snap) + 1
  self.cursor.y          = math.floor(relativeMousePos.y, self.snap) + 1
  local c1 = love.mouse.isDown('l') and self.selectMode == 1
  local c2 = love.mouse.isDown('r') and self.selectMode == 2
  if self.selectionA and (c1 or c2) then
    self.selectionB = vector(self.cursor.x, self.cursor.y)
    self.selectionB.x = math.clamp(self.selectionB.x, 1, self.width)
    self.selectionB.y = math.clamp(self.selectionB.y, 1, self.height)
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
    self.selectionA = vector(self.cursor.x, self.cursor.y)
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
      local smaller, bigger = math.smaller(self.selectionA, self.selectionB)
      if c1 then
        self:place(smaller, bigger)
      end
      if c2 then
        self:remove(smaller, bigger)
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
  love.graphics.setLineWidth(1 / self.displayScale)
  for i = 1, self.width - 1, self.snap do
    local a
    if math.floor(i) == i then
      a = 100
    else
      a = 50
    end
    local c = Color.AlmostWhite
    lg.setColor(c[1], c[2], c[3], a)
    lg.line(i, 0, i, self.height)
  end
  for i = 1, self.height - 1, self.snap do
    local a
    if math.floor(i) == i then
      a = 100
    else
      a = 50
    end
    local c = Color.AlmostWhite
    lg.setColor(c[1], c[2], c[3], a)
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
    local smallerX, biggerX = math.smaller(self.selectionA.x, self.selectionB.x)
    local smallerY, biggerY = math.smaller(self.selectionA.y, self.selectionB.y)
    local smaller, bigger = vector(smallerX, smallerY), vector(biggerX, biggerY)
    local pos  = smaller - vector(1, 1)
    local size = bigger - smaller + vector(1, 1)
    lg.rectangle('fill', pos.x, pos.y, size.x, size.y)
  elseif self:getCursorWithinMap() then
    lg.setColor(255, 255, 255, 100)
    lg.rectangle('fill', self.cursor.x - 1, self.cursor.y - 1, 1, 1)
  end
end

function Grid:drawTransformed(f)
  lg.push()
  lg.translate(lg.getWidth() / 2, lg.getHeight() / 2)
  lg.scale(self.displayScale)
  lg.translate(-self.width / 2, -self.height / 2)
  lg.translate(-self.displayPan.x, -self.displayPan.y)
  f()
  lg.pop()
end

return Grid
