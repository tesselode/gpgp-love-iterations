local Font  = require 'fonts'
local Color = require 'colors'

local Gamestate = require 'lib.gamestate'

local lg = love.graphics

local ScrollArea = require 'class.scroll-area'
local MenuOption = require 'class.menu-option'

local LevelPicker = {}

function LevelPicker:enter(previous)
  self.previous = previous
  self:generateMenu()

  --cosmetic
  self.canvasAlpha = 0
  self.canvasY     = 100
  self.tween       = require('lib.flux').group()
  self.tween:to(self, .5, {canvasY = 0, canvasAlpha = 255}):ease('quartout')
end

function LevelPicker:generateMenu()
  local center = lg.getWidth() / 2

  self.menu = ScrollArea(10, 80, center - 40, lg.getHeight() - 80)
  for _, file in pairs(love.filesystem.getDirectoryItems('project/levels')) do
    if file:find '.lua' then
      local y = self.menu.contentHeight
      local w = self.menu.w
      local name = file:match '(.*)%.lua'
      local menuOption = MenuOption(0, y, w, name, function(menuOption)
        require('project-manager').load(name)
        Gamestate.switch(require('state.main-editor'))
        conversation:say('loadedLevel', name)
      end)
      menuOption.group = group
      self.menu:add(menuOption)
      self.menu:expand(menuOption.h)
    end
  end

  --cosmetic
  self.canvas = love.graphics.newCanvas()
  if self.previous == require('state.main-editor') then
    self.background = love.graphics.newCanvas()
    self.background:clear(Color.AlmostBlack)
    self.background:renderTo(function()
      local gaussianblur      = require('lib.shine').gaussianblur()
      gaussianblur.parameters = {sigma = 5}
      gaussianblur:draw(function()
        self.previous:draw()
      end)
    end)
  end
end

function LevelPicker:resize()
  self:generateMenu()
end

function LevelPicker:update(dt)
  self.tween:update(dt)
  self.menu:update(dt)
end

function LevelPicker:keypressed(key)
  if key == 'escape' and Project and self.previous then
    Gamestate.pop()
  end
end

function LevelPicker:mousepressed(x, y, button)
  self.menu:mousepressed(x, y, button)
end

function LevelPicker:draw()
  if self.background then
    love.graphics.setColor(150, 150, 150)
    love.graphics.draw(self.background)
  end

  self.canvas:clear(0, 0, 0, 0)
  self.canvas:renderTo(function()
    love.graphics.setColor(Color.AlmostWhite)
    love.graphics.setFont(Font.Big)
    love.graphics.print('Open file...', 10, 10)
    self.menu:draw()
  end)

  love.graphics.setColor(255, 255, 255, self.canvasAlpha)
  love.graphics.draw(self.canvas, 0, self.canvasY)
end

return LevelPicker
