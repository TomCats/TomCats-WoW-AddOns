local C_Map = CreateFromMixins(C_Map)
local Enum = Enum
local Mixin = Mixin
local nop = nop
local UnitFactionGroup = UnitFactionGroup

local mapInfoOverrides = {
	[1459] = { parentMapID = 1424 },
	[1460] = {
		Horde = { parentMapID = 1413 },
		Alliance = { parentMapID = 1440 },
	},
	[1461] = { parentMapID = 1417 }
}

local mapDropDownOverrides = {
	[1459] = true,
	[1460] = true,
	[1461] = true
}

local GetMapInfo = C_Map.GetMapInfo

local function GetMapInfoOverride(mapID)
	local override = mapInfoOverrides[mapID]
	if (override) then
		local faction = UnitFactionGroup("player")
		return override[faction] or override
	end
end

function C_Map.GetMapInfo(mapID)
	local mapInfo = GetMapInfo(mapID)
	local overrides = GetMapInfoOverride(mapID)
	if (overrides) then
		Mixin(mapInfo, overrides)
	end
	return mapInfo
end

function C_Map.IsMapValidForNavBarDropDown(mapID)
	local mapInfo = C_Map.GetMapInfo(mapID);
	if (mapDropDownOverrides[mapID]) then return false end
	return mapInfo.mapType == Enum.UIMapType.World or mapInfo.mapType == Enum.UIMapType.Continent or mapInfo.mapType == Enum.UIMapType.Zone;
end

C_Map.CloseWorldMapInteraction = nop;

TomCats_C_Map = C_Map;
