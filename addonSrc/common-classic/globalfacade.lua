--[[ See license.txt for license and copyright information ]]
local addonName, addon = ...
local renamedVariablePattern = addonName .. "_%s"

local globalFacade = {
	addonName = addonName,
	addon = addon
}

local allowedGlobals = { }

local matchingGlobals = { }

globalFacade._G = globalFacade

function globalFacade.getglobal(key)
	return _G[key]
end

function globalFacade.setglobal(key, value)
	_G[key] = value
end

setmetatable(globalFacade, {
	__index = function(self, key)
		--local val = (function(self, key)
			local allowedGlobal = allowedGlobals[key]
			if (allowedGlobal) then
				return _G[allowedGlobal]
			end
			local value = rawget(self,key)
			if (not value) then
				if (string.match(key, "^TomCats_.*")) then
					globalFacade.AddAllowedGlobals(key)
					return _G[key]
				end
				for _, v in ipairs(matchingGlobals) do
					if (string.match(key, v)) then
						local newname = renamedVariablePattern:format(key)
						globalFacade.AddRenamedGlobals(key)
						return _G[newname]
					end
				end
			end
			return value
		--end)(self, key)
		--if (not val) then print(key) end
		--return val
	end,
	__newindex = function(self, key, value)
		local allowedGlobal = allowedGlobals[key]
		if (allowedGlobal) then
			_G[allowedGlobal] = value
		else
			for _, v in ipairs(matchingGlobals) do
				if (string.match(key, v)) then
					local newname = renamedVariablePattern:format(key)
					globalFacade.AddRenamedGlobals(key)
					_G[newname] = value
					return
				end
			end
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

function globalFacade.AddDynamicallyRenamedGlobals(variableMatchOrMatches)
	if (type(variableMatchOrMatches) == "table") then
		for _, v in ipairs(variableMatchOrMatches) do
			table.insert(matchingGlobals, v)
		end
	else
		table.insert(matchingGlobals, variableMatchOrMatches)
	end
end

TOMCATS_GLOBAL = globalFacade