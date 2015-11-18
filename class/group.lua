local Group = Class:extend()

function Group:new(data)
  self.data = data
  print(self.data.name)
  self.layers = {}
  for _, layer in pairs(self.data.layers) do
    self:addLayer(require('class.layer')(layer))
  end
end

function Group:addLayer(layer)
  table.insert(self.layers, layer)
end

return Group
