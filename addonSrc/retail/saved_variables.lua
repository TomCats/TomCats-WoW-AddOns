--[[ See license.txt for license and copyright information ]]
local addonName, addon = ...

local defaultSavedVariables = addon.defaultSavedVariables or { }
local HINT_ALL = addon.constants.HINT_ALL

local function OverlayVariables(template, overlay)
	local newVars = { }
	for k, v in pairs(template) do
		if (overlay[k] ~= nil and type(v) == type(overlay[k])) then
			if (type(v) == "table") then
				newVars[k] = (v == HINT_ALL or v == HINT_ALL) and overlay[k] or OverlayVariables(v, overlay[k])
			else
				newVars[k] = overlay[k]
			end
		else
			newVars[k] = (v == HINT_ALL) and { } or v
		end
	end
	return newVars
end

local function OnEvent(event, arg1)
	if (event == "ADDON_LOADED") then
		if (addonName == arg1) then
			for k, v in pairs(defaultSavedVariables) do
				_G[k] = OverlayVariables(v, _G[k] or { })
				-- todo: remove later: backwards compatibility with var change
				if (TomCats_Account.preferences.AccessoryWindow.display ~= addon.constants.accessoryDisplay.REMOVED) then
					TomCats_Account.preferences.AccessoryWindow.elementalStorms = TomCats_Account.preferences.AccessoryWindow.display
					TomCats_Account.preferences.AccessoryWindow.display = addon.constants.accessoryDisplay.REMOVED
				end
			end
			addon.UnregisterEvent("ADDON_LOADED", OnEvent)
		end
	end
end

addon.RegisterEvent("ADDON_LOADED", OnEvent)
