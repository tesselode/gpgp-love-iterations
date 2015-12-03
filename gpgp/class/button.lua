local currentFolder = (...):match '^(.-)%..*$'

local Color = require(currentFolder..'.resources.colors')
local Mouse = require(currentFolder..'.managers.mouse-manager')
local Font  = require(currentFolder..'.resources.fonts')

local Class  = require(currentFolder..'.lib.classic')
local vector = require(currentFolder..'.lib.vector')

local Button = Class:extend()

function Button:new(x, y, w, h, text, align, offset, font, color)
  self.pos     = vector(math.floor(x), math.floor(y))
  self.size    = vector(w, h)
  self.pressed = false
  self.color   = {
    normal     = Color.Dark,
    hover      = Color.Medium,
    pressed    = Color.Darkish,
  }
  self.text    = {
    text       = text or '',
    align      = align or 'left',
    offset     = offset or vector(),
    font       = font or Font.Small,
    color      = color or Color.AlmostWhite,
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

function Button:drawText()
  local x, y = (self.pos + self.text.offset):unpack()
  local w, h = self.size:unpack()
  love.graphics.setFont(self.text.font)
  love.graphics.setColor(self.text.color)
  love.graphics.printf(self.text.text, x, y, self.size.x, self.text.align)
end

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
  self:drawText()
end

return Button
