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
    local mapInfo = C_Map.GetMapInfo(uiMapID)
    local parentMapID = mapInfo and mapInfo.parentMapID
    if (parentMapID and (not skipParent) and parentMapID ~= 0 and parentMapID ~= 946 and parentMapID ~= 947) then
        addQuestToUIMaps(quest, parentMapID)
    end
end
D["Quest NPC Lookup"] = {}
local mapIconExceptions = {
    ["202216103"] = true
}
for _, quest in pairs(D["Quests"].records) do
    local questID = quest["Quest ID"]
    local uiMapID = quest["UIMap ID"]
    if (questID >= 17398 and questID <= 17405) then
        addQuestToUIMaps(quest, 2151,false)
    elseif (questID >= 17510 and questID <= 17517) then
        addQuestToUIMaps(quest, 2133, false)
    elseif (questID ~= 16101) then
        for i = 2022, 2025 do
            if (not mapIconExceptions[i .. questID]) then
                addQuestToUIMaps(quest, i, i ~= uiMapID)
            end
        end
    else
        addQuestToUIMaps(quest, 2112, true)
        addQuestToUIMaps(quest, 2022, true)
        addQuestToUIMaps(quest, 2023, true)
        addQuestToUIMaps(quest, 2024, true)
        addQuestToUIMaps(quest, 2025)
    end
end
