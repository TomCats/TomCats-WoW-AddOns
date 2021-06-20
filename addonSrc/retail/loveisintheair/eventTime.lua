local _, addon = ...

local C_DateAndTime = C_DateAndTime
local GetCurrentRegionName = GetCurrentRegionName
local GetServerTime = GetServerTime

addon.loveisintheair = addon.loveisintheair or { }
local component = addon.loveisintheair

local currentOffsetMinutes
local eventEndsTime
local eventStartsTime
local lastResetTimestamp

local function setupGlobalEventTimes(val, euOffset, naOffset, krOffset, cnOffset, twOffset) -- setup event time relative to EU
	local times = { }
	times.EU = val + euOffset
	times.NA = val + naOffset
	times.KR = val + krOffset
	times.CN = val + cnOffset
	times.TW = val + twOffset
	return times
end

-- 2/8/2021 7:00am UTC in EU
local eventResets = setupGlobalEventTimes(1612767600, 0, 28800, -28800, -28800, -28800)
-- 2/8/2021 10:00am CET in EU
local eventStarts = setupGlobalEventTimes(1612774800, 0, 32400, -28800, -25200, -25200)
-- 2/22/2021 10:00am CET in EU
local eventEnds = setupGlobalEventTimes(1613984400, 0, 32400, -28800, -25200, -25200)

function component.getCurrentOffsetMinutes()
	if (currentOffsetMinutes) then return currentOffsetMinutes end
	local localTime = C_DateAndTime.GetCalendarTimeFromEpoch(GetServerTime()* 1000000)
	local serverTime = C_DateAndTime.GetCurrentCalendarTime()
	local minutesOffset = serverTime.minute - localTime.minute
	local hoursOffset = serverTime.hour - localTime.hour
	local daysOffset = serverTime.weekday - localTime.weekday
	if (daysOffset > 1) then daysOffset = -1 end
	if (daysOffset < -1) then daysOffset = 1 end
	currentOffsetMinutes = math.floor( (minutesOffset + (hoursOffset * 60) + (daysOffset * 60 * 24)) / 15 + 0.5) * 15
	return currentOffsetMinutes
end

local availableRegions = {
	EU = true, NA = true, KR = true, CN = true, TW = true
}

local function getRegion()
	local region = GetCurrentRegionName();
	if (availableRegions[region]) then return region end
	return "NA";
end

function component.getEventEndsTime()
	if (not eventEndsTime) then
		eventEndsTime = eventEnds[getRegion()]
	end
	return eventEndsTime
end


function component.getEventStartsTime()
	if (not eventStartsTime) then
		eventStartsTime = eventStarts[getRegion()]
	end
	return eventStartsTime
end

function component.GetNextResetTimestamp()
	if (not lastResetTimestamp) then
		component.GetLastResetTimestamp()
	end
	return lastResetTimestamp + 60 * 60 * 24
end

function component.GetLastResetTimestamp()
	if (not lastResetTimestamp) then
		local serverTime = GetServerTime()
		local firstReset = eventResets[getRegion()]
		lastResetTimestamp = firstReset
		for i = firstReset, firstReset + (60 * 60 * 24 * 15), 60 * 60 * 24 do
			if (i > serverTime) then
				break
			end
			lastResetTimestamp = i
		end
	end
	local time = GetServerTime()
	if (component.GetNextResetTimestamp() <= time) then
		lastResetTimestamp = component.GetNextResetTimestamp()
	end
	return lastResetTimestamp
end

function component.IsEventActive()
	local startTime = component.getEventStartsTime()
	local localTime = GetServerTime()
	local endTime = component.getEventEndsTime()
	return (localTime >= startTime and localTime < endTime)
end
