local gamestate = require 'lib.gamestate'
local welcome = require 'state.welcome'

love.keyboard.setKeyRepeat(true)

function love.load()
	gamestate.registerEvents()
	gamestate.switch(welcome)
end

function love.keypressed(key)
	if key == 'r' and love.keyboard.isDown 'lctrl' then
		love.event.quit 'restart'
	end
end
