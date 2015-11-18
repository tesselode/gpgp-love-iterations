local Button = Class:extend()

function Button:new(x, y, w, h)
  x = math.floor(x)
  y = math.floor(y)
  self.x, self.y, self.w, self.h = x, y, w, h

  self.mouseOver     = false
  self.mouseDown     = false
  self.mouseDownPrev = false
  self.pressed       = false

  self.color = {
    normal  = {90, 120, 135},
    hover   = {139, 164, 179},
    pressed = {55, 93, 111},
  }
end

function Button:getCenter()
  return self.x + self.w / 2, self.y + self.h / 2
end

function Button:update(dt, ox, oy)
  ox, oy           = ox or 0, oy or 0
  local mx, my     = love.mouse.getX() + ox, love.mouse.getY() + oy
  local x, y, w, h = self.x, self.y, self.w, self.h

  --detect mouse presses/releases
  self.mouseDownPrev = self.mouseDown
  self.mouseDown     = love.mouse.isDown('l')

  --simple button behavior
  self.mouseOver = mx > x and mx < x + w and my > y and my < y + h
  if self.mouseOver and self.mouseDown and not self.mouseDownPrev then
    self.pressed = true
  end
  if self.pressed then
    if self.mouseDownPrev and not self.mouseDown then
      if self.mouseOver then
        self:onPress()
      end
      self.pressed = false
    end
  end
end

function Button:onPress() end

function Button:draw()
  if self.pressed then
    love.graphics.setColor(self.color.pressed)
  elseif self.mouseOver then
    love.graphics.setColor(self.color.hover)
  else
    love.graphics.setColor(self.color.normal)
  end
  love.graphics.rectangle('fill', self.x, self.y, self.w, self.h)
end

return Button
