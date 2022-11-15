local addonName, addon = ...

addon.PrimalStorms.Elements = {
	FIRE = {
		label = "Fire",
		icon = "elementalstorm-lesser-fire",
	},
	WATER = {
		label = "Water",
		icon = "elementalstorm-lesser-water",
	},
	AIR = {
		label = "Air",
		icon = "elementalstorm-lesser-air",
	},
	EARTH = {
		label = "Earth",
		icon = "elementalstorm-lesser-earth",
	},
}

local Elements = addon.PrimalStorms.Elements

addon.PrimalStorms.ZoneEncounters = {
	{
		name = "Badlands",
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
		name = "Northern Barrens",
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
		name = "Tirisfal Glades",
		mapID = 2070,
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
		name = "Un'Goro Crater",
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
