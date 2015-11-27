local Font  = require 'resources.fonts'
local Color = require 'resources.colors'

local vector = require 'lib.vector'

local Button = require 'class.button'

local MenuOption = Button:extend()

function MenuOption:new(x, y, w, text, onPressed)
  self.font = Font.Medium
  MenuOption.super.new(self, x, y, w, self.font:getHeight('test'),
    text, 'left', vector(), self.font)
  self.onPressed = onPressed
end

return MenuOption
