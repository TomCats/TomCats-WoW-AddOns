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
Enum.QuestFrequency = {["Daily"]=2,["Default"]=1,["Weekly"]=3}
QUEST_OBJECTIVE_DISABLED_FONT_COLOR = Mixin({["r"]=0.498,["g"]=0.498,["b"]=0.498}, ColorMixin)
QUEST_OBJECTIVE_DISABLED_HIGHLIGHT_FONT_COLOR =  Mixin({["r"]=0.6,["g"]=0.6,["b"]=0.6}, ColorMixin)
QUEST_OBJECTIVE_FONT_COLOR =  Mixin({["r"]=0.8,["g"]=0.8,["b"]=0.8}, ColorMixin)
QUEST_OBJECTIVE_HIGHLIGHT_FONT_COLOR =  Mixin({["r"]=1,["g"]=1,["b"]=1}, ColorMixin)
--todo: localize
SHOW_DUNGEON_ENTRACES_ON_MAP_TEXT = "Dungeon Entrances"
--todo: localize
WAYPOINT_OBJECTIVE_FORMAT_OPTIONAL = "0/1 %s (Optional)"