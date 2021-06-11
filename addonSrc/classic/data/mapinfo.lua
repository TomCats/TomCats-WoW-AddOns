local _, addon = ...

local UnitFactionGroup = UnitFactionGroup

local mapDropDownOverrides = {
	[1459] = true, -- battleground
	[1460] = true, -- battleground
	[1461] = true, -- battleground
}

--for _, v in pairs(addon.mapInfos) do
--	if (v.enabled) then
--		addon.mapDropDownOverrides[v.mapID] = true
--	end
--end

local mapInfoOverrides = {
	[1459] = { parentMapID = 1424 },
	[1460] = {
		Horde = { parentMapID = 1413 },
		Alliance = { parentMapID = 1440 },
	},
	[1461] = { parentMapID = 1417 },
}

function addon.GetMapInfo(mapID)
	return addon.GetDungeonMapInfo(mapID)
end

function addon.GetMapInfoByInstanceID(instanceID)
	return addon.GetDungeonMapInfoByInstanceID(instanceID)
end

function addon.GetMapInfoOverride(mapID)
	local override = mapInfoOverrides[mapID]
	if (override) then
		local faction = UnitFactionGroup("player")
		return override[faction] or override
	end
end

function addon.IsMapDropDownOverridden(mapID)
	return mapDropDownOverrides[mapID] and true or false
end
