local Color = require 'colors'
require 'extra'

conversation = require('lib.talkback').new()

function love.load()
  love.graphics.setDefaultFilter('nearest', 'nearest')
  love.graphics.setBackgroundColor(Color.AlmostBlack)

  local Gamestate = require 'lib.gamestate'
  Gamestate.switch(require('state.level-picker'))
  Gamestate.registerEvents()
end

function love.update(dt)
  require('messages').update(dt)
end

function love.draw()
  require('messages').draw()
end
