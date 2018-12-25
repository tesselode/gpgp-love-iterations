local boxer = require 'lib.boxer'
local image = require 'image'
local ToolbarButton = require 'class.ui.toolbar-button'

local toolbarHeight = 48
local buttonMargin = 8

return function(props)
	local toolbar = boxer.box {
		x = 0,
		y = 0,
		width = function() return love.graphics.getWidth() end,
		height = toolbarHeight,
		style = {
			idle = {
				fillColor = {.1, .1, .1},
			},
		},
	}

	local levelsButton = ToolbarButton {
		x = buttonMargin,
		y = buttonMargin,
		image = image.folder,
	}
	local layersButton = ToolbarButton {
		x = function() return levelsButton.right + buttonMargin end,
		y = buttonMargin,
		image = image.layers,
	}
	local historyButton = ToolbarButton {
		x = function() return layersButton.right + buttonMargin end,
		y = buttonMargin,
		image = image.history,
	}

	local selectButton = ToolbarButton {
		right = function() return love.graphics.getWidth() - buttonMargin end,
		y = buttonMargin,
		image = image.select,
		isActive = function() return props.getTool() == 'select' end,
		onPress = function() props.setTool 'select' end,
	}
	local boxButton = ToolbarButton {
		right = function() return selectButton.left end,
		y = buttonMargin,
		image = image.box,
		isActive = function() return props.getTool() == 'box' end,
		onPress = function() props.setTool 'box' end,
	}
	local pencilButton = ToolbarButton {
		right = function() return boxButton.left end,
		y = buttonMargin,
		image = image.pencil,
		isActive = function() return props.getTool() == 'pencil' end,
		onPress = function() props.setTool 'pencil' end,
	}

	toolbar.children = {
		levelsButton,
		layersButton,
		historyButton,
		selectButton,
		boxButton,
		pencilButton,
	}

	return toolbar
end
