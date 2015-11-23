local TileLayer = Class:extend()

function TileLayer:new(data)
  self.tiles = {}
  self.selectedA = Vector(1, 1)
  self.selectedB = Vector(1, 1)
  self:load(data)
end

function TileLayer:place(a, b)
  self:remove(a, b)
  for i = a.x, b.x do
    for j = a.y, b.y do
      tileX = self.selectedA.x + i - a.x
      tileY = self.selectedA.y + j - a.y
      while tileX > self.selectedB.x do
        tileX = tileX - (self.selectedB.x - self.selectedA.x)
      end
      while tileY > self.selectedB.y do
        tileY = tileY - (self.selectedB.y - self.selectedA.y)
      end
      table.insert(self.tiles, {
        posX  = i,
        posY  = j,
        tileX = tileX,
        tileY = tileY,
      })
    end
  end
end

function TileLayer:remove(a, b)
  for i = a.x, b.x do
    for j = a.y, b.y do
      for n, tile in pairs(self.tiles) do
        if tile.posX == i and tile.posY == j then
          table.remove(self.tiles, n)
        end
      end
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
  require('lib.gamestate').push(require('state.tile-palette'), self)
end

function TileLayer:drawCursorImage(x, y)
  love.graphics.setColor(255, 255, 255, 100)
  for i = self.selectedA.x, self.selectedB.x do
    for j = self.selectedA.y, self.selectedB.y do
      local posX = x + i - self.selectedA.x
      local posY = y + j - self.selectedA.y
      self.tileset:drawTile(posX, posY, i, j)
    end
  end
end

function TileLayer:draw(alpha)
  love.graphics.setColor(255, 255, 255, alpha)
  for _, tile in pairs(self.tiles) do
    self.tileset:drawTile(tile.posX, tile.posY, tile.tileX, tile.tileY)
  end
end

return TileLayer
