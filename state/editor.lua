local lg = love.graphics

local function lerp(a, b, x)
  return a + (b - a) * x
end

local Editor = {}

function Editor:enter()
  self.mousePos  = Vector()
  self.mousePrev = Vector()

  self.pan          = Vector()
  self.scale        = 5
  self.displayPan   = self.pan
  self.displayScale = self.scale
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
  lg.translate(lg.getWidth() / 2, lg.getHeight() / 2)
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

  lg.pop()
end

return Editor
