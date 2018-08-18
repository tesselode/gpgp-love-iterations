local gamestate = require 'lib.gamestate'
require 'imgui'
local welcome = require 'state.welcome'

love.graphics.setDefaultFilter('nearest', 'nearest')
love.graphics.setFont(love.graphics.newFont('font/Roboto-Medium.ttf', 18))
imgui.SetGlobalFontFromFileTTF('font/Roboto-Medium.ttf', 18, 0, 0, 4, 4)
imgui.StyleColorsDark()

function love.load()
	gamestate.registerEvents {'update', 'draw', 'directorydropped'}
	gamestate.switch(welcome)
end

function love.update(dt)
	imgui.NewFrame()
end

function love.draw()
    love.graphics.clear(1/12, 1/12, 1/12)
end

function love.quit()
	imgui.ShutDown()
end

function love.textinput(t)
    imgui.TextInput(t)
    if not imgui.GetWantCaptureKeyboard() then
        gamestate.textinput(t)
    end
end

function love.keypressed(key)
    imgui.KeyPressed(key)
    if not imgui.GetWantCaptureKeyboard() then
        gamestate.keypressed(key)
    end
end

function love.keyreleased(key)
    imgui.KeyReleased(key)
    if not imgui.GetWantCaptureKeyboard() then
        gamestate.keyreleased(key)
    end
end

function love.mousemoved(x, y)
    imgui.MouseMoved(x, y)
    if not imgui.GetWantCaptureMouse() then
        gamestate.mousemoved(x, y)
    end
end

function love.mousepressed(x, y, button)
    imgui.MousePressed(button)
    if not imgui.GetWantCaptureMouse() then
        gamestate.mousepressed(x, y, button)
    end
end

function love.mousereleased(x, y, button)
    imgui.MouseReleased(button)
    if not imgui.GetWantCaptureMouse() then
        gamestate.mousereleased(x, y, button)
    end
end

function love.wheelmoved(x, y)
    imgui.WheelMoved(y)
    if not imgui.GetWantCaptureMouse() then
        gamestate.wheelmoved(x, y)
    end
end
