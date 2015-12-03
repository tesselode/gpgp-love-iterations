function love.load()
  gpgp = require('gpgp').init()
end

function love.update(dt)
  gpgp.update(dt)
end

function love.keypressed(key)
  gpgp.keypressed(key)
end

function love.keyreleased(key)
  gpgp.keyreleased(key)
end

function love.mousepressed(x, y, button)
  gpgp.mousepressed(x, y, button)
end

function love.mousereleased(x, y, button)
  gpgp.mousereleased(x, y, button)
end

function love.draw()
  gpgp.draw()
end
