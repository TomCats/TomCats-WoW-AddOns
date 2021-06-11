--[[ See license.txt for license and copyright information ]]
local _, addon = ...

addon.defaultSavedVariables = {
	TomCats_Account = {
		lastExpirationWarning = 0
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
