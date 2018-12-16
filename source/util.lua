local util = {}

function util.lerp(a, b, f)
	return a + (b - a) * f
end

function util.pointInRect(x, y, l, t, r, b)
	return x >= l and x <= r and y >= t and y <= b
end

function util.shallowCopy(t)
	local copy = {}
	for k, v in pairs(t) do
		copy[k] = v
	end
	return copy
end

function util.beefySine(x, p)
	local value = math.sin(x)
	if value < 0 then
		value = value * -1
		value = value ^ p
		value = value * -1
	else
		value = value ^ p
	end
	return value
end

return util
