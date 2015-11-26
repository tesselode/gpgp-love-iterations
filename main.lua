conversation = require('lib.talkback').new()
require 'extra'

local Color   = require 'colors'
local message = require 'messages'
local Mouse   = require 'mouse-manager'

function love.load()
  love.graphics.setDefaultFilter('nearest', 'nearest')
  love.graphics.setBackgroundColor(Color.AlmostBlack)

  local Gamestate = require 'lib.gamestate'
  Gamestate.switch(require('state.level-picker'))
  Gamestate.registerEvents()
end

function love.update(dt)
  Mouse.update(dt)
  message.update(dt)
end

function love.draw()
  message.draw()
end
