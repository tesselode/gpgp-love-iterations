local Level = require 'class.level'
local Object = require 'lib.classic'
local Tileset = require 'class.tileset'

local Project = Object:extend()

function Project:new(directory, mountPoint)
	self.directory = directory
	self.mountPoint = mountPoint
	local data = love.filesystem.load(mountPoint .. '/config.lua')()
	self.defaultLevelWidth = data.defaultLevelWidth or 16
	self.defaultLevelHeight = data.defaultLevelHeight or 9
	self.maxLevelWidth = data.maxLevelWidth or 1000
	self.maxLevelHeight = data.maxLevelHeight or 1000
	self.tilesets = {}
	if data.tilesets then
		for _, tilesetData in ipairs(data.tilesets) do
			local tileset = Tileset(mountPoint, tilesetData)
			table.insert(self.tilesets, tileset)
			self.tilesets[tilesetData.name] = tileset
		end
	end
end

function Project:getLevels()
	local levelNames = {}
	local levels = {}
	local levelsDirectoryPath = self.mountPoint .. '/levels/'
	if love.filesystem.getInfo(levelsDirectoryPath, 'directory') then
		for _, item in ipairs(love.filesystem.getDirectoryItems(levelsDirectoryPath)) do
			if love.filesystem.getInfo(levelsDirectoryPath .. item, 'file') and item:sub(-4) == '.lua' then
				table.insert(levelNames, item:sub(1, -5))
				table.insert(levels, Level.Import(self, love.filesystem.load(levelsDirectoryPath .. item)()))
			end
		end
	end
	local i = 0
	return function()
		i = i + 1
		return levelNames[i], levels[i]
	end
end

return Project
