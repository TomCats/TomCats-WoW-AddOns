--[[ See license.txt for license and copyright information ]]
select(2, ...).SetScope()

local mapInfoCache = { }

Names = { }

function Names.GetMapName(mapID)
	if (mapInfoCache[mapID]) then return mapInfoCache[mapID].name end
	local mapInfo = C_Map.GetMapInfo(mapID)
	if (mapInfo and mapInfo.name) then
		mapInfoCache[mapID] = mapInfo
		return mapInfo.name
	end
	return "..."
end
