--[[ See license.txt for license and copyright information ]]
select(2, ...).SetScope("osd")

local radiantEchoEvents = {
	{ 7615, 115, 32, 70 },
	{ 7637, 32, 70, 115 },
	{ 7818, 70, 115, 32 },
	{ 7998, 115, 32, 70 },
	{ 8062, 115, 32, 70 },
	{ 7999, 32, 70, 115 },
	{ 8060, 32, 70, 115 },
	{ 8000, 70, 115, 32 },
	{ 8061, 70, 115, 32 },
}

local defaultPOIName = "Radiant Echoes"

-- echoes-icon
-- echoes-icon-active
-- echoes-icon-inactive

RadiantEchoes = { }

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

local defaultPOI = {
	name = "Radiant Echoes"
}

local timerInfos = {
	{ 2, "echoes-icon-active", 0, "Currently active in:" },
	{ 3, "echoes-icon-inactive", 0, "Upcoming in:" },
	{ 4, "echoes-icon-inactive", 90 * 60, "Upcoming in:" },
	{ 2, "echoes-icon-inactive", 90 * 60 * 2, "Upcoming in:" },
}

local mapNames = { }

local function GetMapName(uiMapID)
	if (mapNames[uiMapID]) then
		return mapNames[uiMapID]
	end
	local mapInfo = C_Map.GetMapInfo(uiMapID)
	if (mapInfo) then
		mapNames[uiMapID] = mapInfo.name
		return mapInfo.name
	else
		return "..."
	end
end

function RadiantEchoes.GetVisibilityOption()
	return TomCats_Account.preferences.AccessoryWindow.radiantEchoes
end

function RadiantEchoes.IsVisible()
	-- Begin code to disable the timer for Pandaria Remix (may be removed after Pandaria Remix is over)
	if (PlayerGetTimerunningSeasonID()) then return false end
	-- end
	return visibilityFunctions[TomCats_Account.preferences.AccessoryWindow.radiantEchoes]()
end

function RadiantEchoes.Render(Timers, idx)
	local currentEvent
	local secondsLeft
	for _, radiantEchoEvent in ipairs(radiantEchoEvents) do
		secondsLeft = C_AreaPoiInfo.GetAreaPOISecondsLeft(radiantEchoEvent[1])
		if (secondsLeft and secondsLeft >= 0) then
			currentEvent = radiantEchoEvent
			break
		end
	end
	if (not currentEvent) then
		return 0, 0
	end

	local poi = C_AreaPoiInfo.GetAreaPOIInfo(currentEvent[2], currentEvent[1]) or defaultPOI

	local height = 0
	local newRows = 0

	for _, timerInfo in ipairs(timerInfos) do
		local timerRow = Timers:GetTimerRow(idx + newRows)
		local mapName = GetMapName(currentEvent[timerInfo[1]])
		timerRow:SetTitle(mapName)
		timerRow:SetIcon(timerInfo[2])
		timerRow:SetTimer(GetServerTime() + secondsLeft + timerInfo[3])
		timerRow.tooltipFunction = function()
			GameTooltip:AddLine(poi.name, 1, 1, 1, true)
			GameTooltip:AddLine(timerInfo[4])
			GameTooltip:AddLine(mapName)
			GameTooltip:Show()
		end
		height = height + timerRow:GetHeight() + 4
		newRows = newRows + 1
		timerRow:SetShown(true)
	end

	return height, newRows
end

function RadiantEchoes.SetVisibilityOption(value)
	TomCats_Account.preferences.AccessoryWindow.radiantEchoes = value
	UpdateVisibility()
end
