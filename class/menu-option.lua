local Font  = require 'fonts'
local Color = require 'colors'

local Button = require 'class.button'

local MenuOption = Button:extend()

function MenuOption:new(x, y, w, text, onPressed)
  self.font      = Font.Medium
  MenuOption.super.new(self, x, y, w, self.font:getHeight('test'))
  self.text      = text
  self.textColor = Color.AlmostWhite
  self.onPressed = onPressed or function() end
end

function MenuOption:draw()
  MenuOption.super.draw(self)
  love.graphics.setColor(self.textColor)
  love.graphics.setFont(self.font)
  love.graphics.print(self.text, self.pos.x, self.pos.y)
end

return MenuOption
