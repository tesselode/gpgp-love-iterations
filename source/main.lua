screenManager = require 'lib.roomy'.new()
local welcome = require 'state.welcome'

love.keyboard.setKeyRepeat(true)

function love.load()
	screenManager:hook()
	screenManager:switch(welcome)
end

function love.keypressed(key)
	if key == 'r' and love.keyboard.isDown 'lctrl' then
		love.event.quit 'restart'
	end
end
