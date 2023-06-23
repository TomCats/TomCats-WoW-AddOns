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
    if (parentMapID ~= 0 and parentMapID ~= 946 and parentMapID ~= 947) then
        addQuestToUIMaps(quest, parentMapID)
    end
end
--D["Quest NPC Lookup"] = {}
for _, quest in pairs(D["Quests"].records) do
    addQuestToUIMaps(quest, quest["UIMap ID"])
--    D["Quest NPC Lookup"][quest["Creature ID"]] = true
end
