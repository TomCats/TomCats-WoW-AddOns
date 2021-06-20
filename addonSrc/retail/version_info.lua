--[[ See license.txt for license and copyright information ]]
local addonName, addon = ...

local function OnEvent(event, arg1)
	local TomCats_Account = _G["TomCats_Account"]
	if (event == "PLAYER_STARTED_MOVING") then
		if (TomCats_Account.lastVersionSeen ~= "@version@") then
			TomCats_Account.lastVersionSeen = "@version@"
		end
		addon.UnregisterEvent("PLAYER_STARTED_MOVING", OnEvent)
	end
	if (event == "ADDON_LOADED" and addonName == arg1) then
		if (TomCats_Account.lastVersionSeen ~= "@version@") then
			addon.IsNewVersion = true
		end
		addon.UnregisterEvent("ADDON_LOADED", OnEvent)
	end
end

addon.RegisterEvent("PLAYER_STARTED_MOVING", OnEvent)
addon.RegisterEvent("ADDON_LOADED", OnEvent)
