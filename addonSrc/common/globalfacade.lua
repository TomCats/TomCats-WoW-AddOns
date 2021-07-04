local _, addon = ...

local globalFacade = { }
local allowedGlobals = { }

globalFacade._G = globalFacade

function globalFacade.getglobal(key)
	return _G[key]
end

function globalFacade.setglobal(key, value)
	_G[key] = value
end

setmetatable(globalFacade, {
	__index = function(self, key)
		if (allowedGlobals[key]) then
			return _G[key]
		end
		return rawget(self, key)
	end,
	__newindex = function(self, key, value)
		if (allowedGlobals[key]) then
			_G[key] = value
		else
			rawset(self, key, value)
		end
	end
})

function addon.SetupGlobalFacade()
	setfenv(2, globalFacade)
end

local function AddAllowedGlobal(variableName)
	if (allowedGlobals[variableName]) then
		error("Duplicate variable name")
	end
	allowedGlobals[variableName] = true
end

function addon.AddAllowedGlobals(variableNameOrNames)
	if (type(variableNameOrNames) == "table") then
		for _, v in ipairs(variableNameOrNames) do
			AddAllowedGlobal(v)
		end
	else
		AddAllowedGlobal(variableNameOrNames)
	end
end
