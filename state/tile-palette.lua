local lg = love.graphics
local lm = love.mouse

local Grid = require 'class.grid'

local TilePalette = {}

function TilePalette:enter(previous, tileset)
  self.grid    = Grid()
  self.tileset = tileset
end

function TilePalette:update(dt)
  self.grid:update(dt)
end

function TilePalette:mousepressed(x, y, button)
  self.grid:mousepressed(x, y, button)
end

function TilePalette:draw()
  self.grid:drawTransformed(function()
    self.grid:drawBorder()
    self.grid:drawGrid()
    self.tileset:draw()
  end)
end

return TilePalette
