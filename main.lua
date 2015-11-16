Gamestate = require 'lib.gamestate'

EntityPalette = require 'state.entity-palette'

function love.load()
  love.graphics.setDefaultFilter('nearest', 'nearest')

  --load project
  entities = {}
  for _, entity in pairs(love.filesystem.load('project/entities.lua')()) do
    table.insert(entities, {
      name = entity.name,
      image = love.graphics.newImage('project/images/'..entity.image)
    })
  end

  Gamestate.switch(EntityPalette)
  Gamestate.registerEvents()
end

function love.keypressed(key)
  if key == 'escape' then
    love.event.quit()
  end
end
