local _, addon = ...
if (not addon.loveisintheair.IsEventActive()) then return end

--if (not GetCVar("TomCatsAnnouncement")) then
	local eventFrame = CreateFrame("Frame")
	local function ADDON_LOADED(_, _, addonName)
		if (addonName == "TomCats") then
			eventFrame:UnregisterEvent("ADDON_LOADED")
			C_Timer.NewTimer(5, function()
				if (addon.loveisintheair.IsEventSoon()) then
					ChatFrame1:AddMessage("|TInterface/AddOns/TomCats/images/tomcat_chat_icon_lg.blp:16:32:0:2:64:64:0:64:0:32|t|cff00ff00 Love is in the air is arriving soon!|r")
				else
					ChatFrame1:AddMessage("|TInterface/AddOns/TomCats/images/tomcat_chat_icon_lg.blp:16:32:0:2:64:64:0:64:0:32|t|cff00ff00 Love is in the Air has arrived!|r")
				end
				ChatFrame1:AddMessage("|TInterface/AddOns/TomCats/images/tomcat_chat_icon_lg.blp:16:32:0:2:64:64:0:64:32:64|t|cffffff00 Type /tomcats for more info|r")
			end)
		end
	end
	eventFrame:SetScript("OnEvent", ADDON_LOADED)
	eventFrame:RegisterEvent("ADDON_LOADED")
--end
