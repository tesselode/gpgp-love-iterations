local lg = love.graphics
local lm = love.mouse

local Grid = require 'class.grid'

local MainEditor = {}

function MainEditor:enter()
  self.grid           = Grid()
end

function MainEditor:update(dt)
  self.grid:update(dt)

  --place objects
  --[[if self.grid:getCursorWithinMap() then
    if love.mouse.isDown('l') then
      self:place()
    end
    if love.mouse.isDown('r') then
      self:remove()
    end
  end]]
end

function MainEditor:mousepressed(x, y, button)
  self.grid:mousepressed(x, y, button)
end

function MainEditor:draw()
  self.grid:drawTransformed(function()
    self.grid:drawBorder()
    self.grid:drawGrid()

    --draw layers
    lg.setColor(255, 255, 255)
    for _, group in pairs(Project.groups) do
      for _, layer in pairs(group.layers) do
        layer:draw()
      end
    end
  end)
end

return MainEditor
