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
	"UnitFactionGroup",
	"ACCEPT_ALT",
	"C_Timer",
	"CreateFrame",
	"CreateFromMixins",
	"Enum",
	"GetAddOnMetadata",
	"GetInstanceInfo",
	"GetServerTime",
	"IsInInstance",
	"nop",
	"StaticPopup_Show",
	"StaticPopupDialogs",
	"UnitPosition",
})

-- Addon-specific variables
AddAllowedGlobals({
	"TomCats_Static_Popup",
})
