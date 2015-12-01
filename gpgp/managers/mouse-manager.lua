local currentFolder = (...):gsub('%.[^%.]+$', '')

local vector = require currentFolder..'.lib.vector'

local pos              = vector(love.mouse.getX(), love.mouse.getY())
local posPrev          = pos
local left, leftPrev   = false, false
local right, rightPrev = false, false

local Mouse = {}

function Mouse:update(dt)
  posPrev   = pos
  pos       = vector(love.mouse.getX(), love.mouse.getY())
  leftPrev  = left
  left      = love.mouse.isDown('l')
  rightPrev = right
  right     = love.mouse.isDown('r')
end

function Mouse:leftPressed() return left and (not leftPrev) end
function Mouse:leftReleased() return leftPrev and (not left) end
function Mouse:rightPressed() return right and (not rightPrev) end
function Mouse:rightReleased() return rightPrev and (not right) end

function Mouse:getPosition() return pos end
function Mouse:getDelta() return pos - posPrev end

function Mouse:within(targetPos, targetSize)
  return math.between(pos.x, targetPos.x, targetPos.x + targetSize.x)
    and math.between(pos.y, targetPos.y, targetPos.y + targetSize.y)
end

return Mouse
