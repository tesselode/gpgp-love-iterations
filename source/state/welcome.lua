local boxer = require 'lib.boxer'
local mainEditor = require 'state.main-editor'
local Project = require 'class.project'
local ScrollArea = require 'class.ui.scroll-area'

local welcome = {}

function welcome:enter()
	self.scrollArea = ScrollArea {
		x = 50,
		y = 50,
		width = 500,
		height = 500,
		content = {
			boxer.paragraph {
				font = love.graphics.newFont(24),
				text = [[
					Eius reprehenderit a eligendi molestiae eligendi voluptas unde culpa. Et eveniet dolor dolorem consectetur reiciendis rerum iste. Hic est tempore fugiat asperiores.

					Explicabo rerum eos nesciunt omnis vero aliquid rerum sapiente. Est repellat eos autem. Optio et rerum aliquid dignissimos hic tenetur. Optio quis id sequi ut. Quisquam aliquam error eos dolorem ullam.

					Perspiciatis et et quas debitis. Aut numquam est corporis pariatur sunt sed. Non laudantium earum odit officiis. Ducimus aperiam amet esse assumenda nostrum nesciunt. Eveniet expedita aut nemo in aut odio. Quos ut et at vero vitae numquam rerum et.

					Quaerat mollitia dolorum est debitis ipsa. Voluptate ut itaque culpa recusandae sed eligendi reprehenderit corrupti. Aut voluptas facere sequi aut quasi. Omnis sint quo debitis quidem est. Magni dolores sit provident saepe aut. Consequatur qui nam ipsam vel.

					Velit blanditiis dicta quisquam dolores vero. Et laboriosam qui rerum accusantium iure nam. Corrupti quam rerum ea. Dolorum est similique alias consequatur dolore ratione. Consequatur quis suscipit eos necessitatibus.
				]],
				width = 500,
			}
		}
	}
end

function welcome:directorydropped(path)
	local success = love.filesystem.mount(path, 'project')
	if not success then return end
	local project = Project(path, 'project')
	screenManager:switch(mainEditor, project)
end

function welcome:mousemoved(...)
	self.scrollArea:mousemoved(...)
end

function welcome:mousepressed(...)
	self.scrollArea:mousepressed(...)
end

function welcome:mousereleased(...)
	self.scrollArea:mousereleased(...)
end

function welcome:draw()
	love.graphics.push 'all'
	love.graphics.print 'drag a project folder onto the window to begin'
	self.scrollArea:draw()
	love.graphics.pop()
end

return welcome
