local gamestate = require 'lib.gamestate'
local welcome = require 'state.welcome'

function love.load()
	gamestate.registerEvents()
	gamestate.switch(welcome)
end
