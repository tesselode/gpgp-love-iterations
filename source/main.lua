local gamestate = require 'lib.gamestate'
local welcome = require 'state.welcome'

love.keyboard.setKeyRepeat(true)

function love.load()
	gamestate.registerEvents()
	gamestate.switch(welcome)
end
