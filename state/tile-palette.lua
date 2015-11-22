local lg = love.graphics
local lm = love.mouse

local Grid = require 'class.grid'

local TilePalette = {}

function TilePalette:enter(previous, layer)
  local tileset      = layer.tileset
  local w            = tileset.image:getWidth() / tileset.tileSize
  local h            = tileset.image:getHeight() / tileset.tileSize
  self.grid          = Grid(w, h)
  self.layer         = layer
  self.layer.tileset = tileset
end

function TilePalette:update(dt)
  self.grid:update(dt)
end

function TilePalette:keypressed(key)
  if key == ' ' then
    require('lib.gamestate').pop()
  end
end

function TilePalette:mousepressed(x, y, button)
  self.grid:mousepressed(x, y, button)
end

function TilePalette:mousereleased(x, y, button)
  if self.grid:getCursorWithinMap() and button == 'l' then
    self.layer.selected = self.grid.cursor
    require('lib.gamestate').pop()
  end
end

function TilePalette:draw()
  self.grid:drawTransformed(function()
    self.grid:drawBorder()
    self.grid:drawGrid()
    love.graphics.setColor(255, 255, 255)
    self.layer.tileset:draw()
    self.grid:drawCursor()
  end)
end

return TilePalette
