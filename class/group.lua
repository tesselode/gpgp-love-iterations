local Class = require 'lib.classic'

local Group = Class:extend()

function Group:new(data)
  self.data = data
  self.name = self.data.name
  self.layers = {}
  for i = 1, #self.data.layers do
    local layer = self.data.layers[i]
    if layer.type == 'entity' then
      self:addLayer(require('class.layer-types.entity-layer')(layer))
    elseif layer.type == 'tile' then
      self:addLayer(require('class.layer-types.tile-layer')(layer))
    elseif layer.type == 'geometry' then
      self:addLayer(require('class.layer-types.geometry-layer')(layer))
    end
  end
end

function Group:addLayer(layer)
  table.insert(self.layers, layer)
  layer.group = self
end

function Group:save()
  local toSave = {
    name   = self.name,
    layers = {},
  }
  for i = 1, #self.layers do
    local layer = self.layers[i]
    table.insert(toSave.layers, layer:save())
  end
  return toSave
end

return Group
