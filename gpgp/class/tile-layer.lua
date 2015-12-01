local currentFolder = (...):gsub('%.[^%.]+$', '')

local Class     = require currentFolder..'.lib.classic'
local Gamestate = require currentFolder..'.lib.gamestate'
local vector    = require currentFolder..'.lib.vector'

local TilePalette = require currentFolder..'.state.tile-palette'

local TileLayer = Class:extend()

function TileLayer:new(data)
  self.tiles = {}
  self.selectedA = vector(1, 1)
  self.selectedB = vector(1, 1)
  self:load(data)
end

function TileLayer:place(a, b)
  self:remove(a, b)
  self:withPlacementResult(a, b, function(pos, tile)
    table.insert(self.tiles, {pos = pos, tile = tile})
  end)
end

--gets each position and tile coordinate that would result from a selection
function TileLayer:withPlacementResult(va, vb, f, min)
  local a = va:clone()
  local b = vb:clone()

  if min then
    if b.x < a.x + (self.selectedB.x - self.selectedA.x) then
      b.x = a.x + self.selectedB.x - self.selectedA.x
    end
    if b.y < a.y + (self.selectedB.y - self.selectedA.y) then
      b.y = a.y + self.selectedB.y - self.selectedA.y
    end
  end

  for posX = a.x, b.x do
    for posY = a.y, b.y do
      local tileX = self.selectedA.x + posX - a.x
      local tileY = self.selectedA.y + posY - a.y
      --wrap tiles
      while tileX > self.selectedB.x do
        tileX = tileX - (self.selectedB.x - self.selectedA.x) - 1
      end
      while tileY > self.selectedB.y do
        tileY = tileY - (self.selectedB.y - self.selectedA.y) - 1
      end
      f(vector(posX, posY), vector(tileX, tileY))
    end
  end
end

function TileLayer:remove(a, b)
  for i = #self.tiles, 1, -1 do
    local tile = self.tiles[i]
    if tile.pos.x >= a.x and tile.pos.x < b.x + 1
      and tile.pos.y >= a.y and tile.pos.y < b.y + 1 then
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

  for _, tile in pairs(self.data.tiles or {}) do
    table.insert(self.tiles, {
      pos  = vector(tile.posX, tile.posY),
      tile = vector(tile.tileX, tile.tileY),
    })
  end
end

function TileLayer:save()
  local tiles = {}
  for _, tile in pairs(self.tiles) do
    table.insert(tiles, {
      posX  = tile.pos.x,
      posY  = tile.pos.y,
      tileX = tile.tile.x,
      tileY = tile.tile.y,
    })
  end

  return {
    name    = self.name,
    type    = 'tile',
    tileset = self.tileset.name,
    tiles   = tiles
  }
end

function TileLayer:openPalette()
  Gamestate.push(TilePalette, self)
end

function TileLayer:drawCursorImage(a, b)
  local x1, x2 = math.smaller(a.x, b.x)
  local y1, y2 = math.smaller(a.y, b.y)
  self:withPlacementResult(a, b, function(pos, tile)
    self.tileset:drawTile(pos, tile)
  end, true)
end

function TileLayer:draw(alpha)
  love.graphics.setColor(255, 255, 255, alpha)
  for _, tile in pairs(self.tiles) do
    self.tileset:drawTile(tile.pos, tile.tile)
  end
end

return TileLayer
