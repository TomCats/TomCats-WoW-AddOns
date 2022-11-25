local _, addon = ...

local D = addon.TomCatsLibs.Data
D["Quest IDs by UIMap ID Lookup"] = {}
local aliasMap = {
    [12] = { 1209 },
    [13] = { 1208 }
}
local function addQuestToUIMaps(quest, uiMapID, skipParent)
    if (aliasMap[uiMapID]) then
        for i = 1, #aliasMap[uiMapID] do
            addQuestToUIMaps(quest, aliasMap[uiMapID][i])
        end
    end
    D["Quest IDs by UIMap ID Lookup"][uiMapID] = D["Quest IDs by UIMap ID Lookup"][uiMapID] or {}
    table.insert(D["Quest IDs by UIMap ID Lookup"][uiMapID], quest)
    local parentMapID = C_Map.GetMapInfo(uiMapID).parentMapID
    if ((not skipParent) and parentMapID ~= 0 and parentMapID ~= 946 and parentMapID ~= 947) then
        addQuestToUIMaps(quest, parentMapID)
    end
end
D["Quest NPC Lookup"] = {}
for _, quest in pairs(D["Quests"].records) do
    if (quest["Quest ID"] ~= 16101) then
        for i = 2022, 2025 do
            addQuestToUIMaps(quest, i, i ~= quest["UIMap ID"])
        end
    else
        addQuestToUIMaps(quest, 2112, true)
        addQuestToUIMaps(quest, 2022, true)
        addQuestToUIMaps(quest, 2023, true)
        addQuestToUIMaps(quest, 2024, true)
        addQuestToUIMaps(quest, 2025)
    end
end
