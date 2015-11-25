local Font  = require 'fonts'
local Color = require 'colors'

text  = ''
time  = 0
alpha = 0

local function say(toDisplay)
  text  = toDisplay
  time  = 0
  alpha = 255
end

conversation:listen('selectedEntity', function(name)
  say('Selected entity "'..name..'"')
end)
conversation:listen('selectedLayer', function(layerName, groupName)
  say('Switched to layer "'..layerName..'" in group '..groupName..'"')
end)
conversation:listen('loadedLevel', function(name)
  say('Loaded level "'..name..'"')
end)
conversation:listen('setVisibleMode', function(mode)
  if mode == 1 then
    say('Switched layer visibility: only show current group')
  elseif mode == 2 then
    say('Switched layer visibility: only show current layer')
  else
    say('Switched layer visibility: show all layers')
  end
end)
conversation:listen('toggledGhostLayers', function(ghost)
  if ghost then
    say('Turned on ghost layers')
  else
    say('Turned off ghost layers')
  end
end)
conversation:listen('savedGame', function(name)
  say('Saved level "'..name..'"')
end)

local message = {}

function message.update(dt)
  time = time + dt
  if time > 2 then
    alpha = alpha - 255 * dt
    if alpha < 0 then
      alpha = 0
    end
  end
end

function message.draw()
  local c = Color.AlmostWhite
  love.graphics.setColor(c[1], c[2], c[3], alpha)
  love.graphics.setFont(Font.Medium)
  local y = love.graphics.getHeight() - Font.Medium:getHeight('test')
  love.graphics.print(text, 5, y - 5)
end

return message
