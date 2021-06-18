local _, addon = ...

local C_Map = CreateFromMixins(C_Map)
local Enum = Enum
local GetInstanceInfo = GetInstanceInfo
local IsInInstance = IsInInstance
local Mixin = Mixin
local nop = nop
local UnitFactionGroup = UnitFactionGroup

local GetMapInfo = C_Map.GetMapInfo

local GetMapArtLayers = C_Map.GetMapArtLayers

function C_Map.GetMapArtLayers(uiMapID)
	local mapArtLayers = GetMapArtLayers(uiMapID)
	if (not mapArtLayers) then
		mapArtLayers = {{["layerHeight"]=668,["layerWidth"]=1002,["maxScale"]=2.1400001049042,["minScale"]=1,["additionalZoomSteps"]=2,["tileHeight"]=256,["tileWidth"]=256}}
	end
	return mapArtLayers
end

local GetMapArtLayerTextures = C_Map.GetMapArtLayerTextures

function C_Map.GetMapArtLayerTextures(uiMapID, layerIndex)
	local textures = GetMapArtLayerTextures(uiMapID, layerIndex)
	if (textures and #textures ~= 0) then
		return textures
	end
	return addon.mapartlayertextures[uiMapID]
end

local battlegroundMaps = {
	[1459] = { parentMapID = 1424 },
	[1460] = {
		Horde = { parentMapID = 1413 },
		Alliance = { parentMapID = 1440 },
	},
	[1461] = { parentMapID = 1417 },
	[1956] = { parentMapID = 1953 }
}

function C_Map.GetMapInfo(mapID)
	local mapInfo = GetMapInfo(mapID)
	if (not mapInfo) then
		local mapInfoBase = addon.mapinfobase[mapID]
		if (not mapInfoBase) then
			local pos = addon.uimapgroupmemberByMap[mapID]
			if (pos) then
				local groupID = addon.uimapgroupmember[pos+1]
				local groupPos = addon.uimapgroupmemberByMapGroup[groupID]
				local newMapID = addon.uimapgroupmember[groupPos+2]
				mapInfoBase = addon.mapinfobase[newMapID]
			end
		end
		if (mapInfoBase) then
			mapInfo = {
				["mapID"] = mapID,
				["name"] = C_Map.GetAreaInfo(mapInfoBase[1]),
				["mapType"] = 4,
				["parentMapID"] = mapInfoBase[2]
			}
		end
	end
	local battlegroundMap = battlegroundMaps[mapID]
	if (mapInfo and battlegroundMap) then
		local faction = UnitFactionGroup("player")
		battlegroundMap = battlegroundMap[faction] or battlegroundMap
		mapInfo.parentMapID = battlegroundMap.parentMapID
	end
	return mapInfo
end

function C_Map.IsMapValidForNavBarDropDown(mapID)
	if (addon.mapinfobase[mapID] or battlegroundMaps[mapID]) then return false end
	local mapInfo = C_Map.GetMapInfo(mapID);
	return mapInfo.mapType == Enum.UIMapType.World or mapInfo.mapType == Enum.UIMapType.Continent or mapInfo.mapType == Enum.UIMapType.Zone;
end

local GetBestMapForUnit = C_Map.GetBestMapForUnit

function C_Map.GetBestMapForUnit(unit)
	local uiMapID = GetBestMapForUnit(unit)
	if ((not uiMapID) and unit == "player" and IsInInstance()) then
		local instanceID = select(8, GetInstanceInfo())
		-- todo: guess the current floor (old world dungeons)
		uiMapID = addon.uimapidlookup[instanceID];
	end
	return uiMapID
end

C_Map.CloseWorldMapInteraction = nop;

local MapHasArt = C_Map.MapHasArt

function C_Map.MapHasArt(uiMapID)
	local mapHasArt = MapHasArt(uiMapID)
	if (mapHasArt) then
		return mapHasArt
	end
	local mapArt = addon.mapartlayertextures[uiMapID]
	return mapArt and true or false
end

function C_Map.GetMapGroupID(mapID)
	local idx = addon.uimapgroupmemberByMap[mapID]
	if (idx) then
		return addon.uimapgroupmember[idx+1]
	end
end

function C_Map.GetMapGroupMembersInfo(mapGroupID)
	local idx = addon.uimapgroupmemberByMapGroup[mapGroupID]
	if (idx) then
		local UiMapGroupMemberInfos = { }
		for i = idx, #addon.uimapgroupmember, 3 do
			if (addon.uimapgroupmember[i+1] == mapGroupID) then
				table.insert(UiMapGroupMemberInfos, {
					["mapID"] = addon.uimapgroupmember[i+2],
					["relativeHeightIndex"] = 0,
					["name"] = addon.uimapgroupmember[i]
				})
			else
				break
			end
		end
		return UiMapGroupMemberInfos
	end
end

TomCats_C_Map = C_Map;
