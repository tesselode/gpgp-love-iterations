local Color = require 'colors'
local Mouse = require 'mouse-manager'

local Class  = require 'lib.classic'
local vector = require 'lib.vector'

local Button = Class:extend()

function Button:new(x, y, w, h)
  self.pos = vector(math.floor(x), math.floor(y))
  self.size = vector(w, h)
  self.pressed = false
  self.color = {
    normal  = Color.Dark,
    hover   = Color.Medium,
    pressed = Color.Darkish,
  }
end

function Button:getCenter()
  return self.pos + self.size / 2
end

function Button:update(dt, offset)
  offset = offset or vector()

  --simple button behavior
  self.mouseOver = Mouse:within(self.pos + offset, self.size)
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
  local x, y, w, h = self.pos.x, self.pos.y, self.size.x, self.size.y
  love.graphics.rectangle('fill', x, y, w, h)
end

return Button
