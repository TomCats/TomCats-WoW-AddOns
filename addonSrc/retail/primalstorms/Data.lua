local _, addon = ...
local L = addon.PrimalStorms.L

local labelFormat = "%s: %s"

addon.PrimalStorms.Elements = {
	FIRE = {
		label = labelFormat:format(L["Primal Elements"], L["Fire"]),
		icon = "elementalstorm-lesser-fire",
		dimmedIcon = "Interface/icons/inv_10_elementalcombinedfoozles_fire",
		dimmedItem = 199836
	},
	WATER = {
		label = labelFormat:format(L["Primal Elements"], L["Water"]),
		icon = "elementalstorm-lesser-water",
		dimmedIcon = "Interface/icons/inv_10_elementalcombinedfoozles_water",
		dimmedItem = 199839
	},
	AIR = {
		label = labelFormat:format(L["Primal Elements"], L["Air (Storm)"]),
		icon = "elementalstorm-lesser-air",
		dimmedIcon = "Interface/icons/inv_10_elementalcombinedfoozles_lightning",
		dimmedItem = 199838
	},
	EARTH = {
		label = labelFormat:format(L["Primal Elements"], L["Earth"]),
		icon = "elementalstorm-lesser-earth",
		dimmedIcon = "Interface/icons/Inv_10_elementalcombinedfoozles_earth",
		dimmedItem = 199837
	},
}

local Elements = addon.PrimalStorms.Elements

addon.PrimalStorms.ZoneEncounters = {
	{
		mapID = 15,
		{
			element = Elements.FIRE,
			elementsPOI = 7368,
			stormPOI = 7047,
		},
		{
			element = Elements.WATER,
			elementsPOI = 7369,
			stormPOI = 7060,
		},
		{
			element = Elements.AIR,
			elementsPOI = 7367,
			stormPOI = 7058,
		},
		{
			element = Elements.EARTH,
			elementsPOI = 7366,
			stormPOI = 7059,
		}
	},
	{
		mapID = 10,
		{
			element = Elements.FIRE,
			elementsPOI = 7372,
			stormPOI = 7069,
		},
		{
			element = Elements.WATER,
			elementsPOI = 7373,
			stormPOI = 7071,
		},
		{
			element = Elements.AIR,
			elementsPOI = 7370,
			stormPOI = 7062,
		},
		{
			element = Elements.EARTH,
			elementsPOI = 7371,
			stormPOI = 7066,
		}
	},
	{
		mapID = 18,
		{
			element = Elements.FIRE,
			elementsPOI = 7376,
			stormPOI = 7068,
		},
		{
			element = Elements.WATER,
			elementsPOI = 7377,
			stormPOI = 7072,
		},
		{
			element = Elements.AIR,
			elementsPOI = 7374,
			stormPOI = 7063,
		},
		{
			element = Elements.EARTH,
			elementsPOI = 7375,
			stormPOI = 7067,
		}
	},
	{
		mapID = 78,
		{
			element = Elements.FIRE,
			elementsPOI = 7380,
			stormPOI = 7064,
		},
		{
			element = Elements.WATER,
			elementsPOI = 7381,
			stormPOI = 7070,
		},
		{
			element = Elements.AIR,
			elementsPOI = 7378,
			stormPOI = 7061,
		},
		{
			element = Elements.EARTH,
			elementsPOI = 7379,
			stormPOI = 7065,
		}
	}
}

addon.PrimalStorms.StormVendors = {
	[195899] = true,
	[195912] = true
}


