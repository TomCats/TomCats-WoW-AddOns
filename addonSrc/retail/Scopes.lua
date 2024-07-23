--[[ See license.txt for license and copyright information ]]
local addonName, addon = ...
local root = { }

root.addonName, root.addon = addonName, addon
root._G = _G
root.__G = root
root.SavedVariablesName = ("%s_Account"):format(root.addonName)
root.SavedVariablesPerCharacterName = ("%s_Character"):format(root.addonName)

local directReferences = {
	ColorMixin = ColorMixin,
	ItemLocationMixin = ItemLocationMixin,
	ItemTransmogInfoMixin = ItemTransmogInfoMixin,
	PlayerLocationMixin = PlayerLocationMixin,
	ReportInfoMixin = ReportInfoMixin,
	TransmogLocationMixin = TransmogLocationMixin,
	TransmogPendingInfoMixin = TransmogPendingInfoMixin,
	Vector2DMixin = Vector2DMixin,
	Vector3DMixin = Vector3DMixin,
}

local function applyDirectReferences(scope)
	for k, v in pairs(directReferences) do
		scope[k]= v
	end
end

applyDirectReferences(root)

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
	local scope = root[scopeName]
	if (not scope) then
		scope = { }
		applyDirectReferences(scope)
		setmetatable(scope , scopeMetatable)
		root[scopeName] = scope
	end
	return scope
end

function addon.SetScope(scopeName)
	setfenv(2, addon.InitScope(scopeName))
end
