local Color = require 'colors'
local Mouse = require 'mouse-manager'

local Class = require 'lib.classic'

local Button = Class:extend()

function Button:new(x, y, w, h)
  self.x, self.y, self.w, self.h = math.floor(x), math.floor(y), w, h
  self.pressed = false
  self.color = {
    normal  = Color.Dark,
    hover   = Color.Medium,
    pressed = Color.Darkish,
  }
end

function Button:getCenter()
  return self.x + self.w / 2, self.y + self.h / 2
end

function Button:update(dt, ox, oy)
  ox, oy = ox or 0, oy or 0

  --simple button behavior
  self.mouseOver = Mouse:within(self.x + ox, self.y + oy, self.w, self.h)
  if self.mouseOver and Mouse:leftPressed() then
    self.pressed = true
  end
  if self.pressed then
    if Mouse:leftReleased() then
      if self.mouseOver then
        self:onPressed()
      end
      self.pressed = false
    end
  end
end

function Button:onPressed() end

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
