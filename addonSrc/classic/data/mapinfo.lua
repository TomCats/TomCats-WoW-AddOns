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
		return 4
	end,
	flags = function(table)
		return 0
	end,
	name = function(table)
		return C_Map.GetAreaInfo(rawget(table,3)) -- areaID at index 3
	end,
	textures = function(table)
		local textures = { }
		local mapDir = rawget(table, 4) -- mapDir and image base name at index 4
		for i = 1, 12 do
			textures[i] = ("Interface\\WorldMap\\%s\\%s%s%s"):format(
					mapDir,
					mapDir,
					rawget(table,5) or "", -- lvlPrefix at index 5
					i
			)
		end
		return textures
	end
}

local mapInfoMetaData = {
	__index = function(table, key)
		return columnIndex[key] and columnIndex[key](table)
	end
}

--[[ columns: mapID, parentMapID, areaID, mapDir, lvlPrefix ]]
-- 1) lookup by name in the Map table (retail)
-- 2) ID is the instance map ID (for lookup table)
-- 3) AreaTableID is the areaID
-- 4) lookup name in the UIMap table (retail)
-- 5) ID is the mapID
-- 6) ParentUIMapID is the parentMapID, but may be incorrect for tbc.  Look at the name and match to TBC

addon.mapInfos = {
	[301] = { 301, 1413, 491, "RazorfenKraul", "1_" },
	[279] = { 279, 1413, 718, "WailingCaverns", "1_" },
	[330] = { 330, 1949, 3923, "GruulsLair", "1_" },
	[232] = { 232, 1428, 2717, "MoltenCore", "1_" },
	[274] = { 274, 1446, 2367, "CoTHillsbradFoothills", nil },
	[273] = { 273, 1446, 2366, "CoTTheBlackMorass", nil },
	[329] = { 329, 1446, 3606, "CoTMountHyjal", nil },
	[248] = { 248, 1445, 2159, "OnyxiasLair", "1_" },
	[347] = { 347, 1944, 3562, "HellfireRamparts", "1_" },
	[261] = { 261, 1944, 3713, "TheBloodFurnace", "1_" },
	[246] = { 246, 1944, 3714, "TheShatteredHalls", "1_" },
	[331] = { 331, 1944, 3836, "Magtheridonslair", "1_" },
	[266] = { 266, 1953, 3847, "TheBotanica", "1_" },
	[334] = { 334, 1953, 3845, "TempestKeep", "1_" },
	[233] = { 233, 1434, 1977, "ZulGurub", nil },
	[213] = { 213, 1454, 2437, "Ragefire", "1_" },
	[247] = { 247, 1414, 3429, "RuinsofAhnQiraj", nil },
	[225] = { 225, 1453, 717, "TheStockade", "1_" },
	[219] = { 219, 1446, 978, "ZulFarrak", nil },
	[272] = { 272, 1952, 3792, "ManaTombs", "1_" },
	[260] = { 260, 1952, 3789, "ShadowLabyrinth", "1_" },
	[300] = { 300, 1441, 722, "RazorfenDowns", "1_" },
	[265] = { 265, 1946, 3717, "TheSlavePens", "1_" },
	[262] = { 262, 1946, 3716, "TheUnderbog", "1_" },
}

for _, v in pairs(addon.mapInfos) do
	setmetatable(v, mapInfoMetaData)
end

addon.instanceMapIDLookup = {
	[47] = 301,
	[43] = 279,
	[565] = 330,
	[409] = 232,
	[560] = 274,
	[269] = 273,
	[534] = 329,
	[249] = 248,
	[543] = 347,
	[542] = 261,
	[540] = 246,
	[544] = 331,
	[553] = 266,
	[550] = 334,
	[309] = 233,
	[389] = 213,
	[509] = 247,
	[34] = 225,
	[209] = 219,
	[557] = 272,
	[555] = 260,
	[129] = 300,
	[547] = 265,
	[546] = 262,
}

addon.mapDropDownOverrides = {
	[1459] = true, -- battleground
	[1460] = true, -- battleground
	[1461] = true, -- battleground
	[301] = true,
	[279] = true,
	[330] = true,
	[232] = true,
	[274] = true,
	[273] = true,
	[329] = true,
	[248] = true,
	[347] = true,
	[261] = true,
	[246] = true,
	[331] = true,
	[266] = true,
	[334] = true,
	[233] = true,
	[213] = true,
	[247] = true,
	[225] = true,
	[219] = true,
	[272] = true,
	[260] = true,
	[300] = true,
	[265] = true,
	[262] = true,
}

addon.mapInfoOverrides = {
	[1459] = { parentMapID = 1424 },
	[1460] = {
		Horde = { parentMapID = 1413 },
		Alliance = { parentMapID = 1440 },
	},
	[1461] = { parentMapID = 1417 },
}
