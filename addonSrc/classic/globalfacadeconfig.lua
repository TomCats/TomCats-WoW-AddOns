--[[ See license.txt for license and copyright information ]]
select(2, ...).SetupGlobalFacade()

-- Lua core functions
AddAllowedGlobals({
	"error",
	"ipairs",
	"loadstring",
	"pairs",
	"setmetatable",
	"tonumber",
	"tostring",
	"type",
	"string",
	"table",
})

-- Blizzard-owned variables
AddAllowedGlobals({
	"ACCEPT_ALT",
	"AnchorUtil",
	"C_Timer",
	"CALENDAR_TYPE_DUNGEON",
	"CALENDAR_TYPE_RAID",
	"CreateFrame",
	"CreateFromMixins",
	"CreateVector2D",
	"Enum",
	"GetAddOnMetadata",
	"GetDifficultyInfo",
	"GetInstanceInfo",
	"GetServerTime",
	"IsInInstance",
	"IsTutorialFlagged",
	"nop",
	"ScrollFrame_OnLoad",
	"SecondsFormatter",
	"SecondsFormatterMixin",
	"StaticPopup_Show",
	"StaticPopupDialogs",
	"UnitFactionGroup",
	"UnitPosition",
})

-- Addon-specific variables
AddAllowedGlobals({
	"TomCats_Static_Popup",
})

-- Renamed globals
AddRenamedGlobals({
	"MiniMapInstanceDifficulty",
	"MiniMapInstanceDifficulty_Update",
	"QuestDetailsFrame_OnHide",
	"QuestDetailsFrame_OnShow",
	"QuestLogMixin",
	"QuestLogPopupDetailFrame",
	"QuestLogPopupDetailFrame_OnHide",
	"QuestLogPopupDetailFrame_OnLoad",
	"QuestMapFrame",
	"QuestMapFrame_OnEvent",
	"QuestMapFrame_OnHide",
	"QuestMapFrame_OnLoad",
	"QuestMapFrame_OnShow",
	"QuestMapLog_HideStoryTooltip",
	"QuestMapLog_ShowStoryTooltip",
	"QuestMapQuestOptionsDropDown",
	"QuestPOI_Initialize",
	"QuestScrollFrame",
	"QuestsFrame_OnLoad",
})
