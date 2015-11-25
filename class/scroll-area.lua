local Class = require 'lib.classic'

local Scrollbar = require 'class.scrollbar'

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

function ScrollArea:getAreaOffset()
  local x = self.x
  local y = self.y - self:getScrollDistance() * self.scrollbar:getValue()
  return x, y
end

function ScrollArea:update(dt)
  for _, item in pairs(self.items) do
    local x, y = self:getAreaOffset()
    item:update(dt, -x, -y)
  end
  if self:getScrollDistance() > 0 then
    self.scrollbar.h = self.h * (self.h / self.contentHeight)
    self.scrollbar:update(dt)
  end
end

function ScrollArea:draw()
  local lg = love.graphics

  --draw contents
  lg.setScissor(self.x, self.y, self.w, self.h)
  lg.push()
  lg.translate(self:getAreaOffset())
  for _, item in pairs(self.items) do
    item:draw()
  end
  lg.pop()
  lg.setScissor()

  if self:getScrollDistance() > 0 then
    self.scrollbar:draw()
  end
end

return ScrollArea
