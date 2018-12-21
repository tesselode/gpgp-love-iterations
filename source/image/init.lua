local image = {
	pencil = love.graphics.newImage 'image/pencil.png',
	box = love.graphics.newImage 'image/box.png',
	select = love.graphics.newImage 'image/select.png',
}

for _, i in pairs(image) do
	i:setFilter('nearest', 'nearest')
end

return image
