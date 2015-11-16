local Button = require 'ui.button'

local ObjectPalette = {}

function ObjectPalette:enter()
  self.button = Button(10, 10, 300, 100)
end

function ObjectPalette:update(dt)
  self.button:update(dt)
end

function ObjectPalette:draw()
  self.button:draw()
end

return ObjectPalette
