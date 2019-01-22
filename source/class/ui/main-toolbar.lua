local boxer = require 'lib.boxer'
local image = require 'image'
local ToolbarButton = require 'class.ui.toolbar-button'

local toolbarPadding = 8
local toolbarButtonSpacing = 8

return function(options)
	local levelsButton = ToolbarButton {
		x = toolbarPadding,
		y = toolbarPadding,
		image = image.folder,
		onPress = options.onOpenLevelsMenu,
	}

	local layersButton = ToolbarButton {
		x = levelsButton.right + toolbarButtonSpacing,
		y = toolbarPadding,
		image = image.layers,
		onPress = options.onOpenLayersMenu,
	}

	local historyButton = ToolbarButton {
		x = layersButton.right + toolbarButtonSpacing,
		y = toolbarPadding,
		image = image.history,
		onPress = options.onOpenHistoryMenu,
	}

	local selectButton = ToolbarButton {
		right = function() return love.graphics.getWidth() - toolbarPadding end,
		y = toolbarPadding,
		image = image.select,
		onPress = function()
			if options.onSelectTool then
				options.onSelectTool 'select'
			end
		end,
		isActive = function()
			return options.getCurrentTool and options.getCurrentTool() == 'select'
		end,
	}

	local boxButton = ToolbarButton {
		right = function() return selectButton.left end,
		y = toolbarPadding,
		image = image.box,
		onPress = function()
			if options.onSelectTool then
				options.onSelectTool 'box'
			end
		end,
		isActive = function()
			return options.getCurrentTool and options.getCurrentTool() == 'box'
		end,
	}

	local pencilButton = ToolbarButton {
		right = function() return boxButton.left end,
		y = toolbarPadding,
		image = image.pencil,
		onPress = function()
			if options.onSelectTool then
				options.onSelectTool 'pencil'
			end
		end,
		isActive = function()
			return options.getCurrentTool and options.getCurrentTool() == 'pencil'
		end,
	}

	local toolbar = boxer.wrap {
		children = {
			levelsButton,
			layersButton,
			historyButton,
			selectButton,
			boxButton,
			pencilButton,
		},
		padding = toolbarPadding,
	}
	toolbar.x = 0
	toolbar.y = 0
	toolbar.style = {
		idle = {
			fillColor = {.1, .1, .1},
		}
	}
	return toolbar
end
