function math.lerp(a, b, x)
  return a + (b - a) * x
end

function math.clamp(x, a, b)
  if x < a then
    return a
  elseif x > b then
    return b
  else
    return x
  end
end

function math.sign(x)
  if x < 0 then
    return -1
  else
    return 1
  end
end

function math.weirdsign(x)
  if x < 0 then
    return 0
  else
    return 1
  end
end

function math.smaller(a, b)
  if a < b then
    return a, b
  else
    return b, a
  end
end

local floor = math.floor
function math.floor(x, i)
  i = i or 1
  return floor(x / i) * i
end

function math.between(x, a, b)
  return x > a and x < b
end

function table.clone(obj, seen)
  if type(obj) ~= 'table' then return obj end
  if seen and seen[obj] then return seen[obj] end
  local s = seen or {}
  local res = setmetatable({}, getmetatable(obj))
  s[obj] = res
  for k, v in pairs(obj) do res[table.clone(k, s)] = table.clone(v, s) end
  return res
end

function table.removeValue(t, value)
  for i = #t, 1, -1 do
    if t[i] == value then
      table.remove(t, i)
    end
  end
end
