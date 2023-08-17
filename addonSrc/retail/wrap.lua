local addonName, addon = ...

local wrapMetatable = {
	__index = function(t, k)
		local real = t.wrapped[k]
		if (type(real) == "function") then
			local newFunction = function(...)
				local _, result = xpcall(real, geterrorhandler(),...)
				return result
			end
			t[k] = newFunction
			return newFunction
		end
		return real
	end,
	__newindex = function(t, k, v)
		t.wrapped[k] = v
	end
}

function addon.wrap(table)
	local newTable = { wrapped = table }
	setmetatable(newTable, wrapMetatable)
	return newTable
end
