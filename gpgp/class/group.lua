local currentFolder = (...):gsub('%.[^%.]+$', '')

local Class = require(currentFolder..'.lib.classic')

local EntityLayer   = require(currentFolder..'.class.entity-layer')
local TileLayer     = require(currentFolder..'.class.tile-layer')
local GeometryLayer = require(currentFolder..'.class.geometry-layer')

local Group = Class:extend()

function Group:new(data)
  self.data = data
  self.name = self.data.name
  self.layers = {}
  for i = 1, #self.data.layers do
    local layer = self.data.layers[i]
    if layer.type == 'entity' then
      self:addLayer(EntityLayer(layer))
    elseif layer.type == 'tile' then
      self:addLayer(TileLayer(layer))
    elseif layer.type == 'geometry' then
      self:addLayer(GeometryLayer(layer))
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
