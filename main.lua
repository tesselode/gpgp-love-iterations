Class = require 'lib.classic'

local Gamestate = require 'lib.gamestate'
local Serpent   = require 'lib.serpent'

local EntityPalette = require 'state.entity-palette'
local LayerPicker   = require 'state.layer-picker'

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
  level = love.filesystem.load('project/level.lua')()

  Gamestate.switch(LayerPicker)
  Gamestate.registerEvents()

  print(Serpent.block(level, {comment = false}))
end

function love.keypressed(key)
  if key == 'escape' then
    love.event.quit()
  end
end
