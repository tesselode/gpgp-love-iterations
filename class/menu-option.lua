local Button = require 'class.button'

local MenuOption = Button:extend()

function MenuOption:new(x, y, w, text)
  self.font = love.graphics.newFont(24)
  MenuOption.super.new(self, x, y, w, self.font:getHeight('test'))
  self.text = text
end

function MenuOption:draw()
  MenuOption.super.draw(self)
  love.graphics.setColor(255, 255, 255)
  love.graphics.setFont(self.font)
  love.graphics.print(self.text, self.x, self.y)
end

return MenuOption
