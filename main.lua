Class  = require 'lib.classic'
Vector = require 'lib.vector'
require 'colors'
require 'fonts'

local messageText  = ''
local messageAlpha = 0
local timer        = require('lib.timer').new()
local tween        = require('lib.flux').group()

function love.load()
  love.graphics.setDefaultFilter('nearest', 'nearest')
  love.graphics.setBackgroundColor(Color.AlmostBlack)

  local Gamestate = require 'lib.gamestate'
  Gamestate.switch(require('state.level-picker'))
  Gamestate.registerEvents()
end

function love.update(dt)
  timer.update(dt)
  tween:update(dt)
end

function love.draw()
  local c = Color.AlmostWhite
  love.graphics.setColor(c[1], c[2], c[3], messageAlpha)
  love.graphics.print(messageText)
end
