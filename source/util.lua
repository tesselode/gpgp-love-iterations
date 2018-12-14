local util = {}

function util.pointInRect(x, y, l, t, r, b)
	return x >= l and x <= r and y >= t and y <= b
end

return util
