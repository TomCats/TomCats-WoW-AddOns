local C_Map = CreateFromMixins(C_Map)
local Enum = Enum
local GetInstanceInfo = GetInstanceInfo
local IsInInstance = IsInInstance
local Mixin = Mixin
local nop = nop
local UnitFactionGroup = UnitFactionGroup
--todo: Localize map names
local mapInfoOverrides = {
	[1459] = { parentMapID = 1424 },
	[1460] = {
		Horde = { parentMapID = 1413 },
		Alliance = { parentMapID = 1440 },
	},
	[1461] = { parentMapID = 1417 },
	[225] = {["mapType"]=4,["mapID"]=225,["name"]="The Stockade",["parentMapID"]=1453,["flags"]=0}
}

for k, v in pairs(mapInfoOverrides) do
	v.mapID = k
end

local mapDropDownOverrides = {
	[1459] = true,
	[1460] = true,
	[1461] = true,
	[225] = true
}

local GetMapInfo = C_Map.GetMapInfo

local function GetMapInfoOverride(mapID)
	local override = mapInfoOverrides[mapID]
	if (override) then
		local faction = UnitFactionGroup("player")
		return override[faction] or override
	end
end

local dungeonMaps = {
	[225] = {
		imageBase = "Interface\\WorldMap\\TheStockade\\TheStockade1_",
	}
}

for _, v in pairs(dungeonMaps) do
	local imageBase = v.imageBase
	v.textures = { }
	for i = 1, 12 do
		v.textures[i] = imageBase .. i
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
	local textures = GetMapArtLayerTextures(uiMapID, layerIndex)
	if (not textures) then
		local dungeonMap = dungeonMaps[uiMapID]
		textures = dungeonMap and dungeonMap.textures
	end
	return textures
end

function C_Map.GetMapInfo(mapID)
	local mapInfo = GetMapInfo(mapID)
	local overrides = GetMapInfoOverride(mapID)
	if (mapInfo and overrides) then
		Mixin(mapInfo, overrides)
	end
	return mapInfo or overrides
end

function C_Map.IsMapValidForNavBarDropDown(mapID)
	local mapInfo = C_Map.GetMapInfo(mapID);
	if (mapDropDownOverrides[mapID]) then return false end
	return mapInfo.mapType == Enum.UIMapType.World or mapInfo.mapType == Enum.UIMapType.Continent or mapInfo.mapType == Enum.UIMapType.Zone;
end

local GetBestMapForUnit = C_Map.GetBestMapForUnit

local instanceMapIDLookup = {
	[34] = 225
}

function C_Map.GetBestMapForUnit(unit)
	local mapID = GetBestMapForUnit(unit)
	if ((not mapID) and unit == "player" and IsInInstance()) then
		local instanceID = select(8, GetInstanceInfo())
		mapID = instanceMapIDLookup[instanceID]
	end
	return mapID
end

C_Map.CloseWorldMapInteraction = nop;

local MapHasArt = C_Map.MapHasArt

function C_Map.MapHasArt(uiMapID)
	return MapHasArt(uiMapID) or dungeonMaps[uiMapID] and true
end

TomCats_C_Map = C_Map;
