Class  = require 'lib.classic'
Vector = require 'lib.vector'

function love.load()
  love.graphics.setDefaultFilter('nearest', 'nearest')

  require('project-manager'):load()

  local Gamestate = require 'lib.gamestate'
  Gamestate.switch(require('state.main-editor'))
  Gamestate.registerEvents()
end

function love.keypressed(key)
  if key == 'escape' then
    love.event.quit()
  end
end
