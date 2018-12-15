local Level = require 'class.level'
local Object = require 'lib.classic'

local Project = Object:extend()

function Project:new(directory, mountPoint, data)
	self.directory = directory
	self.mountPoint = mountPoint
	self.defaultLevelWidth = data.defaultLevelWidth or 16
	self.defaultLevelHeight = data.defaultLevelHeight or 9
	self.maxLevelWidth = data.maxLevelWidth or 1000
	self.maxLevelHeight = data.maxLevelHeight or 1000
end

function Project:loadLevels()
	local levels = {}
	local levelsDirectoryPath = self.mountPoint .. '/levels/'
	if love.filesystem.getInfo(levelsDirectoryPath, 'directory') then
		for _, item in ipairs(love.filesystem.getDirectoryItems(levelsDirectoryPath)) do
			if love.filesystem.getInfo(levelsDirectoryPath .. item, 'file') and item:sub(-4) == '.lua' then
				table.insert(levels, Level(self, love.filesystem.load(levelsDirectoryPath .. item)()))
			end
		end
	end
	if #levels == 0 then
		table.insert(levels, Level(self))
	end
	return levels
end

return Project
