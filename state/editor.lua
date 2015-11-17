local Editor = {}

function Editor:enter()
  self.scale = 25
end

function Editor:draw()
  love.graphics.push()
  love.graphics.scale(self.scale)
    love.graphics.setColor(255, 255, 255)
    love.graphics.setLineWidth(1 / self.scale)

    --draw border
    love.graphics.line(0, 0, level.width, 0)
    love.graphics.line(0, level.height, level.width, level.height)
    love.graphics.line(0, 0, 0, level.height)
    love.graphics.line(level.width, 0, level.width, level.height)

    --draw gridlines
    love.graphics.setColor(255, 255, 255, 100)
    for i = 1, level.width - 1 do
      love.graphics.line(i, 0, i, level.height)
    end
    for i = 1, level.height - 1 do
      love.graphics.line(0, i, level.width, i)
    end

  love.graphics.pop()
end

return Editor
