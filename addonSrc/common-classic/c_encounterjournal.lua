--[[ See license.txt for license and copyright information ]]
select(2, ...).SetupGlobalFacade()

C_EncounterJournal = { }

local instanceTypeAtlases = {
	"Dungeon", "Raid"
}

local instanceTypeDescriptions = {
	CALENDAR_TYPE_DUNGEON, CALENDAR_TYPE_RAID
}

function C_EncounterJournal.GetDungeonEntrancesForMap(mapID)
	local instanceEntrances = instanceEntrances[mapID]
	local entrances = { }
	if (instanceEntrances) then
		for k, v in ipairs(instanceEntrances) do
			local uiMapID = uimapidlookup[v[1]]
			local mapInfoBase = mapinfobase[uiMapID]
			table.insert(entrances, {
				["areaPoiID"] = mapInfoBase[1],
				["position"] = CreateVector2D(v[2],v[3]),
				["name"] = C_Map.GetAreaInfo(mapInfoBase[1]),
				["description"] = instanceTypeDescriptions[mapInfoBase[3]],
				["atlasName"] = instanceTypeAtlases[mapInfoBase[3]],
				["journalInstanceID"] = v[1]
			})
		end
	end
	return entrances
end
