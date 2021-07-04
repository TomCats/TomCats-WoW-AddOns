local addonName, addon = ...
local renamedVariablePattern = addonName .. "_%s"

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

local function AddAllowedGlobal(variableName, newName)
	if (allowedGlobals[variableName]) then
		error("Duplicate variable name")
	end
	allowedGlobals[variableName] = newName
end

function addon.AddAllowedGlobals(variableNameOrNames)
	if (type(variableNameOrNames) == "table") then
		for _, v in ipairs(variableNameOrNames) do
			AddAllowedGlobal(v, v)
		end
	else
		AddAllowedGlobal(variableNameOrNames, variableNameOrNames)
	end
end

function addon.AddRenamedGlobals(variableNameOrNames)
	if (type(variableNameOrNames) == "table") then
		for _, v in ipairs(variableNameOrNames) do
			AddAllowedGlobal(v, renamedVariablePattern:format(v))
		end
	else
		AddAllowedGlobal(variableNameOrNames, renamedVariablePattern:format(variableNameOrNames))
	end
end
