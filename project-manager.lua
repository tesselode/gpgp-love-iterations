local ProjectManager = {}

function ProjectManager.load()
  Project = {entities = {}, tilesets = {}, groups = {}}

  --load entities
  for _, entity in pairs(love.filesystem.load('project/entities.lua')()) do
    table.insert(Project.entities, {
      name  = entity.name,
      image = love.graphics.newImage('project/images/'..entity.image),
    })
  end

  --load tilesets
  for _, tileset in pairs(love.filesystem.load('project/tilesets.lua')()) do
    table.insert(Project.tilesets, require('class.tileset')(tileset))
  end

  local levelData = love.filesystem.load('project/level.lua')()

  --load groups and layers
  for _, group in pairs(levelData.groups) do
    table.insert(Project.groups, require('class.group')(group))
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

  local data = require('lib.serpent').block(toSave, {comment = false})
  love.filesystem.write('level.lua', 'return '..data)
end

return ProjectManager
