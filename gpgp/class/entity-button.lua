local currentFolder = (...):match '^(.-)%..*$'

local Font  = require(currentFolder..'.resources.fonts')
local Color = require(currentFolder..'.resources.colors')

local Gamestate = require(currentFolder..'.lib.gamestate')
local vector    = require(currentFolder..'.lib.vector')

local Button = require(currentFolder..'.class.button')

local EntityButton = Button:extend()

function EntityButton:new(x, y, w, h, entity, layer)
  self.entity = entity
  self.layer = layer
  EntityButton.super.new(self, x, y, w, h, self.entity.name, 'center',
    vector(0, h - Font.Small:getHeight('test')))
end

function EntityButton:onPressed()
  self.layer.selected = self.entity
  Gamestate.pop()
  conversation:say('selectedEntity', self.entity.name)
end

function EntityButton:drawImage(pos)
  if self.entity.image then
    --draw entity image
    local image = self.entity.image
    local iw, ih = image:getWidth(), image:getHeight()
    local scale = math.smaller(self.size.x / iw, self.size.y / ih) * .5
    love.graphics.draw(image, pos.x, pos.y, 0, scale, scale, iw / 2, ih * (2/3))
  end
end

function EntityButton:draw()
  EntityButton.super.draw(self)
  love.graphics.setColor(255, 255, 255)
  self:drawImage(self:getCenter())
end

return EntityButton
