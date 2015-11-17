local bSize  = 100
local bSpace = 1.5



local Button     = require 'ui.button'
local ScrollArea = require 'ui.scroll-area'

local EntityButton = Button:extend()

function EntityButton:new(x, y, w, h, entity)
  EntityButton.super.new(self, x, y, w, h)
  self.entity = entity
end

function EntityButton:draw()
  EntityButton.super.draw(self)

  if self.entity.image then
    local image = self.entity.image

    love.graphics.setColor(255, 255, 255)

    --draw entity image
    local x, y = self:getCenter()
    local ox = image:getWidth() / 2
    local oy = image:getHeight() / 2
    local scale
    if self.w / image:getWidth() < self.h / image:getHeight() then
      scale = self.w / image:getWidth() * .5
    else
      scale = self.h / image:getHeight() * .5
    end
    love.graphics.draw(image, x, y, 0, scale, scale, ox, oy)

    --print entity name
    local x, y = self.x, self.y + self.h - 20
    love.graphics.printf(self.entity.name, x, y, self.w, 'center')
  end
end



local EntityPalette = {}

function EntityPalette:enter()
  self:init()
end

function EntityPalette:init()
  local lg = love.graphics

  self.scrollArea = ScrollArea(0, 0, lg.getWidth() - 10, lg.getHeight())

  local gridWidth          = math.floor(lg.getWidth() / (bSize * bSpace))
  local buttonTotalWidth   = gridWidth * bSize
  local buttonSpacingWidth = (gridWidth - 1) * bSize * (bSpace - 1)
  local totalWidth         = buttonTotalWidth + buttonSpacingWidth
  local offsetX            = (lg.getWidth() - totalWidth) / 2
  local offsetY            = 50

  self.scrollArea:expand(offsetY + bSize * bSpace)

  local gridX, gridY = 0, 0
  for _, entity in pairs(entities) do
    if gridX == gridWidth then
      gridY = gridY + 1
      self.scrollArea:expand(bSize * bSpace)
      gridX = 0
    end
    local x = offsetX + gridX * bSize * bSpace
    local y = offsetY + gridY * bSize * bSpace
    self.scrollArea:add(EntityButton(x, y, bSize, bSize, entity))
    gridX = gridX + 1
  end
end

function EntityPalette:resize()
  self:init()
end

function EntityPalette:update(dt)
  self.scrollArea:update(dt)
end

function EntityPalette:draw()
  self.scrollArea:draw(dt)
end

return EntityPalette
