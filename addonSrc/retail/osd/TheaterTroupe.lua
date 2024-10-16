--[[ See license.txt for license and copyright information ]]
select(2, ...).SetScope("osd")

-- Order: The Rivals, The Wanderer, Forget Me Not, The Cruelty of Dornic, The Thraegar's Descent

--local events = {
--	[7654] = { active = true, remap = 8077 },
--	[7899] = { active = true, remap = 7943 },
--	[7900] = { active = true, remap = 8078 },
--	[7901] = { active = true, remap = 8076 },
--	[7902] = { active = true, remap = 8079 },
--	[8077] = { active = false, remap = 7899 },
--	[7943] = { active = false, remap = 7900 },
--	[8078] = { active = false, remap = 7901 },
--	[8076] = { active = false, remap = 7902 },
--	[8079] = { active = false, remap = 7654 },
--}

--local eventMapID = 2248
--local lastEventID

TheaterTroupe = { }

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

function TheaterTroupe.GetVisibilityOption()
	return TomCats_Account.preferences.AccessoryWindow.theaterTroupe
end

--local function LoadPOIs()
--	local currentAreaPOIs = C_AreaPoiInfo.GetEventsForMap(eventMapID)
--	lastEventID = nil
--	for _, poi in ipairs(currentAreaPOIs) do
--		if (events[poi]) then
--			lastEventID = poi
--			return true
--		end
--	end
--	return false
--end

local function SecondsUntilNextHour()
	-- Get the current server time
	local serverTime = GetServerTime()

	-- Convert serverTime to the current minute and second within the current hour
	local currentMinute = tonumber(date("%M", serverTime))
	local currentSecond = tonumber(date("%S", serverTime))

	-- Calculate the total seconds elapsed in the current hour
	local secondsElapsedThisHour = currentMinute * 60 + currentSecond

	-- Calculate the total number of seconds in an hour (3600 seconds)
	local secondsInAnHour = 3600

	-- Calculate the seconds remaining until the top of the next hour
	local secondsUntilNextHour = secondsInAnHour - secondsElapsedThisHour

	-- Return the result
	return secondsUntilNextHour
end

function TheaterTroupe.IsVisible()
	local visible = visibilityFunctions[TomCats_Account.preferences.AccessoryWindow.theaterTroupe]()
	--if (visible) then
	--	LoadPOIs()
	--	if (lastEventID) then
	--		return true
	--	end
	--	return false
	--end
	--return false
	return visible
end

function TheaterTroupe.Render(Timers, idx)
	--local timeRemaining = C_AreaPoiInfo.GetAreaPOISecondsLeft(lastEventID) + 5 * 60
	local timeRemaining = SecondsUntilNextHour()
	local timerRow = Timers:GetTimerRow(idx)
	timerRow:SetTitle("Theater Troupe")
	timerRow:SetIcon("ui-eventpoi-theatretroupe")
	if (timeRemaining > 50 * 60) then
		timerRow:SetTimer(-1)
	else
		timerRow:SetTimer(GetServerTime() + timeRemaining)
	end
	timerRow.tooltipFunction = function()
		GameTooltip:AddLine("Theater Troupe", 1, 1, 1, true)
		local tr = SecondsUntilNextHour()
		if (tr < 50 * 60) then
			GameTooltip:AddLine("The next play will be showing at the top of the hour!")
		else
			GameTooltip:AddLine("Now showing! Join the cast and crew and help with the play!")
		end
		GameTooltip:Show()
	end
	return timerRow:GetHeight() + 4
end

function TheaterTroupe.SetVisibilityOption(value)
	TomCats_Account.preferences.AccessoryWindow.theaterTroupe = value
	UpdateVisibility()
end
