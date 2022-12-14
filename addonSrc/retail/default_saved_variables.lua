--[[ See license.txt for license and copyright information ]]
local _, addon = ...

addon.defaultSavedVariables = {
	TomCats_Account = {
		lastExpirationWarning = 0,
		preferences = {
			["TomCats-MinimapButton"] = {
				position = -2.888,
				hidden = false
			},
			["TomCats-LunarFestivalMinimapButton"] = {
				position = -2.514,
				hidden = false
			},
			["TomCats-LoveIsInTheAirMinimapButton"] = {
				position = -3.262,
				hidden = false
			},
			["TomCats-HallowsEndMinimapButton"] = {
				position = -2.514,
				hidden = false
			},
			MapOptions = {
				iconAnimationEnabled = true,
				iconScale = 1.0
			},
			betaEnabled = false,
			defaultVignetteIcon = "default",
			dragonGlyphsEnabled = false,
			dragonGlyphsTipShown = false,
		},
		lastVersionSeen = "NONE",
		discoveriesVersion = "0",
		discoveriesResetCount = 0,
		discoveries = {
			vignettes = addon.constants.HINT_ALL,
			vignetteAtlases = addon.constants.HINT_ALL,
			version = "0",
		},
		errorLog = addon.constants.HINT_ALL,
		loveisintheair = addon.constants.HINT_ALL,
		lunarfestival = addon.constants.HINT_ALL,
		hallowsend = addon.constants.HINT_ALL,
		primalstorms = {
			preferences = addon.constants.HINT_ALL,
		}
	},
	TomCats_Character = {
		lunarfestival = {
			preferences = addon.constants.HINT_ALL
		},
		loveisintheair = {
			preferences = addon.constants.HINT_ALL
		},
		hallowsend = {
			preferences = addon.constants.HINT_ALL
		}
	}
}
