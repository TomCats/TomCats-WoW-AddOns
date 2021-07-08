--[[ See license.txt for license and copyright information ]]
local addonName, addon = ...

local outdatedText = "TomCat's AddOn Suite is outdated:\n\nPlease update via the CurseForge app"
local ACCEPT_ALT = ACCEPT_ALT
local GetAddOnMetadata = GetAddOnMetadata
local GetServerTime = GetServerTime
local StaticPopup_Show = StaticPopup_Show
local StaticPopupDialogs = StaticPopupDialogs

local expiration = tonumber(GetAddOnMetadata("TomCats", "X-TomCats-Expiry"))

local function Isxpired()
	local serverTime = GetServerTime()
	return (serverTime >= expiration)
end

local function ShowExpirationPopup()
	if (TomCats_Static_Popup) then
		TomCats_Static_Popup.Text:SetText(outdatedText)
		TomCats_Static_Popup:Show()
	else
		StaticPopupDialogs["TOMCATS_ADDON_EXPIRED"] = {
			text = outdatedText,
			button1 = ACCEPT_ALT,
			whileDead = 1,
			hideOnEscape = 1
		};
		StaticPopup_Show("TOMCATS_ADDON_EXPIRED")
	end
end

local function OnEvent(event, arg1, arg2)
	if (event == "ADDON_LOADED") then
		if (addonName == arg1) then
			addon.UnregisterEvent("ADDON_LOADED", OnEvent)
			if (Isxpired()) then
				local localTime = GetServerTime()
				if (_G.TomCats_Account.lastExpirationWarning + 86400 <= localTime) then
					_G.TomCats_Account.lastExpirationWarning = localTime
					ShowExpirationPopup()
				end
			else
				_G.TomCats_Account.lastExpirationWarning = 0
			end
		end
		return
	end
end

addon.RegisterEvent("ADDON_LOADED", OnEvent)
