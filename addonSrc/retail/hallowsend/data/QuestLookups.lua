local _, addon = ...
if (not addon.hallowsend.IsEventActive()) then return end

local D = addon.hallowsend.TomCatsLibs.Data
D["Quest IDs by UIMap ID Lookup"] = {}
local aliasMap = {
    [12] = { 1209 },
    [13] = { 1208 },
}
local parentMapOverrides = {
    [2255] = 2256,
    [2213] = 2216,
    [2216] = 2255
}

local function addQuestToUIMaps(quest, uiMapID)
    if (aliasMap[uiMapID]) then
        for i = 1, #aliasMap[uiMapID] do
            addQuestToUIMaps(quest, aliasMap[uiMapID][i])
        end
    end
    D["Quest IDs by UIMap ID Lookup"][uiMapID] = D["Quest IDs by UIMap ID Lookup"][uiMapID] or {}
    table.insert(D["Quest IDs by UIMap ID Lookup"][uiMapID], quest)
    local parentMapID = parentMapOverrides[uiMapID] or C_Map.GetMapInfo(uiMapID).parentMapID
    if (parentMapID ~= 0 and parentMapID ~= 946 and parentMapID ~= 947) then
        addQuestToUIMaps(quest, parentMapID)
    end
end
D["Quest NPC Lookup"] = {}
for _, quest in pairs(D["Quests"].records) do
    addQuestToUIMaps(quest, quest["UIMap ID"])
    D["Quest NPC Lookup"][1] = true
end
