local currentFolder = (...):gsub('%.[^%.]+$', '')

local Mouse = require(currentFolder..'.managers.mouse-manager')

local Button = require(currentFolder..'.class.button')

local Scrollbar = Button:extend()

function Scrollbar:new(x, w, h, top, bottom)
  Scrollbar.super.new(self, x, top, w, h)
  self.top    = top
  self.bottom = bottom
end

function Scrollbar:getValue()
  return (self.pos.y - self.top) / (self.bottom - self.size.y - self.top)
end

function Scrollbar:setValue(x)
  if x < 0 then x = 0 end
  if x > 1 then x = 1 end
  self.pos.y = self.top + (self.bottom - self.size.y - self.top) * x
end

function Scrollbar:update(dt)
  Scrollbar.super.update(self, dt)

  --dragging
  if self.pressed then
    self.pos.y = self.pos.y + Mouse:getDelta().y
  end

  --stay in bounds
  if self.pos.y < self.top then
    self.pos.y = self.top
  end
  if self.pos.y + self.size.y > self.bottom then
    self.pos.y = self.bottom - self.size.y
  end
end

return Scrollbar
