--[[ See license.txt for license and copyright information ]]
select(2, ...).SetScope("osd")

local GetServerTime_Orig = GetServerTime

function GetServerTime()
    return GetServerTime_Orig()
end

GreedyEmissary = { }

local eventActive = false
local eventStart
local gracePeriod = 60 * 6
local regionID = GetCurrentRegion()
local zoneRotations = {
    [1] = { 84,2112,85,2022,84,2023,85,2024,84,2025,85,2112,84,2022,85,2023,84,2024,85,2025,84 },
    [3] = { 84,2023,85,2024,84,2025,85,2112,84,2022,85,2023,84,2024,85,2025,84,2112,85,2022,84 },
}
local zoneRotation

local eventTimes = {
    [1] = { 1685034000, 1686812340 },
    [3] = { 1685001600, 1686779940 },
}

do
    local currentTime = GetServerTime()
    local eventTime = eventTimes[regionID]
    zoneRotation = zoneRotations[regionID]
    if (eventTime and currentTime > eventTime[1] and currentTime < eventTime[2]) then
        eventActive = true
        eventStart = eventTime[1]
    end
end

function GreedyEmissary.IsEventActive()
    return eventActive
end

function GreedyEmissary.GetEvent() -- return zone ID, time until event starts (negative number means now)
    local now = GetServerTime()
    local secondsPast30 = (now - eventStart) % 1800
    local iternum = math.floor((now - eventStart) / 1800)
    local zoneIndex = (iternum % 20) + 1
    if (secondsPast30 >= gracePeriod) then
        return zoneRotation[zoneIndex + 1], now + 1800 - secondsPast30
    else
        return zoneRotation[zoneIndex], now - secondsPast30
    end
end

function GreedyEmissary.GetGracePeriod()
    return gracePeriod
end

local visibilityFunctions = {
    [addon.constants.accessoryDisplay.ALWAYS] = function()
        return true
    end,
    [addon.constants.accessoryDisplay.NEVER] = function()
        return false
    end,
    [addon.constants.accessoryDisplay.NOINSTANCES] = function()
        local inInstance = IsInInstance()
        return not inInstance
    end,
}

function GreedyEmissary.IsVisible()
    return eventActive and 	visibilityFunctions[TomCats_Account.preferences.AccessoryWindow.treasureGoblin]()
end

function TreasureGoblin_GetVisibilityOption()
    return TomCats_Account.preferences.AccessoryWindow.treasureGoblin
end

function TreasureGoblin_SetVisibilityOption(value)
    TomCats_Account.preferences.AccessoryWindow.treasureGoblin = value
    UpdateVisibility()
end

local bagLink_
local mountLink_

local eventFrame = CreateFrame("Frame")
eventFrame:RegisterEvent("ITEM_DATA_LOAD_RESULT")

eventFrame:SetScript("OnEvent", function(_, _, itemID, success)
    if (itemID == 206003 and success) then
        bagLink_ = select(2,GetItemInfo(206003))
    end
    if (itemID == 76755 and success) then
        mountLink_ = select(2,GetItemInfo(76755))
    end
end)

-- cache the item names
C_Item.RequestLoadItemDataByID(206003)
C_Item.RequestLoadItemDataByID(76755)

function GreedyEmissary.LootInfo()
    local bagLink = bagLink_ or "|cFFA335EE|Hitem:206003::::::::61:72:::::::::|h[Horadric Haversack]|h|r"
    local mountLink = mountLink_ or "|cFFA335EE|Hitem:76755::::::::61:72:::::::::|h[Tyrael's Charger]|h|r"
    local hasBag = GetItemCount(206003, true) > 0 or false
    local _, _, _, _, _, _, _, _, _, _, hasMount = C_MountJournal.GetMountInfoByID(439)
    local bagQuestComplete = C_QuestLog.IsQuestFlaggedCompleted(76215)
    local mountQuestComplete = C_QuestLog.IsQuestFlaggedCompleted(76216)

    local text = { }

    if (hasBag) then
        table.insert(text, string.format("\nYou already have %s on this character\n\n", bagLink))
    elseif (bagQuestComplete) then
        table.insert(text, "\nYou've already looted the Treasure Goblin with this character today\n\n")
    else
        table.insert(text, "\nYou've not looted the Treasure Goblin with this character today\n\n")
    end

    if (hasMount) then
        table.insert(text, string.format("You already have %s on this account\n\n\n", mountLink))
    elseif (mountQuestComplete) then
        table.insert(text, "You have already looted the Treasure Goblin using this account today\n\n\n")
    else
        table.insert(text, "You haven't looted the Treasure Goblin using this account today\n\n\n")
    end

    table.insert(text, "|cFFFFD400Additional information:|r\n\n")
    table.insert(text, string.format("Confirmed as once daily per character: Higher chance to loot %s\n\n", bagLink))
    table.insert(text, string.format("Confirmed as once daily per account: Higher chance to loot %s\n\n", mountLink))

    table.insert(text, string.format(
            "\n|cFFFFD400There seems to be an additional chance to loot %s on characters who don't have %s due to how the trackers are working and reports from the community, but I cannot confirm this with absolute certainty.|r", mountLink, bagLink))
    return text
end

function GreedyEmissary.Render(Timers, idx)
    local greedyEmissaryZone, greedyEmissaryStartTime = GreedyEmissary.GetEvent()
    local timerRow = Timers:GetTimerRow(idx)
    local mapInfo = C_Map.GetMapInfo(greedyEmissaryZone)
    timerRow:SetIcon("BuildanAbomination-32x32")
    timerRow:SetTitle(string.format("Treasure Goblin: %s", mapInfo.name))
    timerRow:SetStartTime(greedyEmissaryStartTime, GreedyEmissary.GetGracePeriod())
    timerRow.tooltipFunction = function()
        GameTooltip:SetText("Special Event: A Greedy Emissary (starts)")
        local text = GreedyEmissary.LootInfo()
        for _, v in ipairs(text) do
            GameTooltip:AddLine(v,1,1,1,true)
        end
    end
    local height = timerRow:GetHeight() + 4
    timerRow:SetShown(true)
    return height
end
