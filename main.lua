Gamestate = require 'lib.gamestate'

ObjectPalette = require 'state.object-palette'

function love.load()
  Gamestate.switch(ObjectPalette)
  Gamestate.registerEvents()
end

function love.keypressed(key)
  if key == 'escape' then
    love.event.quit()
  end
end
