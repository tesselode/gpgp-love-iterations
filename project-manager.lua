local ProjectManager = {}

function ProjectManager.load()
  local project = {entities = {}, groups = {}}

  --load entities
  for _, entity in pairs(love.filesystem.load('project/entities.lua')()) do
    table.insert(project.entities, {
      name  = entity.name,
      image = love.graphics.newImage('project/images/'..entity.image),
    })
  end

  local levelData = love.filesystem.load('project/level.lua')()

  --load groups and layers
  for _, group in pairs(levelData.groups) do
    table.insert(project.groups, require('class.group')(group))
  end

  --level info
  project.tileSize = levelData.tileSize
  project.width    = levelData.width
  project.height   = levelData.height

  return project
end

return ProjectManager
