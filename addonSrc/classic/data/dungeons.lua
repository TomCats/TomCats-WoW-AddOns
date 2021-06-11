local addonName, addon = ...

local C_Map = C_Map
local CreateVector2D = CreateVector2D

local mapInfos = {
	[33] = { nil, nil, 209, "ShadowfangKeep", nil, 1, false },
	[34] = { 225, 1453, 717, "TheStockade", "1_", 1, true },
	[36] = { nil, nil, 1581, "TheDeadmines", nil, 1, false },
	[43] = { 279, 1413, 718, "WailingCaverns", "1_", 1, true },
	[47] = { 301, 1413, 491, "RazorfenKraul", "1_", 1, true },
	[48] = { nil, nil, 719, "BlackFathomDeeps", nil, 1, false },
	[70] = { nil, nil, 1337, "Uldaman", nil, 1, false },
	[90] = { nil, nil, 721, "Gnomeregan", nil, 1, false },
	[109] = { 220, 1435, 1477, "TheTempleofAtalhakkar", "1_", 1, false },
	[129] = { 300, 1441, 722, "RazorfenDowns", "1_", 1, true },
	[189] = { 302, 1420, 796, "ScarletMonastery", "1_", 1, true },
	[209] = { 219, 1446, 978, "ZulFarrak", nil, 1, true },
	[229] = { nil, nil, 1583, "BlackrockSpire", nil, 1, false },
	[229] = { nil, nil, 1583, "UpperBlackrockSpire", nil, 1, false },
	[230] = { nil, nil, 1584, "BlackrockDepths", nil, 1, false },
	[249] = { 248, 1445, 2159, "OnyxiasLair", "1_", 2, true },
	[269] = { 273, 1446, 2366, "CoTTheBlackMorass", nil, 1, true },
	[289] = { nil, nil, 2057, "Scholomance", nil, 1, false },
	[309] = { 233, 1434, 1977, "ZulGurub", nil, 2, true },
	[329] = { nil, nil, 2017, "Stratholme", nil, 1, false },
	[349] = { nil, nil, 2100, "Maraudon", nil, 1, false },
	[389] = { 213, 1454, 2437, "Ragefire", "1_", 1, true },
	[409] = { 232, 1428, 2717, "MoltenCore", "1_", 2, true },
	[429] = { nil, nil, 2557, "DireMaul", nil, 1, false },
	[469] = { nil, nil, 2677, "BlackwingLair", nil, 2, false },
	[509] = { 247, 1414, 3429, "RuinsofAhnQiraj", nil, 2, true },
	[531] = { nil, nil, 3428, "AhnQiraj", nil, 2, false },
	[532] = { nil, nil, 3457, "Karazhan", nil, 2, false },
	[533] = { nil, nil, 3456, "Naxxramas", nil, 2, false },
	[534] = { 329, 1446, 3606, "CoTMountHyjal", nil, 2, true },
	[540] = { 246, 1944, 3714, "TheShatteredHalls", "1_", 1, true },
	[542] = { 261, 1944, 3713, "TheBloodFurnace", "1_", 1, true },
	[543] = { 347, 1944, 3562, "HellfireRamparts", "1_", 1, true },
	[544] = { 331, 1944, 3836, "Magtheridonslair", "1_", 2, true },
	[545] = { nil, nil, 3715, "TheSteamvault", nil, 1, false },
	[546] = { 262, 1946, 3716, "TheUnderbog", "1_", 1, true },
	[547] = { 265, 1946, 3717, "TheSlavePens", "1_", 1, true },
	[548] = { nil, nil, 3607, "CoilfangReservoir", "1_", 2, false },
	[550] = { 334, 1953, 3845, "TempestKeep", "1_", 2, true },
	[552] = { nil, nil, 3848, "TheArcatraz", nil, 1, false },
	[553] = { 266, 1953, 3847, "TheBotanica", "1_", 1, true },
	[554] = { nil, nil, 3849, "TheMechanar", nil, 1, false },
	[555] = { 260, 1952, 3789, "ShadowLabyrinth", "1_", 1, true },
	[556] = { nil, nil, 3791, "SethekkHalls", nil, 1, false },
	[557] = { 272, 1952, 3792, "ManaTombs", "1_", 1, true },
	[558] = { nil, nil, 3790, "AuchenaiCrypts", nil, 1, false },
	[560] = { 274, 1446, 2367, "CoTHillsbradFoothills", nil, 1, true },
	[564] = { nil, nil, 3959, "BlackTemple", nil, 2, false },
	[565] = { 330, 1949, 3923, "GruulsLair", "1_", 2, true },
	[568] = { nil, nil, 3805, "ZulAman", "1_", 2, false },
	[580] = { nil, nil, 4075, "SunwellPlateau", nil, 2, false },
	[585] = { nil, nil, 4131, "MagistersTerrace", nil, 1, false }
}

