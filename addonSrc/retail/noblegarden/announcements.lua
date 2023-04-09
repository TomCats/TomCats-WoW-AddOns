local _, addon = ...
if (not addon.noblegarden.IsEventActive()) then return end

--if (not GetCVar("TomCatsAnnouncement")) then
	local eventFrame = CreateFrame("Frame")
	local function ADDON_LOADED(_, _, addonName)
		if (addonName == "TomCats") then
			eventFrame:UnregisterEvent("ADDON_LOADED")
			C_Timer.NewTimer(5, function()
				ChatFrame1:AddMessage("|TInterface/AddOns/TomCats/images/tomcat_chat_icon_lg.blp:16:32:0:2:64:64:0:64:0:32|t|cff00ff00 Noblegarden has arrived!|r")
				ChatFrame1:AddMessage("|TInterface/AddOns/TomCats/images/tomcat_chat_icon_lg.blp:16:32:0:2:64:64:0:64:32:64|t|cffffff00 Type /tomcats for settings|r")
			end)
		end
	end
	eventFrame:SetScript("OnEvent", ADDON_LOADED)
	eventFrame:RegisterEvent("ADDON_LOADED")
--end
