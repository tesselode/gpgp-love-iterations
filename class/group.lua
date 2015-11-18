local Group = Class:extend()

function Group:new(data)
  self.data = data
  print(self.data.name)
end

return Group
