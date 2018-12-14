local gamestate = require 'lib.gamestate'
local levelEditor = require 'state.level-editor'
local Project = require 'class.project'

local project = Project()

function love.load()
	gamestate.registerEvents()
	gamestate.switch(levelEditor, project)
end
