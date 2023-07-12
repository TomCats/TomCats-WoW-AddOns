--[[ See license.txt for license and copyright information ]]
select(2, ...).SetScope()

local FORMAT_GT_1DAY = (DAY_ONELETTER_ABBR .. HOUR_ONELETTER_ABBR):gsub("%s+", "")
local FORMAT_GT_1HOUR = (HOUR_ONELETTER_ABBR .. MINUTE_ONELETTER_ABBR):gsub("%s+", "")
local FORMAT_GT_1MIN =  MINUTE_ONELETTER_ABBR:gsub("%s+", "")
local FORMAT_LT_1MIN = SECOND_ONELETTER_ABBR:gsub("%s+", "")

Time = { }

function Time.FormatRemainingTime(duration, notime)
	if (duration >= 86400) then
		local days = math.floor(duration / 86400)
		local hours = math.floor((duration % 86400) / 3600)
		return FORMAT_GT_1DAY:format(days, hours)
	elseif (duration >= 3600) then
		local hours = math.floor(duration / 3600)
		local minutes = math.floor((duration % 3600) / 60)
		return FORMAT_GT_1HOUR:format(hours, minutes)
	elseif (duration >= 60) then
		local minutes = math.ceil(duration / 60)
		return FORMAT_GT_1MIN:format(minutes)
	elseif (duration <= 0) then
		return notime or ""
	else
		return FORMAT_LT_1MIN:format(duration)
	end
end
