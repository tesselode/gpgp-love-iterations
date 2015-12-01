local currentFolder = (...):gsub('%.[^%.]+$', '')

local Mouse = require currentFolder..'.managers.mouse-manager'
local Color = require currentFolder..'.resources.colors'

local Class  = require currentFolder..'.lib.classic'
local vector = require currentFolder..'.lib.vector'

local lg = love.graphics

local Grid = Class:extend()

function Grid:new(width, height, sx, sy, sw, sh)
  self.size         = vector(width, height)
  self.pan          = vector()
  self.scale        = 25
  self.snap         = 1
  self.displayScale = self.scale
  self.cursor       = vector()
  self.selectionA   = false
  self.selectionB   = false
  self.selectMode   = false
  self:setScissor(sx, sy, sw, sh)
end

function Grid:setScissor(x, y, w, h)
  x, y = x or 0, y or 0
  w = w or (lg.getWidth() - x)
  h = h or (lg.getHeight() - y)
  self.scissor = {pos = vector(x, y), size = vector(w, h)}
end

function Grid:getRelativeMousePos()
  local pos = Mouse:getPosition()
  pos = pos - vector(lg.getWidth() / 2, lg.getHeight() / 2)
  pos = pos / self.scale
  pos = pos + self.size / 2
  pos = pos + self.pan
  return pos
end

function Grid:getCursorWithinMap()
  local c = self.cursor
  return c.x > 0
     and c.x <= self.size.x
     and c.y > 0
     and c.y <= self.size.y
end

function Grid:update(dt)
  local hasMouseFocus = Mouse:within(self.scissor.pos, self.scissor.size)

  --panning with mouse
  if hasMouseFocus and love.mouse.isDown 'm' then
    self.pan = self.pan - Mouse:getDelta() / self.displayScale
  end

  --keyboard controls
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

  self.displayScale = math.lerp(self.displayScale, self.scale, 1 - (10^-5) ^ dt)

  --cursor
  if hasMouseFocus then
    local relativeMousePos = self:getRelativeMousePos()
    self.cursor.x          = math.floor(relativeMousePos.x, self.snap) + 1
    self.cursor.y          = math.floor(relativeMousePos.y, self.snap) + 1
    local c1 = love.mouse.isDown('l') and self.selectMode == 1
    local c2 = love.mouse.isDown('r') and self.selectMode == 2
    if self.selectionA and (c1 or c2) then
      self.selectionB   = self.cursor:clone()
      self.selectionB.x = math.clamp(self.selectionB.x, 1, self.size.x)
      self.selectionB.y = math.clamp(self.selectionB.y, 1, self.size.y)
    end
  end
end

function Grid:mousepressed(x, y, button)
  if Mouse:within(self.scissor.pos, self.scissor.size) then
    if (button == 'l' or button == 'r') and self:getCursorWithinMap() then
      if button == 'l' then
        self.selectMode = 1
      end
      if button == 'r' then
        self.selectMode = 2
      end
      self.selectionA = self.cursor:clone()
    end

    if button == 'wu' then
      self.scale = self.scale * 1.1
    end
    if button == 'wd' then
      self.scale = self.scale / 1.1
    end
  end
end

function Grid:mousereleased(x, y, button)
  local c1 = button == 'l' and self.selectMode == 1
  local c2 = button == 'r' and self.selectMode == 2
  if (c1 or c2) then
    if self.selectionA and self.selectionB then
      local x1, x2 = math.smaller(self.selectionA.x, self.selectionB.x)
      local y1, y2 = math.smaller(self.selectionA.y, self.selectionB.y)
      local a, b   = vector(x1, y1), vector(x2, y2)
      if c1 then self:place(a, b) end
      if c2 then self:remove(a, b) end
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
  lg.line(0, 0, self.size.x, 0)
  lg.line(0, self.size.y, self.size.x, self.size.y)
  lg.line(0, 0, 0, self.size.y)
  lg.line(self.size.x, 0, self.size.x, self.size.y)
end

function Grid:drawGrid()
  love.graphics.setLineWidth(1 / self.displayScale)
  for i = 1, self.size.x - 1, self.snap do
    local a
    if math.floor(i) == i then
      a = 100
    else
      a = 50
    end
    local c = Color.AlmostWhite
    lg.setColor(c[1], c[2], c[3], a)
    lg.line(i, 0, i, self.size.y)
  end
  for i = 1, self.size.y - 1, self.snap do
    local a
    if math.floor(i) == i then
      a = 100
    else
      a = 50
    end
    local c = Color.AlmostWhite
    lg.setColor(c[1], c[2], c[3], a)
    lg.line(0, i, self.size.x, i)
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
  local x, y = self.scissor.pos:unpack()
  local w, h = self.scissor.size:unpack()
  lg.setScissor(x, y, w, h)
  lg.push()
  lg.translate(lg.getWidth() / 2, lg.getHeight() / 2)
  lg.scale(self.displayScale)
  lg.translate(-self.size.x / 2, -self.size.y / 2)
  lg.translate(-self.pan.x, -self.pan.y)
  f()
  lg.pop()
  lg.setScissor()
end

return Grid
