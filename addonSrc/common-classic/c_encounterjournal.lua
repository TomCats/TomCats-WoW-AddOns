local addonName, addon = ...

local C_EncounterJournal = { }

function C_EncounterJournal.GetDungeonEntrancesForMap(mapID)
	return addon.GetDungeonsForMap(mapID)
end

TomCats_C_EncounterJournal = C_EncounterJournal
