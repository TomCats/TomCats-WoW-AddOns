--[[ See license.txt for license and copyright information ]]
select(2, ...).SetScope()

function Throttle(obj, elapsed)
	obj.timeSinceLastUpdate = (obj.timeSinceLastUpdate or 0) + elapsed
	if (obj.timeSinceLastUpdate > obj.interval) then
		obj.timeSinceLastUpdate = 0
		return true
	end
	return false
end
