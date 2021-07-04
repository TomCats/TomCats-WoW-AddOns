--[[ See license.txt for license and copyright information ]]
select(2, ...).SetupGlobalFacade()

-- Lua core functions
AddAllowedGlobals({
	"ipairs",
	"loadstring",
	"pairs",
	"tonumber",
	"tostring",
	"type",
	"string",
	"table",
})

-- Blizzard-owned variables
AddAllowedGlobals({
	"ACCEPT_ALT",
	"C_Timer",
	"CALENDAR_TYPE_DUNGEON",
	"CALENDAR_TYPE_RAID",
	"CreateFrame",
	"CreateFromMixins",
	"CreateVector2D",
	"Enum",
	"GetAddOnMetadata",
	"GetInstanceInfo",
	"GetServerTime",
	"IsInInstance",
	"nop",
	"StaticPopup_Show",
	"StaticPopupDialogs",
	"UnitFactionGroup",
	"UnitPosition",
})

-- Addon-specific variables
AddAllowedGlobals({
	"TomCats_Static_Popup",
})
