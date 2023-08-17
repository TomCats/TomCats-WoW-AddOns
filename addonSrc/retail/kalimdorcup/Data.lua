local _, addon = ...

addon.KalimdorCup = { }

addon.KalimdorCup.EventLocations = { }

local poiInfoCache = { }

local function GetPOIInfo(t)
	local poiID = t.poiID
	local poiInfo = poiInfoCache[poiID]
	if (not poiInfo) then
		local mapID = t.mapID
		poiInfo = C_AreaPoiInfo.GetAreaPOIInfo(mapID, poiID)
		poiInfoCache[poiID] = poiInfo
		if (poiInfo) then
			local continent, worldPosition = C_Map.GetWorldPosFromMapPos(mapID, poiInfo.position)
			local _, kalimdorPosition = C_Map.GetMapPosFromWorldPos(continent, worldPosition, 12)
			poiInfo.x, poiInfo.y = kalimdorPosition.x, kalimdorPosition.y
		end
	end
	return poiInfo or { }
end

local poiColumns = {
	poiID = 1,
	mapID = 2,
}

local eventLocations = {
	{ 7494, 77 },
	{ 7495, 83 },
	{ 7496, 198 },
	{ 7497, 198 },
	{ 7498, 76 },
	{ 7499, 63 },
	{ 7500, 1 },
	{ 7501, 65 },
	{ 7502, 66 },
	{ 7503, 199 },
	{ 7504, 199 },
	{ 7505, 64 },
	{ 7506, 69 },
	{ 7507, 81 },
	{ 7508, 249 },
	{ 7509, 78 },
}

local eventLocationsMetatable = {
	__index = function(t, k)
		local key = poiColumns[k]
		if (type(key) == "number") then
			return rawget(t, key)
		end
		return GetPOIInfo(t)[k]
	end
}

for _, eventLocation in ipairs(eventLocations) do
	setmetatable(eventLocation, eventLocationsMetatable)
	addon.KalimdorCup.EventLocations[eventLocation.poiID] = eventLocation
end

eventLocations = nil
