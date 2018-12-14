local Object = require 'lib.classic'

local Project = Object:extend()

function Project:new(directory, mountPoint, data)
	self.directory = directory
	self.mountPoint = mountPoint
	self.defaultLevelWidth = data.defaultLevelWidth or 16
	self.defaultLevelHeight = data.defaultLevelHeight or 9
	self.maxLevelWidth = data.maxLevelWidth or 1000
	self.maxLevelHeight = data.maxLevelHeight or 1000
	self:getLevelPaths()
end

function Project:getLevelFilePaths()
	local levelsDirectoryPath = self.mountPoint .. '/levels/'
	if not love.filesystem.getInfo(levelsDirectoryPath, 'directory') then
		return
	end
	local levelFilePaths = {}
	for _, item in ipairs(love.filesystem.getDirectoryItems(levelsDirectoryPath)) do
		if love.filesystem.getInfo(levelsDirectoryPath .. item, 'file') and item:sub(-4) == '.lua' then
			table.insert(levelFilePaths, item)
		end
	end
	return levelFilePaths
end

return Project
