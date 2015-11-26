local Class     = require 'lib.classic'
local Gamestate = require 'lib.gamestate'
local vector    = require 'lib.vector'

local TileLayer = Class:extend()

function TileLayer:new(data)
  self.tiles = {}
  self.selectedA = vector(1, 1)
  self.selectedB = vector(1, 1)
  self:load(data)
end

function TileLayer:place(x1, y1, x2, y2)
  self:remove(x1, y1, x2, y2)
  self:withPlacementResult(x1, y1, x2, y2, function(posX, posY, tileX, tileY)
    table.insert(self.tiles, {
      posX  = posX,
      posY  = posY,
      tileX = tileX,
      tileY = tileY,
    })
  end)
end

--gets each position and tile coordinate that would result from a selection
function TileLayer:withPlacementResult(x1, y1, x2, y2, f, min)
  if min then
    if x2 < x1 + (self.selectedB.x - self.selectedA.x) then
      x2 = x1 + self.selectedB.x - self.selectedA.x
    end
    if y2 < y1 + (self.selectedB.y - self.selectedA.y) then
      y2 = y1 + self.selectedB.y - self.selectedA.y
    end
  end

  for posX = x1, x2 do
    for posY = y1, y2 do
      local tileX = self.selectedA.x + posX - x1
      local tileY = self.selectedA.y + posY - y1
      --wrap tiles
      while tileX > self.selectedB.x do
        tileX = tileX - (self.selectedB.x - self.selectedA.x) - 1
      end
      while tileY > self.selectedB.y do
        tileY = tileY - (self.selectedB.y - self.selectedA.y) - 1
      end
      f(posX, posY, tileX, tileY)
    end
  end
end

function TileLayer:remove(x1, y1, x2, y2)
  for i = #self.tiles, 1, -1 do
    local tile = self.tiles[i]
    if tile.posX >= x1 and tile.posX < x2 + 1
      and tile.posY >= y1 and tile.posY < y2 + 1 then
      table.remove(self.tiles, i)
    end
  end
end

function TileLayer:load(data)
  self.data = data
  self.name = data.name
  for _, tileset in pairs(Project.tilesets) do
    if tileset.name == data.tileset then
      self.tileset = tileset
      break
    end
  end
  --SEE GEOMETRY-LAYER.LUA FOR A POTENTIAL PROBLEM WITH THIS
  self.tiles = self.data.tiles or {}
end

function TileLayer:save()
  return {
    name    = self.name,
    type    = 'tile',
    tileset = self.tileset.name,
    tiles   = self.tiles,
  }
end

function TileLayer:openPalette()
  Gamestate.push(require('state.tile-palette'), self)
end

function TileLayer:drawCursorImage(a, b)
  local x1, x2 = math.smaller(a.x, b.x)
  local y1, y2 = math.smaller(a.y, b.y)
  self:withPlacementResult(x1, y1, x2, y2, function(posX, posY, tileX, tileY)
    self.tileset:drawTile(posX, posY, tileX, tileY)
  end, true)
end

function TileLayer:draw(alpha)
  love.graphics.setColor(255, 255, 255, alpha)
  for _, tile in pairs(self.tiles) do
    self.tileset:drawTile(tile.posX, tile.posY, tile.tileX, tile.tileY)
  end
end

return TileLayer
