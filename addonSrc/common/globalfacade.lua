--[[ See license.txt for license and copyright information ]]
local addonName, addon = ...
local renamedVariablePattern = addonName .. "_%s"

local globalFacade = {
	addonName = addonName,
	addon = addon
}

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
		local allowedGlobal = allowedGlobals[key]
		if (allowedGlobal) then
			return _G[allowedGlobal]
		end
		return rawget(self, key)
	end,
	__newindex = function(self, key, value)
		local allowedGlobal = allowedGlobals[key]
		if (allowedGlobal) then
			_G[allowedGlobal] = value
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
		error(("Duplicate variable name: %s"):format(variableName))
	end
	allowedGlobals[variableName] = newName
end

function globalFacade.AddAllowedGlobals(variableNameOrNames)
	if (type(variableNameOrNames) == "table") then
		for _, v in ipairs(variableNameOrNames) do
			AddAllowedGlobal(v, v)
		end
	else
		AddAllowedGlobal(variableNameOrNames, variableNameOrNames)
	end
end

function globalFacade.AddRenamedGlobals(variableNameOrNames)
	if (type(variableNameOrNames) == "table") then
		for _, v in ipairs(variableNameOrNames) do
			AddAllowedGlobal(v, renamedVariablePattern:format(v))
		end
	else
		AddAllowedGlobal(variableNameOrNames, renamedVariablePattern:format(variableNameOrNames))
	end
end
