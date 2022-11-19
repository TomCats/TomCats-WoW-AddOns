local addonName, addon = ...

local L = addon.PrimalStorms.L

addon.PrimalStorms.Names = { }

local Names = addon.PrimalStorms.Names

local mapNameCache = { }

function Names.GetMapName(mapID)
	if (mapNameCache[mapID]) then return mapNameCache[mapID] end
	local mapInfo = C_Map.GetMapInfo(mapID)
	if (mapInfo and mapInfo.name) then
		mapNameCache[mapID] = mapInfo.name
		return mapInfo.name
	end
	return "..."
end

local itemNameCache = { }

function Names.GetItemName(itemID)
	if (itemNameCache[itemID]) then return itemNameCache[itemID] end
	local itemName = GetItemInfo(itemID)
	if (itemName) then
		itemNameCache[itemID] = itemName
		return itemName
	end
	return "..."
end

local loadFrame = CreateFrame("Frame")
local interval, timeSinceLastUpdate = 1, 0

local mapIDsToCache = { 15, 10, 2070, 78 }
local itemIDsToCache = {
	199838,
	199839,
	199836,
	199837,
	199211,
	199686,
	199416,
	199406,
	199403,
	199409,
	199408,
	199402,
	199399,
	199400,
	199407,
	199401,
	199404,
	199405,
	199351,
	199359,
	199367,
	199375,
	199348,
	199356,
	199364,
	199372,
	199352,
	199360,
	199368,
	199376,
	199353,
	199361,
	199369,
	199377,
	199349,
	199357,
	199365,
	199373,
	199350,
	199358,
	199366,
	199374,
	199354,
	199362,
	199370,
	199378,
	199355,
	199363,
	199371,
	199379,
	199384,
	199385,
	199380,
	199386,
	199109,
}

loadFrame:SetScript("OnUpdate", function(self, elapsed)
	timeSinceLastUpdate = timeSinceLastUpdate + elapsed
	if (timeSinceLastUpdate > interval) then
		timeSinceLastUpdate = 0
		local cached = true
		for _, mapID in ipairs(mapIDsToCache) do
			if (not mapNameCache[mapID]) then
				Names.GetMapName(mapID)
			end
			if (not mapNameCache[mapID]) then cached = false end
		end
		for _, itemID in ipairs(itemIDsToCache) do
			if (not itemNameCache[itemID]) then
				Names.GetItemName(itemID)
			end
			if (not itemNameCache[itemID]) then cached = false end
		end
		if (cached) then
			self:SetScript("OnUpdate", nil)
		end
	end
end)

