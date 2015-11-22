local lg = love.graphics

local ScrollArea = require 'class.scroll-area'
local MenuOption = require 'class.menu-option'

local LevelPicker = {}

function LevelPicker:enter(previous)
  self:generateMenu()

  --cosmetic
  self.canvasAlpha = 0
  self.canvasY     = 100
  self.tween       = require('lib.flux').group()
  self.tween:to(self, .5, {canvasY = 0, canvasAlpha = 255}):ease('quartout')
end

function LevelPicker:generateMenu()
  local center = lg.getWidth() / 2

  self.menu = ScrollArea(10, 10, center - 40, lg.getHeight())
  for _, file in pairs(love.filesystem.getDirectoryItems('project/levels')) do
    if file:find '.lua' then
      local y = self.menu.contentHeight
      local w = self.menu.w
      local name = file:match '(.*)%.lua'
      local menuOption = MenuOption(0, y, w, name, function(menuOption)
        require('project-manager').load(name)
        require('lib.gamestate').switch(require('state.main-editor'))
      end)
      menuOption.group = group
      self.menu:add(menuOption)
      self.menu:expand(menuOption.h)
    end
  end

  --cosmetic
  self.canvas = love.graphics.newCanvas()
end

function LevelPicker:resize()
  self:generateMenu()
end

function LevelPicker:update(dt)
  self.tween:update(dt)
  self.menu:update(dt)
end

function LevelPicker:draw()
  self.canvas:clear(0, 0, 0, 0)
  self.canvas:renderTo(function()
    self.menu:draw()
  end)

  love.graphics.setColor(255, 255, 255, self.canvasAlpha)
  love.graphics.draw(self.canvas, 0, self.canvasY)
end

return LevelPicker
