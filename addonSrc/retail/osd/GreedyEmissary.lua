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

function IsGreedyEmissaryVisible()
    return eventActive and 	visibilityFunctions[TomCats_Account.preferences.AccessoryWindow.treasureGoblin]()
end

function TreasureGoblin_GetVisibilityOption()
    return TomCats_Account.preferences.AccessoryWindow.treasureGoblin
end

function TreasureGoblin_SetVisibilityOption(value)
    TomCats_Account.preferences.AccessoryWindow.treasureGoblin = value
    UpdateVisibility()
end

function GreedyEmissary.KilledToday()
    return C_QuestLog.IsQuestFlaggedCompleted(76215)
end