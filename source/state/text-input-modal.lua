local utf8 = require 'utf8'

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
end

function textInputModal:draw()
	love.graphics.print(self.text)
	local textBeforeCursor = self.text:sub(1, self.cursor)
	local cursorPosition = love.graphics.getFont():getWidth(textBeforeCursor)
	love.graphics.line(cursorPosition, 0, cursorPosition, love.graphics.getFont():getHeight())

	love.graphics.print(self.cursor, 0, 16)
end

return textInputModal