local mapInstances = {
	[1412]={{43,0.79426068067551,0.17949755489826}},
	[1418]={{70,0.42032164335251,0.1147603392601}},
	[1419]={{309,0.0051192864775658,0.54609489440918},{532,0.22232064604759,0.2177989333868}},
	[1420]={{189,0.84822076559067,0.30434542894363}},
	[1421]={{33,0.44923853874207,0.6788929104805}},
	[1422]={{189,0.28284573554993,0.15558469295502},{289,0.69791144132614,0.73567205667496}},
	[1423]={{289,0.073637299239635,0.91029942035675},{329,0.27077969908714,0.11516263335943}},
	[1424]={{33,0.058982368558645,0.52919632196426},{289,0.91194820404053,0.06894875317812}},
	[1425]={{289,0.26216879487038,0.081400685012341}},
	[1426]={{90,0.31398692727089,0.38046550750732}},
	[1427]={{469,0.39027065038681,0.96792554855347}},
	[1428]={{469,0.23131608963013,0.26398628950119}},
	[1429]={{34,0.20225048065186,0.36356702446938}},
	[1430]={{532,0.46986642479897,0.74906009435654}},
	[1432]={{70,0.43470877408981,0.87055212259293}},
	[1434]={{36,0.22130382061005,0.024355389177799},{309,0.63942760229111,0.21793684363365},{532,0.76083946228027,0.03444966301322}},
	[1435]={{109,0.69672971963882,0.53535199165344}},
	[1436]={{36,0.4255967438221,0.71615362167358}},
	[1439]={{48,0.33004572987556,0.9467339515686}},
	[1440]={{48,0.14166578650475,0.13809932768345}},
	[1441]={{47,0.28025674819946,0.16957546770573},{129,0.46748125553131,0.23333930969238},{209,0.56302201747894,0.97655260562897},{249,0.74612933397293,0.24697554111481}},
	[1443]={{349,0.29225066304207,0.6253125667572}},
	[1444]={{429,0.59518843889236,0.40323707461357}},
	[1445]={{47,0.13170701265335,0.69450289011002},{129,0.28861892223358,0.74794298410416},{249,0.52215248346329,0.75937139987946}},
	[1446]={{209,0.39488798379898,0.22053006291389}},
	[1448]={{48,0.1509045958519,0.76587164402008}},
	[1449]={{209,0.93079996109009,0.35049417614937}},
	[1451]={{509,0.36442291736603,0.94031953811646},{531,0.24320118129253,0.87290525436401}},
	[1453]={{34,0.5119286775589,0.67792826890945}},
	[1944]={{540,0.48066639900208,0.51917946338654},{542,0.46018454432487,0.51794046163559},{543,0.47920247912407,0.53428453207016},{544,0.46577256917953,0.52836096286774}},
	[1946]={{545,0.50475418567657,0.33337280154228},{546,0.54178369045258,0.34435251355171},{547,0.4895983338356,0.35929784178734}},
	[1949]={{545,0.35175469517708,0.99273979663849},{565,0.69069671630859,0.24142414331436}},
	[1951]={{555,0.96876001358032,0.99808859825134},{557,0.96891921758652,0.85036128759384},{558,0.92039406299591,0.92396026849747}},
	[1952]={{555,0.39627772569656,0.73184156417847},{556,0.4459944665432,0.65609723329544},{557,0.39644062519073,0.58069449663162},{558,0.34679248929024,0.65599721670151}},
	[1953]={{552,0.74369561672211,0.57748460769653},{553,0.71696382761002,0.55060040950775},{554,0.70536023378372,0.6964083313942},{565,0.068974077701569,0.51687926054001}},
}


