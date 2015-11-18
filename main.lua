Class  = require 'lib.classic'
Vector = require 'lib.vector'

function love.load()
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

function love.draw()
  Project.groups[1].layers[1]:draw()
end
