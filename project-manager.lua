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

return ProjectManager
