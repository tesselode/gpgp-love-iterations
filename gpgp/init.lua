local currentFolder = ...

local gpgp = {}

function gpgp.init()
  local env = setmetatable({}, {__index = _G})
  local instance = setfenv(function()
    return require(currentFolder..'.gpgp')
  end, env)()
  instance.load()
  return instance
end

return gpgp