local instanceTypes = {
	"Dungeon",
	"Raid"
}

local mapInfoColumnIndex = {
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
	end,
	instanceType = function(table)
		return instanceTypes[rawget(table,6)] -- instanceType integer at index 6
	end,
	enabled = function(table)
		return rawget(table, 7)
	end
}

local mapInfoMetaTable = {
	__index = function(table, key)
		return mapInfoColumnIndex[key] and mapInfoColumnIndex[key](table)
	end
}

for _, v in pairs(mapInfos) do
	setmetatable(v, mapInfoMetaTable)
end

local mapInstanceColumnIndex = {
	atlasName = function(table)
		local instance = mapInfos[rawget(table, 1)]
		return instance and instance.instanceType
	end,
	name = function(table)
		local instance = mapInfos[rawget(table, 1)]
		return instance and instance.name
	end,
	position = function(table)
		return CreateVector2D(rawget(table, 2), rawget(table, 3))
	end,
	description = function(table)
		local instance = mapInfos[rawget(table, 1)]
		return instance and instance.instanceType
	end,
	journalInstanceID = function(table)
		return rawget(table, 1)
	end
}

local mapInstanceMetaTable = {
	__index = function(table, key)
		return mapInstanceColumnIndex[key] and mapInstanceColumnIndex[key](table)
	end
}

for _, v in pairs(mapInstances) do
	for _, v1 in ipairs(v) do
		setmetatable(v1, mapInstanceMetaTable)
	end
end

local instancesByMapID = { }

for _, v in pairs(mapInfos) do
	local mapID = v.mapID
	if (mapID) then
		instancesByMapID[v.mapID] = v
	end
	-- exception for Scarlett Monastery
	instancesByMapID[303] = mapInfos[189]
	instancesByMapID[304] = mapInfos[189]
	instancesByMapID[305] = mapInfos[189]
end

local function GetDistance(x1, y1, x2, y2)
	return math.sqrt((x2 - x1)^2 + (y2 - y1)^2)
end

local ScarlettMonasteryInstanceLocations = {
	{ 2915.3000488281, -801.60003662109 }, -- graveyard
	{ 2869.3000488281, -820.79998779297 }, -- library
	{ 2886, -835.79998779297 }, -- armory
	{ 2915.1000976562, -823.60003662109 }, -- cathedral
}

local function SetScarlettMonasteryMapPrefix(mapInfo)
	local bestDistance, bestIndex
	local lastPositionX, lastPositionY = addon:GetLastPlayerPosition()
	for k, v in ipairs(ScarlettMonasteryInstanceLocations) do
		if (not bestDistance) then
			bestDistance = GetDistance(lastPositionX, lastPositionY, v[1], v[2])
			bestIndex = k
		else
			local distance = GetDistance(lastPositionX, lastPositionY, v[1], v[2])
			if (distance < bestDistance) then
				bestDistance = distance
				bestIndex = k
			end
		end
	end
	rawset(mapInfo, 5, bestIndex .. "_")
	rawset(mapInfo, 1, 301 + bestIndex)
end

function addon.GetDungeonMapInfo(mapID)
	local instance = instancesByMapID[mapID]
	if (instance and instance == mapInfos[189]) then
		SetScarlettMonasteryMapPrefix(instance)
	end
	return instance
end

function addon.GetDungeonMapInfoByInstanceID(instanceID)
	local mapInfo = mapInfos[instanceID]
	if (instanceID == 189) then
		SetScarlettMonasteryMapPrefix(mapInfo)
	end
	return mapInfo
end

function addon.GetDungeonsForMap(mapID)
	local mapInstance = mapInstances[mapID];
	if (mapInstance) then
		return mapInstance
	end
	return { }
end
