--[[ See license.txt for license and copyright information ]]
local addonName, addon = ...

local betaEnabled = false

function addon.IsBetaEnabled()
	return betaEnabled
end

function addon.SetBetaEnabled(enable)
	betaEnabled = enable or false
	TomCats_Account.preferences.betaEnabled = enable or false
	if (addon.EnableArrows) then
		addon.EnableArrows(enable)
	end
end

local function OnEvent(event, arg1)
	if (event == "ADDON_LOADED") then
		if (addonName == arg1) then
			addon.SetBetaEnabled(TomCats_Account.preferences.betaEnabled)
			addon.UnregisterEvent("ADDON_LOADED", OnEvent)
		end
	end
end

addon.RegisterEvent("ADDON_LOADED", OnEvent)
