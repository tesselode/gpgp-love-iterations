Class = require 'lib.classic'

function love.load()
  require('project-manager'):load()
end

function love.keypressed(key)
  if key == 'escape' then
    love.event.quit()
  end
end

function love.draw()
  Project.groups[1].layers[1]:draw()
end
