local currentFolder = (...):match '^(.-)%..*$'

local serpent = require(currentFolder..'.lib.serpent')

local Tileset = require(currentFolder..'.class.tileset')
local Group = require(currentFolder..'.class.group')

local ProjectManager = {}

function ProjectManager.load(name)
  Project = {levelName = name, entities = {}, tilesets = {}, groups = {}}

  --load entities
  for _, entity in pairs(love.filesystem.load(PROJECTDIR..'/entities.lua')()) do
    table.insert(Project.entities, {
      name  = entity.name,
      image = love.graphics.newImage(PROJECTDIR..'/images/'..entity.image),
    })
  end

  --load tilesets
  for _, tileset in pairs(love.filesystem.load(PROJECTDIR..'/tilesets.lua')()) do
    table.insert(Project.tilesets, Tileset(tileset))
  end

  local levelData = love.filesystem.load(PROJECTDIR..'/levels/'..name..'.lua')()

  --load groups and layers
  for _, group in pairs(levelData.groups) do
    table.insert(Project.groups, Group(group))
  end

  --level info
  Project.tileSize = levelData.tileSize
  Project.width    = levelData.width
  Project.height   = levelData.height
end

function ProjectManager.save()
  local toSave = {
    tileSize = Project.tileSize,
    width    = Project.width,
    height   = Project.height,
    groups   = {},
  }

  for i = 1, #Project.groups do
    local group = Project.groups[i]
    table.insert(toSave.groups, group:save())
  end

  local data = serpent.block(toSave, {comment = false})
  local path = PROJECTDIR..'/levels/'..Project.levelName..'.lua'
  love.filesystem.createDirectory(PROJECTDIR..'/levels')
  love.filesystem.write(path, 'return '..data)
end

return ProjectManager
