local Font  = require 'fonts'
local Color = require 'colors'

local Gamestate = require 'lib.gamestate'

local lg = love.graphics

local ScrollArea = require 'class.scroll-area'
local MenuOption = require 'class.menu-option'

local LayerPicker = {}

function LayerPicker:enter(previous)
  self.mainEditor    = previous
  self.selectedGroup = previous.selectedLayer.group
  self:generateMenu()

  --cosmetic
  self.canvasAlpha = 0
  self.canvasY     = 100
  self.tween       = require('lib.flux').group()
  self.tween:to(self, .5, {canvasY = 0, canvasAlpha = 255}):ease('quartout')
end

function LayerPicker:generateMenu()
  local center = lg.getWidth() / 2

  self.groupMenu = ScrollArea(10, 80, center - 40, lg.getHeight() - 80)
  for n, group in pairs(Project.groups) do
    local y = self.groupMenu.contentHeight
    local w = self.groupMenu.w
    local menuOption = MenuOption(0, y, w, group.name, function(menuOption)
      self.selectedGroup = menuOption.group
      self:generateMenu()
    end)
    menuOption.group = group
    if menuOption.group == self.selectedGroup then
      menuOption.textColor = Color.Accent
    end
    self.groupMenu:add(menuOption)
    self.groupMenu:expand(menuOption.h)
  end

  self:generateLayerMenu()

  --cosmetic
  self.canvas     = love.graphics.newCanvas()
  self.background = love.graphics.newCanvas()
  self.background:clear(Color.AlmostBlack)
  self.background:renderTo(function()
    local gaussianblur      = require('lib.shine').gaussianblur()
    gaussianblur.parameters = {sigma = 5}
    gaussianblur:draw(function()
      self.mainEditor:draw()
    end)
  end)
end

function LayerPicker:generateLayerMenu(group)
  local center = lg.getWidth() / 2

  self.layerMenu = ScrollArea(center + 10, 80, center - 40, lg.getHeight() - 80)
  for n, layer in pairs(self.selectedGroup.layers) do
    local y = self.layerMenu.contentHeight
    local w = self.layerMenu.w
    local menuOption = MenuOption(0, y, w, layer.name, function(menuOption)
      self.mainEditor.selectedGroup = self.selectedGroup
      self.mainEditor.selectedLayer = menuOption.layer
      Gamestate.pop()
      local layerName = menuOption.layer.name
      local groupName = self.selectedGroup.name
      conversation:say('selectedLayer', layerName, groupName)
    end)
    menuOption.layer = layer
    if menuOption.layer == self.mainEditor.selectedLayer then
      menuOption.textColor = Color.Accent
    end
    self.layerMenu:add(menuOption)
    self.layerMenu:expand(menuOption.h)
  end
end

function LayerPicker:resize()
  self:generateMenu()
end

function LayerPicker:keypressed(key)
  if key == 'f5' or key == 'escape' then
    Gamestate.pop()
  end
end

function LayerPicker:update(dt)
  self.tween:update(dt)
  self.groupMenu:update(dt)
  self.layerMenu:update(dt)
end

function LayerPicker:draw()
  love.graphics.setColor(150, 150, 150)
  love.graphics.draw(self.background)

  self.canvas:clear(0, 0, 0, 0)
  self.canvas:renderTo(function()
    love.graphics.setColor(Color.AlmostWhite)
    love.graphics.setFont(Font.Big)
    love.graphics.print('Groups', 10, 10)
    love.graphics.print('Layers', love.graphics.getWidth() / 2 + 10, 10)
    self.groupMenu:draw()
    self.layerMenu:draw()
  end)

  love.graphics.setColor(255, 255, 255, self.canvasAlpha)
  love.graphics.draw(self.canvas, 0, self.canvasY)
end

return LayerPicker
