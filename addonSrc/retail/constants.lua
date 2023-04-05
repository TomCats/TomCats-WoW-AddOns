--[[ See license.txt for license and copyright information ]]
local _, addon = ...

addon.constants = { }

addon.constants.HINT_ALL = { }

addon.constants.lootTypes = {
	UNKNOWN = 0,
	MOUNT = 1,
	COMPANION_PET = 2,
	TOY = 3
}

addon.constants.visibilityTypes = {
	NONE = 0,
	LIST = 1,
	PIN = 2,
	ALL = 3
}

addon.constants.accessoryDisplay = {
	ALWAYS = 1,
	NEVER = 2,
	NOINSTANCES = 3,
	RELEVANTZONES = 4,
	REMOVED = 100
}

TOMCATS_TOOLTIP_BACKDROP_STYLE_DEFAULT = {
	bgFile = "Interface/Tooltips/UI-Tooltip-Background",
	edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
	tile = true,
	tileEdge = true,
	tileSize = 16,
	edgeSize = 16,
	insets = { left = 4, right = 4, top = 4, bottom = 4 },
	backdropBorderColor = TOOLTIP_DEFAULT_COLOR,
	backdropColor = TOOLTIP_DEFAULT_BACKGROUND_COLOR,
}
