local TileLayer = Class:extend()

function TileLayer:new(data)
  self.tiles = {}
  self.selected = Vector(1, 1)
  self:load(data)
end

function TileLayer:place(x, y)
  self:remove(x, y)
  table.insert(self.tiles, {
    posX  = x,
    posY  = y,
    tileX = self.selected.x,
    tileY = self.selected.y,
  })
end

function TileLayer:remove(x, y)
  for n, tile in pairs(self.tiles) do
    if tile.posX == x and tile.posY == y then
      table.remove(self.tiles, n)
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
end

function TileLayer:openPalette()
  require('lib.gamestate').push(require('state.tile-palette'), self)
end

function TileLayer:drawCursorImage(x, y)
  love.graphics.setColor(255, 255, 255, 100)
  self.tileset:drawTile(x, y, self.selected.x, self.selected.y)
end

function TileLayer:draw()
  --[[for _, entity in pairs(self.entities) do
    local i  = entity.entity.image
    local x  = entity.x
    local y  = entity.y
    local sx = (entity.entity.width or 1) / i:getWidth()
    local sy = (entity.entity.height or 1) / i:getHeight()
    love.graphics.draw(i, x, y, 0, sx, sy)
  end]]
  print(self.selected.x, self.selected.y)
end

return TileLayer
