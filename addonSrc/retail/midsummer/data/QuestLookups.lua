local _, addon = ...
if (not addon.midsummer.IsEventActive()) then return end

local D = addon.midsummer.TomCatsLibs.Data
D["Quest IDs by UIMap ID Lookup"] = {}
local aliasMap = {
    [12] = { 1209 },
    [13] = { 1208 },
    [1978] = { 2057 },
    --todo: Add flight maps for all continents
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
D["Quest NPC Lookup"] = {}
for _, quest in pairs(D["Quests"].records) do
    addQuestToUIMaps(quest, quest["UIMap ID"])
    D["Quest NPC Lookup"][quest["Creature ID"]] = true
end
