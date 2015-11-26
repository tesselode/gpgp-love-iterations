local x, y                             = love.mouse.getX(), love.mouse.getY()
local xPrev, yPrev                     = x, y
local left, leftPrev, right, rightPrev = false, false, false, false

local Mouse = {}

function Mouse:update(dt)
  xPrev, yPrev = x, y
  x, y         = love.mouse.getX(), love.mouse.getY()
  leftPrev     = left
  left         = love.mouse.isDown('l')
  rightPrev    = right
  right        = love.mouse.isDown('r')
end

function Mouse:leftPressed() return left and (not leftPrev) end
function Mouse:leftReleased() return leftPrev and (not left) end
function Mouse:rightPressed() return right and (not rightPrev) end
function Mouse:rightReleased() return rightPrev and (not right) end

function Mouse:getDelta() return x - xPrev, y - yPrev end

function Mouse:within(tx, ty, tw, th)
  return math.between(x, tx, tx + tw) and math.between(y, ty, ty + th)
end

return Mouse
