--[[ See license.txt for license and copyright information ]]
local _, addon = ...
local C_Timer = C_Timer
local time = time

function addon.newCache(minAge, frequency)
	minAge = minAge or 600
	frequency = frequency or 30
	local wcache = { }
	setmetatable(wcache,{ __mode = "v"})

	local cache = { }

	local function cleanCache()
		local expire = time() - minAge
		local expires
		for k, v in pairs(cache) do
			if (v < expire) then
				expires = expires or { }
				table.insert(expires, k)
			end
		end
		if (expires) then
			for i = 1, #expires do
				cache[expires[i]] = nil
			end
		end
	end

	C_Timer.NewTicker(frequency,cleanCache)

	return {
		add = function(key, value)
			wcache[key] = value
			cache[value] = time()
		end,
		get = function(key)
			if (wcache[key]) then
				cache[wcache[key]] = time()
				return wcache[key]
			end
		end
	}
end