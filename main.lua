Class  = require 'lib.classic'
Vector = require 'lib.vector'

local Gamestate = require 'lib.gamestate'

local EntityPalette = require 'state.entity-palette'
local LayerPicker   = require 'state.layer-picker'
local Editor        = require 'state.editor'

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
  --load level
  level = love.filesystem.load('project/level.lua')()
  for _, group in pairs(level.groups) do
    for _, layer in pairs(group.layers) do
      if not layer.entities then
        layer.entities = {}
      end
    end
  end

  Gamestate.switch(Editor)
  Gamestate.registerEvents()
end

function love.keypressed(key)
  if key == 'escape' then
    love.event.quit()
  end
end
