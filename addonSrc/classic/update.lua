--[[ See license.txt for license and copyright information ]]
local addonName, addon = ...

local C_DateAndTime = C_DateAndTime
local GetAddOnMetadata = GetAddOnMetadata
local GetCurrentRegionName = GetCurrentRegionName
local GetServerTime = GetServerTime

local component = { }

local currentOffsetMinutes
local eventEndsTime

local function setupGlobalEventTimes(val, euOffset, naOffset, krOffset, cnOffset, twOffset) -- setup event time relative to EU
	local times = { }
	times.EU = val + euOffset
	times.NA = val + naOffset
	times.KR = val + krOffset
	times.CN = val + cnOffset
	times.TW = val + twOffset
	return times
end

local expiration = tonumber(GetAddOnMetadata("TomCats", "X-TomCats-Expiry"))

local eventEnds = setupGlobalEventTimes(expiration, 0, 32400, -28800, -25200, -25200)

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

function component.Isxpired()
	local localTime = GetServerTime()
	local endTime = component.getEventEndsTime()
	return (localTime >= endTime)
end

local function ShowExpirationPopup()
	StaticPopupDialogs["TOMCATS_ADDON_EXPIRED"] = {
		text = "TomCat's AddOn Suite is outdated and needs to be updated in order to continue working properly",
		button1 = ACCEPT_ALT,
		whileDead = 1,
		hideOnEscape = 1
	};
	StaticPopup_Show("TOMCATS_ADDON_EXPIRED")
end

local function OnEvent(event, arg1, arg2)
	if (event == "ADDON_LOADED") then
		if (addonName == arg1) then
			addon.UnregisterEvent("ADDON_LOADED", OnEvent)
			if (component.Isxpired()) then
				local localTime = GetServerTime()
				if (_G.TomCats_Account.lastExpirationWarning + 86400 <= localTime) then
					_G.TomCats_Account.lastExpirationWarning = localTime
					ShowExpirationPopup()
				end
			else
				_G.TomCats_Account.lastExpirationWarning = 0
			end
		end
		return
	end
end

addon.RegisterEvent("ADDON_LOADED", OnEvent)
