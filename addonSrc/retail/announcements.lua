local _, addon = ...
local eventFrame = CreateFrame("Frame")
local function ADDON_LOADED(_, _, addonName)
	if (addonName == "TomCats") then
		eventFrame:UnregisterEvent("ADDON_LOADED")
		C_Timer.NewTimer(5, function()
			ChatFrame1:AddMessage("|TInterface/AddOns/TomCats/images/tomcat_chat_icon_lg.blp:16:32:0:2:64:64:0:64:0:32|t|cff00ff00 Zereth Mortis is here!|r")
			ChatFrame1:AddMessage("|TInterface/AddOns/TomCats/images/tomcat_chat_icon_lg.blp:16:32:0:2:64:64:0:64:32:64|t|cffffff00 Type /tomcats for more info|r")
			ChatFrame1:AddMessage("Please be patient while I continuously update this addon in the upcoming days! Thank you for supporting TomCat's Tours <3")
		end)
	end
end
eventFrame:SetScript("OnEvent", ADDON_LOADED)
eventFrame:RegisterEvent("ADDON_LOADED")
