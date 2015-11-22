Class        = require 'lib.classic'
Vector       = require 'lib.vector'
conversation = require('lib.talkback').new()
require 'colors'
require 'fonts'

local message = {text = '', time = 0, alpha = 0}

conversation:listen('displayMessage', function(toDisplay)
  message.text = toDisplay
  message.time = 0
  message.alpha = 255
end)

function love.load()
  love.graphics.setDefaultFilter('nearest', 'nearest')
  love.graphics.setBackgroundColor(Color.AlmostBlack)

  local Gamestate = require 'lib.gamestate'
  Gamestate.switch(require('state.level-picker'))
  Gamestate.registerEvents()
end

function love.update(dt)
  message.time = message.time + dt
  if message.time > 2 then
    message.alpha = message.alpha - 255 * dt
    if message.alpha < 0 then
      message.alpha = 0
    end
  end
end

function love.draw()
  local c = Color.AlmostWhite
  love.graphics.setColor(c[1], c[2], c[3], message.alpha)
  love.graphics.setFont(Font.Medium)
  local y = love.graphics.getHeight() - Font.Medium:getHeight('test')
  love.graphics.print(message.text, 5, y - 5)
end
