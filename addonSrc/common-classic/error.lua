--[[ See license.txt for license and copyright information ]]
local addonName, addon = ...

local errorLoadingPrefix1 = "Error loading Interface\\AddOns\\TomCats\\"
local errorLoadingPrefix2 = "Couldn't open Interface\\AddOns\\TomCats\\"
local loadingErrorText = "One or more of your addon files has been updated and requires you to restart World of Warcraft."

local errorLoadingMessageDispatched = false

local function ShowErrorLoadingPopup()
	if (TomCats_Static_Popup) then
		TomCats_Static_Popup.Text:SetText(loadingErrorText)
		TomCats_Static_Popup:Show()
	else
		StaticPopupDialogs["TOMCATS_ERROR_LOADING"] = {
			text = loadingErrorText,
			button1 = ACCEPT_ALT,
			whileDead = 1,
			hideOnEscape = 1
		};
		StaticPopup_Show("TOMCATS_ERROR_LOADING")
	end
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
		if ((not errorLoadingMessageDispatched) and
				(string.sub(arg2, 1, string.len(errorLoadingPrefix1)) == errorLoadingPrefix1 or
						string.sub(arg2, 1, string.len(errorLoadingPrefix2)) == errorLoadingPrefix2
				)
		) then
			errorLoadingMessageDispatched = true
			ShowErrorLoadingPopup()
		end
	end
end

addon.RegisterEvent("LUA_WARNING", OnEvent)
addon.RegisterEvent("ADDON_LOADED", OnEvent)
