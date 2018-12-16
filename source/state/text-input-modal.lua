local font = require 'font'
local utf8 = require 'utf8'
local util = require 'util'

local textInputModal = {}

function textInputModal:enter()
	self.text = ''
	self.cursor = 0
end

function textInputModal:textinput(t)
	self.text = self.text:sub(1, self.cursor) .. t .. self.text:sub(self.cursor + 1)
	self.cursor = self.cursor + 1
end

function textInputModal:keypressed(key)
	if key == 'left' and self.cursor > 0 then
		self.cursor = self.cursor - 1
	end
	if key == 'right' and self.cursor < #self.text then
		self.cursor = self.cursor + 1
	end
	if key == 'backspace' then
		local textBeforeCursor = self.text:sub(1, self.cursor)
		local textAfterCursor = self.text:sub(self.cursor + 1)
		local offset = utf8.offset(textBeforeCursor, -1)
		if offset then
			self.text = textBeforeCursor:sub(1, offset - 1) .. textAfterCursor
			self.cursor = self.cursor - 1
		end
	end
	if key == 'delete' and self.cursor < #self.text then
		local textBeforeCursor = self.text:sub(1, self.cursor + 1)
		local textAfterCursor = self.text:sub(self.cursor + 2)
		local offset = utf8.offset(textBeforeCursor, -1)
		if offset then
			self.text = textBeforeCursor:sub(1, offset - 1) .. textAfterCursor
		end
	end
	if key == 'home' then self.cursor = 0 end
	if key == 'end' then self.cursor = #self.text end
end

function textInputModal:drawText()
	love.graphics.setFont(font.big)
	love.graphics.print(self.text)
	local textBeforeCursor = self.text:sub(1, self.cursor)
	local cursorPosition = font.big:getWidth(textBeforeCursor)
	love.graphics.setColor(1, 1, 1, .5 + .5 * util.beefySine(love.timer.getTime() * 8, 1/4))
	love.graphics.setLineWidth(2)
	love.graphics.line(cursorPosition, 0, cursorPosition, font.big:getHeight())
end

function textInputModal:draw()
	love.graphics.push 'all'
	love.graphics.translate(love.graphics.getWidth() / 4, love.graphics.getHeight() / 2.25)
	love.graphics.setFont(font.normal)
	love.graphics.print 'Enter text!'
	love.graphics.translate(0, font.normal:getHeight())
	self:drawText()
	love.graphics.pop()
end

return textInputModal
