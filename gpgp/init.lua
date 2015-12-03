local currentFolder = ...

local gpgp = {}

function gpgp.init()
  --todo: convert dots to slashes
  local env = setmetatable({
    BASEDIR = currentFolder,
    PROJECTDIR = currentFolder..'/project'
  }, {__index = _G})

  local instance = setfenv(function()
    return require(currentFolder..'.gpgp')
  end, env)()
  instance.load()
  return instance
end

return gpgp
