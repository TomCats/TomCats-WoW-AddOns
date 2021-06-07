local _, addon = ...

local C_Map = CreateFromMixins(C_Map)
local Enum = Enum
local GetInstanceInfo = GetInstanceInfo
local IsInInstance = IsInInstance
local Mixin = Mixin
local nop = nop
local UnitFactionGroup = UnitFactionGroup

local GetMapInfo = C_Map.GetMapInfo

local function GetMapInfoOverride(mapID)
	local override = addon.mapInfoOverrides[mapID]
	if (override) then
		local faction = UnitFactionGroup("player")
		return override[faction] or override
	end
end

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
	local mapInfo = addon.mapInfos[uiMapID]
	local textures = mapInfo and mapInfo.textures
	if (not textures) then
		textures = GetMapArtLayerTextures(uiMapID, layerIndex)
	end
	return textures
end

function C_Map.GetMapInfo(mapID)
	local mapInfo = addon.mapInfos[mapID]
	if (not mapInfo) then mapInfo = GetMapInfo(mapID) end
	local overrides = GetMapInfoOverride(mapID)
	if (mapInfo and overrides) then
		Mixin(mapInfo, overrides)
	end
	return mapInfo or overrides
end

function C_Map.IsMapValidForNavBarDropDown(mapID)
	local mapInfo = C_Map.GetMapInfo(mapID);
	if (addon.mapDropDownOverrides[mapID]) then return false end
	return mapInfo.mapType == Enum.UIMapType.World or mapInfo.mapType == Enum.UIMapType.Continent or mapInfo.mapType == Enum.UIMapType.Zone;
end

local GetBestMapForUnit = C_Map.GetBestMapForUnit

function C_Map.GetBestMapForUnit(unit)
	local mapID = GetBestMapForUnit(unit)
	if ((not mapID) and unit == "player" and IsInInstance()) then
		local instanceID = select(8, GetInstanceInfo())
		mapID = addon.instanceMapIDLookup[instanceID]
	end
	return mapID
end

C_Map.CloseWorldMapInteraction = nop;

local MapHasArt = C_Map.MapHasArt

function C_Map.MapHasArt(uiMapID)
	return MapHasArt(uiMapID) or addon.mapInfos[uiMapID] and true
end

TomCats_C_Map = C_Map;
