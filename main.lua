Gamestate = require 'lib.gamestate'

ObjectPalette = require 'state.object-palette'

function love.load()
  --load project
  entities = {}
  for _, entity in pairs(love.filesystem.load('project/entities.lua')()) do
    table.insert(entities, {
      name = entity.name,
      image = love.graphics.newImage('project/images/'..entity.image)
    })
  end

  Gamestate.switch(ObjectPalette)
  Gamestate.registerEvents()
end

function love.keypressed(key)
  if key == 'escape' then
    love.event.quit()
  end
end
