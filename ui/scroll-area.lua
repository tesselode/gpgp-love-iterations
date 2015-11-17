local Scrollbar = require 'ui.scrollbar'

local ScrollArea = Class:extend()

function ScrollArea:new(x, y, w, h)
  self.x, self.y, self.w, self.h = x, y, w, h

  self.items     = {}
  self.scroll    = 0
  self.scrollbar = Scrollbar(x + w, 10, 100, y, y + h)
end

function ScrollArea:add(item)
  table.insert(self.items, item)
  return item
end

function ScrollArea:update(dt)
  for _, item in pairs(self.items) do
    item:update(dt)
  end
  self.scrollbar:update(dt)
end

function ScrollArea:draw()
  for _, item in pairs(self.items) do
    item:draw()
  end
  self.scrollbar:draw()
end

return ScrollArea
