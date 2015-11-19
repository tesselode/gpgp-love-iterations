local lg = love.graphics

local ScrollArea = require 'class.scroll-area'
local MenuOption = require 'class.menu-option'

local LayerPicker = {}

function LayerPicker:enter()
  self:generateMenu()
end

function LayerPicker:generateMenu()
  local center = lg.getWidth() / 2

  self.groupMenu = ScrollArea(10, 10, center - 40, lg.getHeight())
  for n, group in pairs(Project.groups) do
    local y          = self.groupMenu.contentHeight
    local menuOption = MenuOption(0, y, self.groupMenu.w, group.name)
    self.groupMenu:add(menuOption)
    self.groupMenu:expand(menuOption.h)
  end

  self:generateLayerMenu(Project.groups[1])
end

function LayerPicker:generateLayerMenu(group)
  local center = lg.getWidth() / 2

  self.layerMenu = ScrollArea(center + 10, 10, center - 40, lg.getHeight())
  for n, layer in pairs(group.layers) do
    local y          = self.layerMenu.contentHeight
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
