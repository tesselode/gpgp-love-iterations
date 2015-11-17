local lg = love.graphics

local ScrollArea = require 'ui.scroll-area'
local MenuOption = require 'ui.menu-option'

local LayerPicker = {}

function LayerPicker:enter()
  self.groupMenu = ScrollArea(10, 10, lg.getWidth() / 2 - 40, lg.getHeight())
  for n, group in pairs(level.groups) do
    local y = self.groupMenu.contentHeight
    local menuOption = MenuOption(0, y, self.groupMenu.w, group.name)
    self.groupMenu:add(menuOption)
    self.groupMenu:expand(menuOption.h)
  end

  self.layerMenu = ScrollArea(lg.getWidth() / 2 + 10, 10, lg.getWidth() / 2 - 40, lg.getHeight())
  for n, layer in pairs(level.groups[1].layers) do
    local y = self.layerMenu.contentHeight
    local menuOption = MenuOption(0, y, self.layerMenu.w, layer.name)
    self.layerMenu:add(menuOption)
    self.layerMenu:expand(menuOption.h)
  end
end

function LayerPicker:update(dt)
  self.groupMenu:update(dt)
  self.layerMenu:update(dt)
end

function LayerPicker:draw()
  self.groupMenu:draw()
  self.layerMenu:draw()
end

return LayerPicker
