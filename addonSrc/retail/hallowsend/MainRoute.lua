local _, addon = ...
if (not addon.hallowsend.IsEventActive()) then return end

local D = addon.hallowsend.TomCatsLibs.Data
local tcl = addon.hallowsend.TomCatsLibs

local tour
local groupID
local side = 1
local arrow

-- todo: Activate only during hallow's end
tcl.Events.RegisterEvent("PLAYER_LOGIN", addon)

local function announceRoute()
    -- if (tour and #tour > 0) then
    --     print("|cffff0000[|cfff48cbaTomCat|cffff0000] yells: Next stop on the tour is |cffffffff" .. C_Map.GetMapInfo(tour[1]["Map ID"]).name .. "|cffff0000. All aboard!")
    -- end
end

local function findLocationGroupID(mapID)
    if (mapID == 0) then return end
    for _, locationGroup in pairs(D["Location Groups"].records) do
        if (mapID == locationGroup["Group ID"]) then
            return mapID
        end
    end
    local mapInfo = C_Map.GetMapInfo(mapID)
    return findLocationGroupID(mapInfo.parentMapID)
end

local function isLocationActive(location)
    if (C_QuestLog.IsQuestFlaggedCompleted(location["Quest ID"])) then return false end
    if (location["Faction"]) then
        local _, _, standingID = GetFactionInfoByID(location["Faction"])
        if (not standingID or (standingID < 4)) then return false end
    end
    if (location["Prerequisite"]) then
        if (not C_QuestLog.IsQuestFlaggedCompleted(location["Prerequisite"])) then return false end
    end
    return true
end

local function updateTour()
    local currentPosition = C_Map.GetPlayerMapPosition(groupID, "player")
    local updatedTour = {}
    for i = 1, #tour do
        if (isLocationActive(tour[i])) then
            table.insert(updatedTour,tour[i])
        end
    end
    if (#updatedTour == 0) then tour = nil return end
    local nearestLocationDistance
    local nearestLocationIndex
    for i = 1, #updatedTour do
        local distance
        if (currentPosition) then
            local d = CreateVector2D(updatedTour[i]["Group Position"]:GetXY())
            d:Subtract(currentPosition)
            distance = d:GetLength()
        else
            distance = 0
        end
        if (not nearestLocationDistance or (distance < nearestLocationDistance)) then
            nearestLocationDistance = distance
            nearestLocationIndex = i
        end
    end
    for i = 1, nearestLocationIndex - 1 do
        local location = table.remove(updatedTour, 1)
        table.insert(updatedTour,location)
    end
    tour = updatedTour
    announceRoute()
end

local function switchTour(newGroupID)
    if (IsInInstance()) then
        tour = nil
        groupID = nil
        return
    end
    if (newGroupID == groupID) then
        return
    end
    groupID = newGroupID
    if (not groupID) then
        tour = nil
    else
        tour = {}
        for i = 1, #D["Tours"][side][groupID] do
            local location = D["Locations"][D["Tours"][side][groupID][i]]
            table.insert(tour, location)
        end
        updateTour()
    end
end

local function setupArrow(location)
    if (not TomCats_Account.hallowsend.arrowEnabled) then
        if (arrow) then
            arrow:ClearTarget()
        end
        return
    end
    if (arrow and (not tour)) then
        arrow:ClearTarget()
        return
    end
    if (tour) then
        if (not arrow) then
            arrow = addon.hallowsend.CreateArrow(1.0,0.25,0)
            --arrow = tcl.Arrows:CreateArrow("ORANGERED")
            arrow:SetScript("OnEnter", function()
                GameTooltip:SetOwner(Minimap, "ANCHOR_CURSOR")
                GameTooltip:SetText("Next Candy Bucket, " .. C_Map.GetMapInfo(tour[1]["Map ID"]).name)
                GameTooltip:Show()
            end)
            arrow:SetScript("OnLeave", function()
                GameTooltip:Hide()
            end)
        end
        arrow:SetTarget(tour[1]["Group Position"].x, tour[1]["Group Position"].y, groupID)
--        arrow:SetTarget(tour[1]["Group Position"], groupID)
    end
end

function TomCats_HallowsEnd_SetupArrow()
    setupArrow()
end

local function zoneChanged()
    local mapID = C_Map.GetBestMapForUnit("player")
    if (mapID) then
        switchTour(findLocationGroupID(mapID))
    else
        tour = nil
    end
    setupArrow()
end

local function checkTreats()
    for bagId = 0, 4 do
        for slot = 1, C_Container.GetContainerNumSlots(bagId) do
            local itemLink = C_Container.GetContainerItemLink(bagId, slot)
            if (itemLink) then
                local itemId = GetItemInfoInstant(itemLink)
                if (itemId == 37586) then
                    C_Container.UseContainerItem(bagId, slot)
                    return true
                end
            end
        end
    end
    return false
end

local function questComplete(event, ...)
    local _, texture = GetQuestItemInfo("reward", 1)
    if (texture and texture == 132940) then
        if (not checkTreats()) then
            GetQuestReward(0)
        end
    end
end

function addon.SkipPumpkin()
    if (tour) then
        table.remove(tour,1)
        if (#tour == 0) then
            tour = nil
        else
            announceRoute()
        end
        setupArrow()
    end
end

local function questLogUpdate(event, ...)
    if (tour) then
        if (C_QuestLog.IsQuestFlaggedCompleted(tour[1]["Quest ID"])) then
            table.remove(tour,1)
            if (#tour == 0) then
                tour = nil
            else
                announceRoute()
            end
            setupArrow()
        end
    end
end

local function bagUpdate()
    questComplete()
    questLogUpdate()
end

function addon:PLAYER_LOGIN(event, ...)
    tcl.Events.UnregisterEvent("PLAYER_LOGIN", self)
    tcl.Events.RegisterEvent("ZONE_CHANGED", zoneChanged)
    tcl.Events.RegisterEvent("ZONE_CHANGED_INDOORS", zoneChanged)
    tcl.Events.RegisterEvent("ZONE_CHANGED_NEW_AREA", zoneChanged)
    tcl.Events.RegisterEvent("QUEST_COMPLETE", questComplete)
    tcl.Events.RegisterEvent("QUEST_LOG_UPDATE", questLogUpdate)
    tcl.Events.RegisterEvent("BAG_UPDATE", bagUpdate)

    if (UnitFactionGroup("player") == "Horde") then
        side = 2
    end
    for _, location in pairs(D["Locations"].records) do
        location["Group ID"] = findLocationGroupID(location["Map ID"])
        -- todo: handle this in the data lib via type definitions
        location["Map Position"] = CreateVector2D(location["Map Position"][1], location["Map Position"][2])
        local continentID, worldPosition = C_Map.GetWorldPosFromMapPos(location["Map ID"], location["Map Position"])
        local oid, mapPosition = C_Map.GetMapPosFromWorldPos(continentID, worldPosition, location["Group ID"])
        location["Group Position"] = mapPosition
    end
    switchTour(findLocationGroupID(C_Map.GetBestMapForUnit("player")))
    setupArrow()
end

--if (TomCats and TomCats.Register) then
--    TomCats:Register(
--        {
--            name = "@shortName@",
--            version = "@version@",
--        }
--    )
--end
