local _, addon = ...

local C_DateAndTime = C_DateAndTime
local GetCurrentRegionName = GetCurrentRegionName
local GetServerTime = GetServerTime

addon.noblegarden = addon.noblegarden or { }
local component = addon.noblegarden

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
-- 1681146000
-- 4/10/2022 10:00am CET in EU (CEST/CEDT - daylight savings time being observed)
local eventStarts = setupGlobalEventTimes(1681113600, 0, 32400, -28800, -25200, -25200)
-- 4/17/2022 10:00am CET in EU (CEST/CEDT - daylight savings time being observed)
local eventEnds = setupGlobalEventTimes(1681718400, 0, 32400, -28800, -25200, -25200)

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


function component.IsEventActive()
	local startTime = component.getEventStartsTime()
	local serverTime = GetServerTime()
	local endTime = component.getEventEndsTime()
	return (serverTime >= startTime and serverTime < endTime)
end
