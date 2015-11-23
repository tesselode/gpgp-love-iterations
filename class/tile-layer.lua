local TileLayer = Class:extend()

function TileLayer:new(data)
  self.tiles = {}
  self.selected = Vector(1, 1)
  self:load(data)
end

function TileLayer:place(a, b)
  self:remove(a, b)
  for i = a.x, b.x do
    for j = a.y, b.y do
      table.insert(self.tiles, {
        posX  = i,
        posY  = j,
        tileX = self.selected.x,
        tileY = self.selected.y,
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
  self.tileset:drawTile(x, y, self.selected.x, self.selected.y)
end

function TileLayer:draw(alpha)
  love.graphics.setColor(255, 255, 255, alpha)
  for _, tile in pairs(self.tiles) do
    self.tileset:drawTile(tile.posX, tile.posY, tile.tileX, tile.tileY)
  end
end

return TileLayer
