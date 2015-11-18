local Layer = Class:extend()

function Layer:new(data)
  self.data = data
  print('  '..self.data.name)
end

return Layer
