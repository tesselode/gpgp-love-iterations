local lg = love.graphics

local ScrollArea = require 'class.scroll-area'
local MenuOption = require 'class.menu-option'

local LayerPicker = {}

function LayerPicker:enter(previous)
  self.mainEditor    = previous
  self.selectedGroup = previous.selectedGroup
  self:generateMenu()
end

function LayerPicker:generateMenu()
  local center = lg.getWidth() / 2

  self.groupMenu = ScrollArea(10, 10, center - 40, lg.getHeight())
  for n, group in pairs(Project.groups) do
    local y = self.groupMenu.contentHeight
    local w = self.groupMenu.w
    local menuOption = MenuOption(0, y, w, group.name, function(menuOption)
      self.selectedGroup = menuOption.group
      self:generateLayerMenu()
    end)
    menuOption.group = group
    self.groupMenu:add(menuOption)
    self.groupMenu:expand(menuOption.h)
  end

  self:generateLayerMenu()
end

function LayerPicker:generateLayerMenu(group)
  local center = lg.getWidth() / 2

  self.layerMenu = ScrollArea(center + 10, 10, center - 40, lg.getHeight())
  for n, layer in pairs(self.selectedGroup.layers) do
    local y = self.layerMenu.contentHeight
    local w = self.layerMenu.w
    local menuOption = MenuOption(0, y, w, layer.name, function(menuOption)
      self.mainEditor.selectedGroup = self.selectedGroup
      self.mainEditor.selectedLayer = menuOption.layer
      require('lib.gamestate').pop()
    end)
    menuOption.layer = layer
    self.layerMenu:add(menuOption)
    self.layerMenu:expand(menuOption.h)
  end
end

function LayerPicker:resize()
  self:generateMenu()
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
