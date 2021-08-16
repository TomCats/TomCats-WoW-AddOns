--[[ See license.txt for license and copyright information ]]
local _, addon = ...

local HINT_ALL = addon.constants.HINT_ALL

addon.defaultSavedVariables = {
	TomCats_Account = {
		lastExpirationWarning = 0,
		minimapInstanceDifficultyAnchorOverride = addon.constants.HINT_ALL,
	},
	TomCats_Character = {
		miniWorldMap = "1",
		mapFadeSet = false,
		lastPlayerPosition = {
			x = 0,
			y = 0
		},
		showDungeonEntrancesOnMap = "1"
	}
}

addon.cvarsAsSavedVariables = {
	miniWorldMap = "TomCats_Character",
	showDungeonEntrancesOnMap = "TomCats_Character"
}
