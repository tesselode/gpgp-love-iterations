local util = {}

function util.shallowCopy(t)
	local copy = {}
	for k, v in pairs(t) do
		copy[k] = v
	end
	return copy
end

function util.pointInRect(x, y, l, t, r, b)
	return x >= l and x <= r and y >= t and y <= b
end

return util
