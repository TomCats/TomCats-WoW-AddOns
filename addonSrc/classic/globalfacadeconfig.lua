--[[ See license.txt for license and copyright information ]]
select(2, ...).SetupGlobalFacade()

-- Lua core functions
AddAllowedGlobals({
	"error",
	"ipairs",
	"loadstring",
	"next",
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
	"BaseMapPoiPinMixin",
	"C_Timer",
	"CALENDAR_TYPE_DUNGEON",
	"CALENDAR_TYPE_RAID",
	"CreateFrame",
	"CreateFromMixins",
	"CreateVector2D",
	"Enum",
	"GetAddOnMetadata",
	"GetDifficultyInfo",
	"GetFinalNameFromTextureKit",
	"GetInstanceInfo",
	"GetServerTime",
	"IsInInstance",
	"IsTutorialFlagged",
	"nop",
	"ScrollFrame_OnLoad",
	"SecondsFormatter",
	"SecondsFormatterMixin",
	"SetPortraitToTexture",
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
	"MapCanvasMixin",
	"MapCanvasScrollControllerMixin",
	"MaximizeMinimizeButtonFrameMixin",
	"MiniMapInstanceDifficulty",
	"MiniMapInstanceDifficulty_Update",
	"NineSlicePanelMixin",
	"PortraitFrameMixin",
	"QuestDetailsFrame_OnHide",
	"QuestDetailsFrame_OnShow",
	"QuestLogMixin",
	"QuestLogOwnerMixin",
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
	"QuestMapQuestOptionsDropDown_OnLoad",
	"QuestPOI_Initialize",
	"QuestScrollFrame",
	"QuestsFrame_OnLoad",
	"UIDropDownMenuButton_OnEnter",
	"UIDropDownMenuButton_OnLeave",
	"UIDropDownMenuButtonInvisibleButton_OnEnter",
	"UIDropDownMenuButtonInvisibleButton_OnLeave",
	"WorldMapMixin",
})
