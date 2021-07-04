--[[ See license.txt for license and copyright information ]]
local _, addon = ...
addon.SetupGlobalFacade()

HINT_ALL = { }

LOOT_TYPE = {
	UNKNOWN = 0,
	MOUNT = 1,
	COMPANION_PET = 2,
	TOY = 3
}

VISIBILITY_TYPE = {
	NONE = 0,
	LIST = 1,
	PIN = 2,
	ALL = 3
}
