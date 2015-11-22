local lg = love.graphics
local lm = love.mouse

local Grid = require 'class.grid'

local MainEditor = {}

function MainEditor:enter()
  self.grid          = Grid(Project.width, Project.height)
  self.selectedGroup = Project.groups[1]
  self.selectedLayer = self.selectedGroup.layers[1]
end

function MainEditor:update(dt)
  self.grid:update(dt)

  --place objects
  if self.grid:getCursorWithinMap() then
    if love.mouse.isDown('l') then
      self.selectedLayer:place(self.grid.cursor.x, self.grid.cursor.y)
    end
    if love.mouse.isDown('r') then
      self.selectedLayer:remove(self.grid.cursor.x, self.grid.cursor.y)
    end
  end
end

function MainEditor:keypressed(key)
  if key == ' ' then
    self.selectedLayer:openPalette()
  end
  if key == 'f5' then
    require('lib.gamestate').push(require('state.layer-picker'))
  end
  if key == 's' then
    if love.keyboard.isDown('lctrl') then
      require('project-manager').save()
    end
  end
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
    for i = 1, #Project.groups do
      for j = 1, #Project.groups[i].layers do
        Project.groups[i].layers[j]:draw()
      end
    end

    if self.grid:getCursorWithinMap() then
      self.grid:drawCursor()
      self.selectedLayer:drawCursorImage(self.grid.cursor.x, self.grid.cursor.y)
    end
  end)

  --draw entity tooltips
  if self.selectedLayer.data.type == 'entity' then
    local x, y = self.grid.cursor.x, self.grid.cursor.y
    local entity = self.selectedLayer:getAt(x, y)
    if entity then
      local mx, my = lm.getX(), lm.getY()
      lg.setColor(Color.Darkish)
      love.graphics.rectangle('fill', mx + 50, my + 50, 100, 50)
      local string = entity.entity.name..'\nx: '..entity.x..'\ny: '..entity.y
      lg.setColor(Color.AlmostWhite)
      love.graphics.printf(string, mx + 55, my + 55, 100)
      print(string)
    end
  end

  love.graphics.setColor(255, 255, 255)
  love.graphics.print(self.selectedGroup.name)
  love.graphics.print(self.selectedLayer.name, 0, 20)
end

return MainEditor
