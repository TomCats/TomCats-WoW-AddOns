--[[ See license.txt for license and copyright information ]]
select(2, ...).SetupGlobalFacade()

defaultSavedVariables = {
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

cvarsAsSavedVariables = {
	miniWorldMap = "TomCats_Character",
	showDungeonEntrancesOnMap = "TomCats_Character"
}
