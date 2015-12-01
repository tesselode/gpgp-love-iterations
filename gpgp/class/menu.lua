local currentFolder = (...):gsub('%.[^%.]+$', '')

local vector = require currentFolder..'.lib.vector'

local Font = require currentFolder..'.resources.fonts'

local Button     = require currentFolder..'.class.button'
local ScrollArea = require currentFolder..'.class.scroll-area'

local Menu = ScrollArea:extend()

function Menu:add(name, onPressed)
  local menuOption = Button(0, self.contentHeight, self.size.x,
    Font.Medium:getHeight('asdf'), name, 'left', vector(), Font.Medium)
  menuOption.onPressed = onPressed
  Menu.super.add(self, menuOption)
  self:expand(menuOption.size.y)
  return menuOption
end

return Menu
