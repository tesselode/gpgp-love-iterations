local gamestate = require 'lib.gamestate'
local welcome = require 'state.welcome'

love.graphics.setDefaultFilter('nearest', 'nearest')

function love.load()
	gamestate.registerEvents()
	gamestate.switch(welcome)
end

function love.resize(...)
    gamestate.resize(...)
end

function love.draw()
    love.graphics.clear(1/12, 1/12, 1/12)
end
