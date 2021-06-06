local _, addon = ...
local C_Map = C_Map

local columnIndex = {
	mapID = function(table)
		return rawget(table, 1)
	end,
	parentMapID = function(table)
		return rawget(table, 2)
	end,
	mapType = function(table)
		return rawget(table, 3)
	end,
	flags = function(table)
		return rawget(table, 4)
	end,
	name = function(table)
		return C_Map.GetAreaInfo(rawget(table,5)) -- areaID at index 5
	end,
	textures = function(table)
		local textures = { }
		local imageBase = rawget(table, 6) -- image base at index 6
		for i = 1, 12 do
			textures[i] = imageBase .. i
		end
		return textures
	end
}

local mapInfoMetaData = {
	__index = function(table, key)
		return columnIndex[key] and columnIndex[key](table)
	end
}

addon.mapInfos = {
	[225] = { 225, 1453, 4, 0, 717, "Interface\\WorldMap\\TheStockade\\TheStockade1_" }
}

for _, v in pairs(addon.mapInfos) do
	setmetatable(v, mapInfoMetaData)
end

addon.instanceMapIDLookup = {
	[34] = 225,
}

addon.mapDropDownOverrides = {
	[1459] = true,
	[1460] = true,
	[1461] = true,
	[225] = true
}

addon.mapInfoOverrides = {
	[1459] = { parentMapID = 1424 },
	[1460] = {
		Horde = { parentMapID = 1413 },
		Alliance = { parentMapID = 1440 },
	},
	[1461] = { parentMapID = 1417 },
}
