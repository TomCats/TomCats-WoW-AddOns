local _, addon = ...
if (not addon.midsummer.IsEventActive()) then return end

local D = addon.midsummer.TomCatsLibs.Data
D["Quest IDs by UIMap ID Lookup"] = {}
local aliasMap = {
    [12] = { 1209 }, -- Kalimdor
    [13] = { 1208 }, -- Eastern Kingdoms
    [101] = { 1467 }, -- Outland
    [113] = { 1384 }, -- Northrend
    [424] = { 1923 }, -- Pandaria
    [572] = { 1922 }, -- Draenor
    [619] = { 993 }, -- Broken Isles
    [875] = { 1011 }, -- Zandalar
    [876] = { 1014 }, -- Kul Tiras
    [1978] = { 2057 }, -- Dragon Isles
    [2133] = { 2175 }, -- Zaralek Cavern
    [13] = { 94, 95, 110, 2393, 2395, 2437, 2512, 2537 }, -- Ghostlands, Eversong Woods
}

local uiMapExclusions = {
    [94] = true,
    [95] = true,
    [110] = true,
    [2393] = true,
    [2395] = true,
    [2437] = true,
    [2512] = true,
    [2537] = true,
}

local parentMapExclusions = {
    [0] = true,
    [946] = true,
    [947] = true,
}

local function addQuestToUIMaps(quest, uiMapID)
    if (aliasMap[uiMapID]) then
        for i = 1, #aliasMap[uiMapID] do
            addQuestToUIMaps(quest, aliasMap[uiMapID][i])
        end
    end
    D["Quest IDs by UIMap ID Lookup"][uiMapID] = D["Quest IDs by UIMap ID Lookup"][uiMapID] or {}
    table.insert(D["Quest IDs by UIMap ID Lookup"][uiMapID], quest)
    local parentMapID = C_Map.GetMapInfo(uiMapID).parentMapID
    if (not (uiMapExclusions[uiMapID] or parentMapExclusions[parentMapID])) then
        addQuestToUIMaps(quest, parentMapID)
    end
end
--D["Quest NPC Lookup"] = {}
for _, quest in pairs(D["Quests"].records) do
    addQuestToUIMaps(quest, quest["UIMap ID"])
--    D["Quest NPC Lookup"][quest["Creature ID"]] = true
end
