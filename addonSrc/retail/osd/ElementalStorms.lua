--[[ See license.txt for license and copyright information ]]
select(2, ...).SetScope("osd")

function GetElementalStorms()
	-- map IDs 2022-2025 = Dragon Isles zones
	local elementalStorms = { }
	for mapID = 2022, 2025 do
		local pois = C_AreaPoiInfo.GetAreaPOIForMap(mapID)
		for _, v in ipairs(pois) do
			local poi = C_AreaPoiInfo.GetAreaPOIInfo(mapID, v)
			if (poi.atlasName and string.match(poi.atlasName, "^ElementalStorm%-Lesser") and poi.isPrimaryMapForPOI) then
				local elementalStorm = {
					icon = poi.atlasName,
					title = Names.GetMapName(mapID),
					endTime = GetServerTime() + (C_AreaPoiInfo.GetAreaPOISecondsLeft(poi.areaPoiID) or 0)
				}
				table.insert(elementalStorms, elementalStorm)
			end
		end
	end
	if (#elementalStorms == 0) then
		local serverTime = GetServerTime()
		table.insert(elementalStorms, {
			icon = "ElementalStorm-Lesser-Air",
			desaturated = true,
			title = "Elemental Storms (Inactive)",
			endTime = serverTime - (GetServerTime() % 3600) + 3600
		})
	end
	return elementalStorms
end