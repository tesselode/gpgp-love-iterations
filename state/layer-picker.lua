local lg = love.graphics

local ScrollArea = require 'ui.scroll-area'
local MenuOption = require 'ui.menu-option'

local LayerPicker = {}

function LayerPicker:enter()
  self.scrollArea = ScrollArea(0, 0, lg.getWidth() / 2 - 10, lg.getHeight())
  for n, layer in pairs(level.groups[1].layers) do
    local y = self.scrollArea.contentHeight
    local menuOption = MenuOption(0, y, self.scrollArea.w, layer.name)
    self.scrollArea:add(menuOption)
    self.scrollArea:expand(menuOption.h)
  end
end

function LayerPicker:update(dt)
  self.scrollArea:update(dt)
end

function LayerPicker:draw()
  self.scrollArea:draw()
end

return LayerPicker
