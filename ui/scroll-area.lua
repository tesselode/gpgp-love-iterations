local Scrollbar = require 'ui.scrollbar'

local ScrollArea = Class:extend()

function ScrollArea:new(x, y, w, h)
  self.x, self.y, self.w, self.h = x, y, w, h

  self.items         = {}
  self.contentHeight = 0
  self.scroll        = 0
  self.scrollbar     = Scrollbar(x + w, 10, 100, y, y + h)
end

function ScrollArea:add(item)
  table.insert(self.items, item)
  return item
end

function ScrollArea:expand(amount)
  self.contentHeight = self.contentHeight + amount
end

function ScrollArea:getScrollDistance()
  local distance = self.contentHeight - self.h
  if distance < 0 then
    return 0
  else
    return distance
  end
end

function ScrollArea:update(dt)
  for _, item in pairs(self.items) do
    item:update(dt)
  end
  if self:getScrollDistance() > 0 then
    self.scrollbar.h = self.h * (self.h / self.contentHeight)
    self.scrollbar:update(dt)
  end
end

function ScrollArea:draw()
  local lg = love.graphics

  --draw contents
  lg.push()
  lg.translate(0, -self:getScrollDistance() * self.scrollbar:getValue())
  for _, item in pairs(self.items) do
    item:draw()
  end
  lg.pop()

  if self:getScrollDistance() > 0 then
    self.scrollbar:draw()
  end
end

return ScrollArea
