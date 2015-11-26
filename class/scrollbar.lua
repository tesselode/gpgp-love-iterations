local Mouse = require 'mouse-manager'

local Button = require 'class.button'

local Scrollbar = Button:extend()

function Scrollbar:new(x, w, h, top, bottom)
  Scrollbar.super.new(self, x, top, w, h)
  self.top    = top
  self.bottom = bottom
end

function Scrollbar:getValue()
  return (self.y - self.top) / (self.bottom - self.h - self.top)
end

function Scrollbar:update(dt)
  Scrollbar.super.update(self, dt)
  
  local _, deltaY = Mouse:getDelta()

  --dragging
  if self.pressed then
    self.y = self.y + deltaY
  end

  --stay in bounds
  if self.y < self.top then
    self.y = self.top
  end
  if self.y + self.h > self.bottom then
    self.y = self.bottom - self.h
  end
end

return Scrollbar
