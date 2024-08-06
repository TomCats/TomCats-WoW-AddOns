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
local timerIncrement = 0

local lastEvent, lastEndTime, unknownTime

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
	{ 2, false, 0, "Currently active in:" },
	{ 3, true, 0, "Upcoming in:" },
	{ 4, true, 60, "Upcoming in:" },
	{ 2, true, 120, "Upcoming in:" },
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

local function LoadPOIs()
	local currentEvent, endTime
	if (not lastEvent) then
		local events = C_AreaPoiInfo.GetEventsForMap(947)
		if (events) then
			for _, event in ipairs(events) do
				for _, poi in ipairs(radiantEchoEvents) do
					if (event == poi[1]) then
						lastEvent = poi
						lastEndTime = GetServerTime()
						unknownTime = true
					end
				end
			end
		end
	end
	for _, radiantEchoEvent in ipairs(radiantEchoEvents) do
		local secondsLeft = C_AreaPoiInfo.GetAreaPOISecondsLeft(radiantEchoEvent[1])
		if (secondsLeft and secondsLeft >= 0) then
			currentEvent = radiantEchoEvent
			lastEvent = currentEvent
			endTime = GetServerTime() + secondsLeft
			lastEndTime = endTime
			unknownTime = false
			break
		end
	end
	return currentEvent, endTime
end

local initialized = false

function RadiantEchoes.IsVisible()
	-- Begin code to disable the timer for Pandaria Remix (may be removed after Pandaria Remix is over)
	if (PlayerGetTimerunningSeasonID()) then return false end
	-- end
	local visible = visibilityFunctions[TomCats_Account.preferences.AccessoryWindow.radiantEchoes]()
	if (visible and not lastEvent) then
		LoadPOIs()
		if (not lastEvent) then
			return false
		end
	end
	if (visible and not initialized) then
		local serverTime = GetServerTime()
		local secondsUntilReset = C_DateAndTime.GetSecondsUntilWeeklyReset()
		local nextResetTime = serverTime + secondsUntilReset
		local startOfWeek = nextResetTime - 7 * 24 * 60 * 60
		if (startOfWeek > 1724644800) then
			timerIncrement = 0
		else
			timerIncrement = 60
		--elseif (startOfWeek > 1723435200) then
		--	timerIncrement = 30
		--elseif (startOfWeek > 1722830400) then
		--	timerIncrement = 60
		--elseif (startOfWeek > 1722225600) then
		--	timerIncrement = 90
		end
		initialized = true
	end
	if (timerIncrement == 0) then
		return false
	end
	return visible
end

function RadiantEchoes.Render(Timers, idx)
	local currentEvent, endTime = LoadPOIs()
	if (lastEvent and not currentEvent) then
		currentEvent = lastEvent
		endTime = math.max(GetServerTime(), lastEndTime)
	end
	if (not currentEvent) then
		return 0, 0
	end

	local poi = C_AreaPoiInfo.GetAreaPOIInfo(currentEvent[2], currentEvent[1]) or defaultPOI

	local height = 0
	local newRows = 0

	local resetTime = GetServerTime() + C_DateAndTime.GetSecondsUntilWeeklyReset() + 60
	for _, timerInfo in ipairs(timerInfos) do
		local timerRow = Timers:GetTimerRow(idx + newRows)
		local mapName = GetMapName(currentEvent[timerInfo[1]])
		timerRow:SetTitle(mapName)
		timerRow:SetIcon("echoes-icon-active", timerInfo[2])
		local timeToSet = 0
		if (not unknownTime) then
			timeToSet = endTime + (timerInfo[3] * timerIncrement)
		else
			timeToSet = lastEndTime
		end
		timerRow:SetTimer(timeToSet)
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
