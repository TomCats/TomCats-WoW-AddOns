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
local itemIDsToCache = { 199838, 199839, 199836, 199837, 199211 }

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

DEBUG_GetItemName = Names.GetItemName
