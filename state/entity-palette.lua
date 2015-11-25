local lg = love.graphics

local bSize  = 100
local bSpace = 1.5



local EntityButton = require('class.button'):extend()

function EntityButton:new(x, y, w, h, entity, layer)
  EntityButton.super.new(self, x, y, w, h)
  self.entity = entity
  self.layer = layer

  --[[self.color = {
    normal  = {0, 0, 0, 0},
    hover   = {0, 0, 0, 0},
    pressed = {0, 0, 0, 0},
  }]]

  --cosmetic
  --self.glow = lg.newCanvas(bSize, bSize)
  --self.glow:renderTo(function()
    --local whiteShader = lg.newShader[[
      --vec4 effect(vec4 color, sampler2D texture, vec2 uv, vec2 sc)
      --{
        --return vec4(1.0, 1.0, 1.0, texture2D(texture, uv).a) * color;
      --}
    --]]

    --local gaussianblur      = require('lib.shine').gaussianblur()
    --gaussianblur.parameters = {sigma = 16}

    --gaussianblur:draw(function()
      --lg.setShader(whiteShader)
      --lg.setColor(255, 255, 255)
      --self:drawImage(bSize / 2, bSize / 2)
      --lg.setShader()
    --end)
  --end)
end

function EntityButton:onPressed()
  self.layer.selected = self.entity
  require('lib.gamestate').pop()
  conversation:say('selectedEntity', self.entity.name)
end

function EntityButton:drawImage(x, y)
  cs = cs or 1

  if self.entity.image then
    local image = self.entity.image

    --draw entity image
    local ox = image:getWidth() / 2
    local oy = image:getHeight() / 2
    local scale
    if self.w / image:getWidth() < self.h / image:getHeight() then
      scale = self.w / image:getWidth() * .5
    else
      scale = self.h / image:getHeight() * .5
    end
    lg.draw(image, x, y, 0, scale, scale, ox, oy)
  end
end

function EntityButton:draw()
  EntityButton.super.draw(self)

  --[[if self.mouseOver then
    lg.setColor(255, 255, 255)
    lg.setBlendMode('additive')
    for i = 1, 3 do
      lg.draw(self.glow, self.x, self.y)
    end
    lg.setBlendMode('alpha')
  end]]

  lg.setColor(255, 255, 255)
  self:drawImage(self:getCenter())

  --print entity name
  local x, y = self.x, self.y + self.h - 20
  lg.setFont(Font.Small)
  lg.setColor(Color.AlmostWhite)
  lg.printf(self.entity.name, x, y, self.w, 'center')
end



local EntityPalette = {}

function EntityPalette:enter(previous, layer)
  self.previous = previous
  self.layer    = layer
  self:generateMenu()

  --cosmetic
  self.canvasAlpha = 0
  self.canvasY     = 100
  self.tween       = require('lib.flux').group()
  self.tween:to(self, .5, {canvasY = 0, canvasAlpha = 255}):ease('quartout')
end

function EntityPalette:generateMenu()
  local ScrollArea = require 'class.scroll-area'
  self.scrollArea = ScrollArea(0, 80, lg.getWidth() - 10, lg.getHeight() - 80)

  local gridWidth          = math.floor(self.scrollArea.w / (bSize * bSpace))
  local buttonTotalWidth   = gridWidth * bSize
  local buttonSpacingWidth = (gridWidth - 1) * bSize * (bSpace - 1)
  local totalWidth         = buttonTotalWidth + buttonSpacingWidth
  local offsetX            = (self.scrollArea.w - totalWidth) / 2
  local offsetY            = 50

  self.scrollArea:expand(offsetY + bSize * bSpace)

  local gridX, gridY = 0, 0
  for _, entity in pairs(Project.entities) do
    if gridX == gridWidth then
      gridY = gridY + 1
      self.scrollArea:expand(bSize * bSpace)
      gridX = 0
    end
    local x = offsetX + gridX * bSize * bSpace
    local y = offsetY + gridY * bSize * bSpace
    self.scrollArea:add(EntityButton(x, y, bSize, bSize, entity, self.layer))
    gridX = gridX + 1
  end

  --cosmetic
  self.canvas     = lg.newCanvas()
  self.background = lg.newCanvas()
  self.background:clear(Color.AlmostBlack)
  self.background:renderTo(function()
    local gaussianblur      = require('lib.shine').gaussianblur()
    gaussianblur.parameters = {sigma = 5}
    gaussianblur:draw(function()
      self.previous:draw()
    end)
  end)
end

function EntityPalette:keypressed(key)
  if key == ' ' or key == 'escape' then
    require('lib.gamestate').pop()
  end
end

function EntityPalette:resize()
  self:generateMenu()
end

function EntityPalette:update(dt)
  self.tween:update(dt)
  self.scrollArea:update(dt)
end

function EntityPalette:draw()
  lg.setColor(150, 150, 150)
  lg.draw(self.background)

  self.canvas:clear(0, 0, 0, 0)
  self.canvas:renderTo(function()
    lg.setColor(Color.AlmostWhite)
    lg.setFont(Font.Big)
    lg.printf('Entities', 10, 40, lg.getWidth() - 20, 'center')
    self.scrollArea:draw(dt)
  end)

  lg.setColor(255, 255, 255, self.canvasAlpha)
  lg.draw(self.canvas, 0, self.canvasY)
end

return EntityPalette
