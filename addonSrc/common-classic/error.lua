--[[ See license.txt for license and copyright information ]]
local addonName, addon = ...

local errorLoadingPrefix = "Error loading Interface\\AddOns\\TomCats\\"
local errorLoadingMessageDispatched = false

local function ShowErrorLoadingPopup()
	StaticPopupDialogs["TOMCATS_ERROR_LOADING"] = {
		text = "One or more of your addon files has been updated and requires you to restart the game client in order to function correctly.",
		button1 = ACCEPT_ALT,
		whileDead = 1,
		hideOnEscape = 1
	};
	StaticPopup_Show("TOMCATS_ERROR_LOADING")
end

local function OnEvent(event, arg1, arg2)
	if (event == "ADDON_LOADED") then
		if (addonName == arg1) then
			addon.UnregisterEvent("ADDON_LOADED", OnEvent)
			C_Timer.NewTimer(0, function()
				addon.UnregisterEvent("LUA_WARNING", OnEvent)
			end)
		end
		return
	end
	if (event == "LUA_WARNING") then
		if ((not errorLoadingMessageDispatched) and string.sub(arg2, 1, string.len(errorLoadingPrefix)) == errorLoadingPrefix) then
			errorLoadingMessageDispatched = true
			ShowErrorLoadingPopup()
		end
	end
end

addon.RegisterEvent("LUA_WARNING", OnEvent)
addon.RegisterEvent("ADDON_LOADED", OnEvent)
