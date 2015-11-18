Class = require 'lib.classic'

function love.load()
  Project = require('project-manager'):load()
end

function love.keypressed(key)
  if key == 'escape' then
    love.event.quit()
  end
end
