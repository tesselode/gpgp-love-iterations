local currentFolder = (...):match '^(.-)%..*$'

local nf = love.graphics.newFont

local Font = {
  Small  = nf(currentFolder..'/resources/roboto/Roboto-Regular.ttf', 16),
  Medium = nf(currentFolder..'/resources/roboto/Roboto-Regular.ttf', 24),
  Big    = nf(currentFolder..'/resources/roboto/Roboto-Regular.ttf', 48),
}

return Font
