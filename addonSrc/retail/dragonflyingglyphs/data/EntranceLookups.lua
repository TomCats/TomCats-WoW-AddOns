local _, addon = ...

local D = addon.TomCatsLibs.Data
D["Entrance IDs by UIMap ID Lookup"] = {}
local aliasMap = {
    [12] = { 1209 },
    [13] = { 1208 }
}
local function addEntranceToUIMaps(entrance, uiMapID)
    if (aliasMap[uiMapID]) then
        for i = 1, #aliasMap[uiMapID] do
            addEntranceToUIMaps(entrance, aliasMap[uiMapID][i])
        end
    end
    D["Entrance IDs by UIMap ID Lookup"][uiMapID] = D["Entrance IDs by UIMap ID Lookup"][uiMapID] or {}
    table.insert(D["Entrance IDs by UIMap ID Lookup"][uiMapID], entrance)
    if (entrance["Add to Parent UIMaps"]) then
        local parentMapID = C_Map.GetMapInfo(uiMapID).parentMapID
        if (parentMapID ~= 0 and parentMapID ~= 946 and parentMapID ~= 947) then
            addEntranceToUIMaps(entrance, parentMapID)
        end
    end
end
D["Entrance IDs by Quest ID Lookup"] = {}
local function addEntranceToQuest(entrance, questID)
    D["Entrance IDs by Quest ID Lookup"][questID] = D["Entrance IDs by Quest ID Lookup"][questID] or {}
    table.insert(D["Entrance IDs by Quest ID Lookup"][questID], entrance)
end
for _, entrance in pairs(D["Entrances"].records) do
    addEntranceToUIMaps(entrance, entrance["UIMap ID"])
    for i = 1, #entrance["Quest IDs"] do
        addEntranceToQuest(entrance, entrance["Quest IDs"][i])
    end
end
