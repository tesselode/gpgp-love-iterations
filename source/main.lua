local gamestate = require 'lib.gamestate'
local suit = require 'lib.suit'
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

function love.textinput(t)
    suit.textinput(t)
end

function love.keypressed(key)
    suit.keypressed(key)
end
