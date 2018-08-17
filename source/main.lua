local gamestate = require 'lib.gamestate'
local welcome = require 'state.welcome'

love.graphics.setDefaultFilter('nearest', 'nearest')

function love.load()
	gamestate.registerEvents()
	gamestate.switch(welcome)
end
