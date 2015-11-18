Class  = require 'lib.classic'
Vector = require 'lib.vector'

local Gamestate = require 'lib.gamestate'

local EntityPalette = require 'state.entity-palette'
local LayerPicker   = require 'state.layer-picker'
local Editor        = require 'state.editor'

function loadProject()
  Project = {}
  Project.entities = {}
  for _, entity in pairs(love.filesystem.load('project/entities.lua')()) do
    table.insert(Project.entities, {
      name = entity.name,
      image = love.graphics.newImage('project/images/'..entity.image)
    })
  end
  Project.level = love.filesystem.load('project/level.lua')()
  for _, group in pairs(Project.level.groups) do
    for _, layer in pairs(group.layers) do
      if not layer.entities then
        layer.entities = {}
      end
    end
  end
end

function love.load()
  love.graphics.setDefaultFilter('nearest', 'nearest')

  loadProject()

  Gamestate.switch(Editor)
  Gamestate.registerEvents()
end

function love.keypressed(key)
  if key == 'escape' then
    love.event.quit()
  end
end
