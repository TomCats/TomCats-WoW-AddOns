--[[ See license.txt for license and copyright information ]]
local _, addon = ...

addon.defaultSavedVariables = {
	TomCats_Account = {
		lastExpirationWarning = 0,
		preferences = {
			AccessoryWindow = {
				WindowLocation = addon.constants.HINT_ALL,
				--todo: remove deprecated 'display' property upon adding new accessory window components
				display = addon.constants.accessoryDisplay.REMOVED,
				elementalStorms = addon.constants.accessoryDisplay.NOINSTANCES,
				treasureGoblin = addon.constants.accessoryDisplay.NOINSTANCES,
				timeRifts = addon.constants.accessoryDisplay.NOINSTANCES,
				superbloom = addon.constants.accessoryDisplay.NOINSTANCES,
				twitchDrops = addon.constants.accessoryDisplay.NOINSTANCES,
				primeGamingLoot = addon.constants.accessoryDisplay.NOINSTANCES,
				blizzardOther = addon.constants.accessoryDisplay.NOINSTANCES,
				radiantEchoes = addon.constants.accessoryDisplay.NOINSTANCES,
				theaterTroupe = addon.constants.accessoryDisplay.NOINSTANCES,
				snoozed = addon.constants.HINT_ALL,
			},
			["TomCats-MinimapButton"] = {
				position = -2.888,
				hidden = false
			},
			["TomCats-LunarFestivalMinimapButton2023"] = {
				position = -2.514,
				hidden = false
			},
			["TomCats-MidsummerMinimapButton2023"] = {
				position = -2.514,
				hidden = false
			},
			["TomCats-LoveIsInTheAirMinimapButton2023"] = {
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
			queuewu = false,
			defaultVignetteIcon = "default",
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
		midsummer = addon.constants.HINT_ALL,
		noblegarden = {
			enabled = true
		},
		hallowsend = addon.constants.HINT_ALL,
		primalstorms = {
			preferences = addon.constants.HINT_ALL,
		},
		mopremix = {
			osd = addon.constants.HINT_ALL, -- bonusXPTracker position
			bonusXPTrackerDisplay = addon.constants.accessoryDisplay.WHENAPPLICABLE,
			collectionTracker = addon.constants.HINT_ALL,
			collectionTrackerDisplay = true,
			filterOptions = {
				collected = true,
				notCollected = true,
				mounts = true,
				pets = true,
				toys = true,
				appearances = true,
				heirlooms = true,
				vendor = true,
				achievement = true
			}
		}
	},
	TomCats_Character = {
		lunarfestival = {
			preferences = addon.constants.HINT_ALL
		},
		midsummer = {
			preferences = addon.constants.HINT_ALL
		},
		loveisintheair = {
			preferences = addon.constants.HINT_ALL
		},
		hallowsend = {
			preferences = addon.constants.HINT_ALL
		},
		mopremix = {
			bonusxp = {
				level = 10,
				xp = 0,
				bonus = 0,
				synchronized = false,
				uncommon = 0,
				rare = 0,
				epic = 0,
			}
		}
	}
}
