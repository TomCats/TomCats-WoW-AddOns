local _, addon = ...
if (not addon.midsummer.IsEventActive()) then return end

local Coords = CreateVector2D

local PlayerFaction = UnitFactionGroup("player")

if (PlayerFaction == "Horde") then
	addon.midsummer.TomCatsLibs.Data.loadData(
			"Quests",
			{ "Quest ID", "Creature ID", "Area ID", "UIMap ID", "Map Type", "Location" },
			{
				{ 11840,15549, 1584,14,3, Coords(0.6936,0.4257) },
				{ 11732,15549, 1584,14,3, Coords(0.4455,0.4622) },
				{ 11862,15549, 1584,18,3, Coords(0.5722,0.5175) },
				{ 11740,15549, 1584,62,3, Coords(0.49,0.225) },
				{ 11935,15549, 1584,89,3, Coords(0.63,0.47) },
				{ 11933,15549, 1584,103,3, Coords(0.41,0.26) },
				{ 9324,15549, 1584,85,3, Coords(0.47,0.38) },
				{ 9330,15549, 1584,90,3, Coords(0.68,0.09) },
				{ 28948,15549, 1584,249,3, Coords(0.53,0.344) },
				{ 28950,15549, 1584,249,3, Coords(0.53,0.32) },
				{ 28947,15549, 1584,249,3, Coords(0.534,0.32) },
				{ 28949,15549, 1584,249,3, Coords(0.53,0.34) },
				{ 32496,15549, 1584,390,3, Coords(0.779,0.339) },
				{ 32510,15549, 1584,390,3, Coords(0.796,0.372) },
				{ 32503,15549, 1584,390,3, Coords(0.798,0.37) },
				{ 32509,15549, 1584,390,3, Coords(0.778,0.331) },
			}
	)
else
	addon.midsummer.TomCatsLibs.Data.loadData(
			"Quests",
			{ "Quest ID", "Creature ID", "Area ID", "UIMap ID", "Map Type", "Location" },
			{
				--{ 28925,15549, 1584,15,3, Coords(0.19,0.56) },
				--{ 11766,15549, 1584,15,3, Coords(0.185,0.561) },
				--{ 28917,15549, 1584,17,3, Coords(0.465,0.142) },
				--{ 11808,15549, 1584,17,3, Coords(0.58,0.17) },
				--{ 11776,15549, 1584,25,3, Coords(0.545,0.5) },
				{ 11786,15549, 1584,18,3, Coords(0.5704,0.5182) },
			}
	)
end
