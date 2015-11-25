local Font  = require 'fonts'
local Color = require 'colors'

local Gamestate = require 'lib.gamestate'

local Button = require 'class.button'

local EntityButton = Button:extend()

function EntityButton:new(x, y, w, h, entity, layer)
  EntityButton.super.new(self, x, y, w, h)
  self.entity = entity
  self.layer = layer
end

function EntityButton:onPressed()
  self.layer.selected = self.entity
  Gamestate.pop()
  conversation:say('selectedEntity', self.entity.name)
end

function EntityButton:drawImage(x, y)
  cs = cs or 1

  if self.entity.image then
    local image = self.entity.image

    --draw entity image
    local iw, ih = image:getWidth(), image:getHeight()
    local scale = math.smaller(self.w / iw, self.h / ih) * .5
    love.graphics.draw(image, x, y, 0, scale, scale, iw / 2, ih / 2)
  end
end

function EntityButton:draw()
  EntityButton.super.draw(self)
  love.graphics.setColor(255, 255, 255)
  self:drawImage(self:getCenter())

  --print entity name
  local x, y = self.x, self.y + self.h - 20
  love.graphics.setFont(Font.Small)
  love.graphics.setColor(Color.AlmostWhite)
  love.graphics.printf(self.entity.name, x, y, self.w, 'center')
end

return EntityButton
