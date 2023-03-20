--[[ See license.txt for license and copyright information ]]
local addonName, addon = ...
local root = { }

root.addonName, root.addon = addonName, addon
root._G = _G
root.__G = root
root.SavedVariablesName = ("%s_Account"):format(root.addonName)
root.SavedVariablesPerCharacterName = ("%s_Character"):format(root.addonName)

setmetatable(root, {
	__index = function(self, key)
		local value = rawget(self,key)
		if (not value) then
			return _G[key]
		end
		return value
	end,
	__newindex = function(self, key, value)
		rawset(self, key, value)
	end
})

local scopeMetatable = {
	__index = function(self, key)
		local value = rawget(self,key)
		if (not value) then
			return root[key]
		end
		return value
	end,
	__newindex = function(self, key, value)
		rawset(self, key, value)
	end
}

function addon.InitScope(scopeName)
	if (scopeName == nil) then return root end
	root[scopeName] = root[scopeName] or { }
	setmetatable(root[scopeName] , scopeMetatable)
	return root[scopeName]
end

function addon.SetScope(scopeName)
	setfenv(2, addon.InitScope(scopeName))
end
