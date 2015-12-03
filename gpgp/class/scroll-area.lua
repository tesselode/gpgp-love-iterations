local currentFolder = (...):match '^(.-)%..*$'

local Mouse = require(currentFolder..'.managers.mouse-manager')

local Class = require(currentFolder..'.lib.classic')
local vector = require(currentFolder..'.lib.vector')

local Scrollbar = require(currentFolder..'.class.scrollbar')

local ScrollArea = Class:extend()

function ScrollArea:new(x, y, w, h)
  self.pos, self.size = vector(x, y), vector(w, h)
  self.items          = {}
  self.contentHeight  = 0
  self.scroll         = 0
  self.scrollbar      = Scrollbar(x + w, 10, 100, y, y + h)
end

function ScrollArea:add(item)
  table.insert(self.items, item)
  return item
end

function ScrollArea:expand(amount)
  self.contentHeight = self.contentHeight + amount
end

function ScrollArea:getScrollDistance()
  local distance = self.contentHeight - self.size.y
  if distance < 0 then
    return 0
  else
    return distance
  end
end

function ScrollArea:getAreaOffset()
  local offset = self.pos:clone()
  offset.y = offset.y - self:getScrollDistance() * self.scrollbar:getValue()
  offset.y = math.floor(offset.y)
  return offset
end

function ScrollArea:update(dt)
  for _, item in pairs(self.items) do
    item:update(dt, self:getAreaOffset())
  end
  if self:getScrollDistance() > 0 then
    self.scrollbar.size.y = self.size.y * (self.size.y / self.contentHeight)
    self.scrollbar:update(dt)
  end
end

function ScrollArea:mousepressed(x, y, button)
  if Mouse:within(self.pos, self.size) then
    if button == 'wd' then
      self.scrollbar:setValue(self.scrollbar:getValue() + .1)
    end
    if button == 'wu' then
      self.scrollbar:setValue(self.scrollbar:getValue() - .1)
    end
  end
end

function ScrollArea:draw()
  local lg = love.graphics

  --draw contents
  lg.setScissor(self.pos.x, self.pos.y, self.size.x, self.size.y)
  lg.push()
  lg.translate(self:getAreaOffset():unpack())
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
