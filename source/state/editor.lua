local editor = {}

function editor:enter(previous, project)
	self.project = project
end

function editor:draw()
	love.graphics.print(tostring(self.project))
end

return editor
