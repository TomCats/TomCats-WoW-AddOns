local addonName, addon = ...
local npcname = "Maelie the Wanderer"
local maelieFound
local targetMaelie
local TomCatsMaelieAlertSystem

local function StaticPopup_Show(arg1, arg2)
	if (arg1 == "ADDON_ACTION_FORBIDDEN" and addonName == arg2) then
		StaticPopup_Hide("ADDON_ACTION_FORBIDDEN")
	end
end
hooksecurefunc("StaticPopup_Show",StaticPopup_Show)

local frame = CreateFrame("Frame")
frame:RegisterEvent("ADDON_ACTION_FORBIDDEN")
frame:SetScript("OnEvent", function(self, event, _addonName, funcName)
	if (addonName == _addonName and "TargetUnit()" == funcName) then
		TomCatsMaelieAlertSystem:AddAlert()
		maelieFound = true
	end
end)

function targetMaelie()
	if (addon.IsBetaEnabled() and not maelieFound) then
		TargetUnit(npcname)
		C_Timer.NewTimer(0.5, targetMaelie)
		return
	end
	C_Timer.NewTimer(5, targetMaelie)
end

local function TomCatsMaelieAlertFrame_SetUp(frame)
	frame.Title:SetText("TomCat's Tours:");
	frame.Text:SetText("Maelie is Nearby!");
	PlaySound(SOUNDKIT.UI_AZERITE_EMPOWERED_ITEM_LOOT_TOAST)
end

local function OnEvent(event, arg1)
	if (event == "ADDON_LOADED") then
		if (addonName == arg1) then
			TomCatsMaelieAlertSystem = AlertFrame:AddQueuedAlertFrameSubSystem("TomCatsMaelieAlertFrameTemplate", TomCatsMaelieAlertFrame_SetUp);
			addon.UnregisterEvent("ADDON_LOADED", OnEvent)
			targetMaelie()
		end
	end
end

addon.RegisterEvent("ADDON_LOADED", OnEvent)
