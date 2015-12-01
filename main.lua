conversation = require('lib.talkback').new()
require 'extra'

local Color   = require 'resources.colors'
local message = require 'managers.messages'
local Mouse   = require 'managers.mouse-manager'

local Gamestate = require 'lib.gamestate'

local gpgp = {}

function gpgp.load()
  love.graphics.setDefaultFilter('nearest', 'nearest')
  love.graphics.setBackgroundColor(Color.AlmostBlack)

  Gamestate.switch(require('state.level-picker'))
end

function gpgp.update(dt)
  Mouse.update(dt)
  message.update(dt)
  if Gamestate.current().update then
    Gamestate.current():update(dt)
  end
end

function gpgp.keypressed(key)
  if Gamestate.current().keypressed then
    Gamestate.current():keypressed(key)
  end
end

function gpgp.keyreleased(key)
  if Gamestate.current().keyreleased then
    Gamestate.current():keyreleased(key)
  end
end

function gpgp.mousepressed(x, y, button)
  if Gamestate.current().mousepressed then
    Gamestate.current():mousepressed(x, y, button)
  end
end

function gpgp.mousereleased(x, y, button)
  if Gamestate.current().mousereleased then
    Gamestate.current():mousereleased(x, y, button)
  end
end

function gpgp.draw()
  if Gamestate.current().draw then
    Gamestate.current():draw()
  end
  message.draw()
end



function love.load()
  gpgp.load()
end

function love.update(dt)
  gpgp.update(dt)
end

function love.keypressed(key)
  gpgp.keypressed(key)
end

function love.keyreleased(key)
  gpgp.keyreleased(key)
end

function love.mousepressed(x, y, button)
  gpgp.mousepressed(x, y, button)
end

function love.mousereleased(x, y, button)
  gpgp.mousereleased(x, y, button)
end

function love.draw()
  gpgp.draw()
end
