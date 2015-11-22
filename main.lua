Class  = require 'lib.classic'
Vector = require 'lib.vector'

require 'colors'

function love.load()
  love.graphics.setDefaultFilter('nearest', 'nearest')
  love.graphics.setBackgroundColor(Color.AlmostBlack)

  local Gamestate = require 'lib.gamestate'
  Gamestate.switch(require('state.level-picker'))
  Gamestate.registerEvents()
end

function love.keypressed(key)
  if key == 'escape' then
    love.event.quit()
  end
end
