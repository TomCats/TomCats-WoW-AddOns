--[[ See license.txt for license and copyright information ]]
select(2, ...).SetupGlobalFacade()

-- addon specific
HINT_ALL = { }
LOOT_TYPE = {
	UNKNOWN = 0,
	MOUNT = 1,
	COMPANION_PET = 2,
	TOY = 3
}
VISIBILITY_TYPE = {
	NONE = 0,
	LIST = 1,
	PIN = 2,
	ALL = 3
}

-- imported from retail
Enum = CreateFromMixins(getglobal("Enum"))
Enum.QuestWatchType = {["Automatic"]=0,["Manual"]=1}
Enum.QuestFrequency = {["Daily"]=1,["Default"]=0,["Weekly"]=2}
QUEST_OBJECTIVE_DISABLED_FONT_COLOR = Mixin({["r"]=0.498,["g"]=0.498,["b"]=0.498}, ColorMixin)
QUEST_OBJECTIVE_DISABLED_HIGHLIGHT_FONT_COLOR =  Mixin({["r"]=0.6,["g"]=0.6,["b"]=0.6}, ColorMixin)
QUEST_OBJECTIVE_FONT_COLOR =  Mixin({["r"]=0.8,["g"]=0.8,["b"]=0.8}, ColorMixin)
QUEST_OBJECTIVE_HIGHLIGHT_FONT_COLOR =  Mixin({["r"]=1,["g"]=1,["b"]=1}, ColorMixin)
QUEST_TAG_TCOORDS = {
	["COMPLETED"] = { 0.140625, 0.28125, 0, 0.28125 },
	["DAILY"] = { 0.28125, 0.421875, 0, 0.28125 },
	["WEEKLY"] = { 0.28125, 0.421875, 0.5625, 0.84375 },
	["FAILED"] = { 0.84375, 0.984375, 0.28125, 0.5625 },
	["STORY"] = { 0.703125, 0.84375, 0.28125, 0.5625 },
	["ALLIANCE"] = { 0.421875, 0.5625, 0.28125, 0.5625 },
	["HORDE"] = { 0.5625, 0.703125, 0.28125, 0.5625 },
	["EXPIRING_SOON"] = { 0.84375, 0.984375, 0.5625, 0.84375 },
	["EXPIRING"] = { 0.703125, 0.84375, 0.5625, 0.84375 },
	[Enum.QuestTag.Dungeon] = { 0.421875, 0.5625, 0, 0.28125 },
	[Enum.QuestTag.Scenario] = { 0.5625, 0.703125, 0, 0.28125 },
	[Enum.QuestTag.Account] = { 0.84375, 0.984375, 0, 0.28125 },
	[Enum.QuestTag.Legendary] = { 0, 0.140625, 0.28125, 0.5625 },
	[Enum.QuestTag.Group] = { 0.140625, 0.28125, 0.28125, 0.5625 },
	[Enum.QuestTag.PvP] = { 0.28125, 0.421875, 0.28125, 0.5625 },
	[Enum.QuestTag.Heroic] = { 0, 0.140625, 0.5625, 0.84375 },
	-- same texture for all raids
	[Enum.QuestTag.Raid] = { 0.703125, 0.84375, 0, 0.28125 },
	[Enum.QuestTag.Raid10] = { 0.703125, 0.84375, 0, 0.28125 },
	[Enum.QuestTag.Raid25] = { 0.703125, 0.84375, 0, 0.28125 },
}
--todo: localize
SHOW_DUNGEON_ENTRACES_ON_MAP_TEXT = "Dungeon Entrances"
