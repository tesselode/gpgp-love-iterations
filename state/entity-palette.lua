local bSize    = 100
local bSpace = 1.5



local Button = require 'ui.button'

local EntityButton = Button:extend()

function EntityButton:new(x, y, w, h, entity)
  EntityButton.super.new(self, x, y, w, h)
  self.entity = entity
end

function EntityButton:draw()
  EntityButton.super.draw(self)
end



local EntityPalette = {}

function EntityPalette:enter()
  self:generateButtons()
end

function EntityPalette:add(x, y, entity)
  table.insert(self.buttons, EntityButton(x, y, bSize, bSize, entity))
end

function EntityPalette:generateButtons()
  local lg = love.graphics

  self.buttons = {}

  local gridWidth          = math.floor(lg.getWidth() / (bSize * bSpace))
  local buttonTotalWidth   = gridWidth * bSize
  local buttonSpacingWidth = (gridWidth - 1) * bSize * (bSpace - 1)
  local totalWidth         = buttonTotalWidth + buttonSpacingWidth
  local offsetX            = (lg.getWidth() - totalWidth) / 2
  local offsetY            = 100

  local gridX, gridY = 0, 0
  for _, entity in pairs(entities) do
    if gridX == gridWidth then
      gridY = gridY + 1
      gridX = 0
    end
    local x = offsetX + gridX * bSize * bSpace
    local y = offsetY + gridY * bSize * bSpace
    self:add(x, y, entity)
    gridX = gridX + 1
  end
end

function EntityPalette:resize()
  self:generateButtons()
end

function EntityPalette:update(dt)
  for _, button in pairs(self.buttons) do
    button:update(dt)
  end
end

function EntityPalette:draw()
  for _, button in pairs(self.buttons) do
    button:draw()
  end
end

return EntityPalette
