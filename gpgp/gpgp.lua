local currentFolder = (...):gsub('%.[^%.]+$', '')

local talkback = require currentFolder..'.lib.talkback'
conversation = talkback.new()
require currentFolder..'.extra'

local Color       = require currentFolder..'.resources.colors'
local message     = require currentFolder..'.managers.messages'
local Mouse       = require currentFolder..'.managers.mouse-manager'
local LevelPicker = require currentFolder..'.state.level-picker'

local Gamestate = require currentFolder..'.lib.gamestate'

local gpgp = {}

function gpgp.load()
  love.graphics.setDefaultFilter('nearest', 'nearest')
  love.graphics.setBackgroundColor(Color.AlmostBlack)

  Gamestate.switch(LevelPicker)
end

function gpgp.update(dt)
  Mouse.update(dt)
  message.update(dt)
  if Gamestate.current().update then
    Gamestate.current():update(dt)
  end
end

function gpgp.keypressed(key)
  if Gamestate.current().keypressed then
    Gamestate.current():keypressed(key)
  end
end

function gpgp.keyreleased(key)
  if Gamestate.current().keyreleased then
    Gamestate.current():keyreleased(key)
  end
end

function gpgp.mousepressed(x, y, button)
  if Gamestate.current().mousepressed then
    Gamestate.current():mousepressed(x, y, button)
  end
end

function gpgp.mousereleased(x, y, button)
  if Gamestate.current().mousereleased then
    Gamestate.current():mousereleased(x, y, button)
  end
end

function gpgp.draw()
  if Gamestate.current().draw then
    Gamestate.current():draw()
  end
  message.draw()
end

return gpgp
