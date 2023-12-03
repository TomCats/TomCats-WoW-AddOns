--[[ See license.txt for license and copyright information ]]
select(2, ...).SetScope("osd")

local mapID = 2200 -- Emerald Dream
local poiID = 7635 -- Superbloom - also 7634
local atlasName = "minimap-genericevent-hornicon"
-- sometimes the POI isn't found for reasons yet to be determined
local defaultPOI = {
    name = "Superbloom",
    widgetSetID = 978
}

Superbloom = { }

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

function Superbloom.GetVisibilityOption()
    return TomCats_Account.preferences.AccessoryWindow.superbloom
end

function Superbloom.IsVisible()
    return visibilityFunctions[TomCats_Account.preferences.AccessoryWindow.superbloom]()
end

function Superbloom.Render(Timers, idx)
    local poi = C_AreaPoiInfo.GetAreaPOIInfo(mapID, poiID) or defaultPOI
    local timerRow = Timers:GetTimerRow(idx)
    timerRow:SetIcon(atlasName)
    local serverTime = GetServerTime()
    local remainder = serverTime % 3600
    local currentHour = serverTime - remainder
    if (remainder > 1200) then
        timerRow:SetTitle(string.format("Next %s", poi.name))
        timerRow:SetStartTime(currentHour + 3600, 0)
    else
        timerRow:SetTitle(string.format("%s Ending", poi.name))
        timerRow:SetStartTime(currentHour + 1200, 0)
    end

    timerRow.tooltipFunction = function()
        GameTooltip:AddLine(poi.name, 1, 1, 1, true)
        GameTooltip_AddWidgetSet(GameTooltip, poi.widgetSetID);
        GameTooltip:Show()
    end

    local height = timerRow:GetHeight() + 4
    timerRow:SetShown(true)
    return height
end

function Superbloom.SetVisibilityOption(value)
    TomCats_Account.preferences.AccessoryWindow.superbloom = value
    UpdateVisibility()
end