local Enum = Enum;
local nop = nop;
local C_Map = CreateFromMixins(C_Map)

function C_Map.IsMapValidForNavBarDropDown(mapID)
	local mapInfo = C_Map.GetMapInfo(mapID);
	return mapInfo.mapType == Enum.UIMapType.World or mapInfo.mapType == Enum.UIMapType.Continent or mapInfo.mapType == Enum.UIMapType.Zone;
end

C_Map.CloseWorldMapInteraction = nop;

TomCats_C_Map = C_Map;
